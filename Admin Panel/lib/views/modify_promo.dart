import 'dart:io';

import 'package:ecommerce_admin_app/controllers/cloudinary_service.dart';
import 'package:ecommerce_admin_app/controllers/db_service.dart';
import 'package:ecommerce_admin_app/controllers/storage_service.dart';
import 'package:ecommerce_admin_app/models/products_model.dart';
import 'package:ecommerce_admin_app/models/promo_banners_model.dart';
import 'package:ecommerce_admin_app/providers/admin_provider.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class ModifyPromo extends StatefulWidget {
  const ModifyPromo({super.key});

  @override
  State<ModifyPromo> createState() => _ModifyPromoState();
}

class _ModifyPromoState extends State<ModifyPromo> {
  late String productId = "";
  final formKey = GlobalKey<FormState>();
  TextEditingController titleController = TextEditingController();
  TextEditingController categoryController = TextEditingController();
  TextEditingController imageController = TextEditingController();
  final ImagePicker picker = ImagePicker();
  late XFile? image = null;

  bool _isInitialized = false;
  bool _isPromo = true;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_isInitialized) {
        final arguments = ModalRoute.of(context)?.settings.arguments;
        if (arguments != null && arguments is Map<String, dynamic>) {
          if (arguments["detail"] is PromoBannersModel) {
            setData(arguments["detail"] as PromoBannersModel);
          }
          _isPromo = arguments['promo'] ?? true;
        }
        _isInitialized = true;
      }
    });
  }

  // NEW : upload to cloudinary
  void _pickImageAndCloudinaryUpload() async {
    image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      String? res = await uploadToCloudinary(image);
      setState(() {
        if (res != null) {
          imageController.text = res;
          print("set image url ${res} : ${imageController.text}");
          ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Image uploaded successfully")));
        }
      });
    }
  }

  // set the data from arguments
  setData(PromoBannersModel data) {
    productId = data.id;
    titleController.text = data.title;
    categoryController.text = data.category;
    imageController.text = data.image;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(productId.isNotEmpty
            ? _isPromo
                ? "Update Promo"
                : "Update Banner"
            : _isPromo
                ? "Add Promo"
                : "Add Banner"),
        backgroundColor: Colors.deepPurple.shade700,
        foregroundColor: Colors.white,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.deepPurple.shade700, Colors.deepPurple.shade900],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        elevation: 10, // Add shadow for AppBar
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title Input
                TextFormField(
                  controller: titleController,
                  validator: (v) => v!.isEmpty ? "This can't be empty." : null,
                  decoration: InputDecoration(
                    hintText: "Title",
                    label: Text("Title"),
                    fillColor: Colors.deepPurple.shade50,
                    filled: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
                SizedBox(height: 10),

                // Category Input
                TextFormField(
                  controller: categoryController,
                  validator: (v) => v!.isEmpty ? "This can't be empty." : null,
                  readOnly: true,
                  decoration: InputDecoration(
                    hintText: "Category",
                    label: Text("Category"),
                    fillColor: Colors.deepPurple.shade50,
                    filled: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: Text("Select Category :"),
                        content: Consumer<AdminProvider>(
                          builder: (context, value, child) =>
                              SingleChildScrollView(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: value.categories
                                  .map((e) => TextButton(
                                        onPressed: () {
                                          categoryController.text = e["name"];
                                          Navigator.pop(context);
                                        },
                                        child: Text(e["name"]),
                                      ))
                                  .toList(),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
                SizedBox(height: 10),

                // Image Preview
                image == null
                    ? imageController.text.isNotEmpty
                        ? Container(
                            margin: EdgeInsets.all(20),
                            height: 100,
                            width: double.infinity,
                            color: Colors.deepPurple.shade50,
                            child: Image.network(
                              imageController.text,
                              fit: BoxFit.contain,
                            ),
                          )
                        : SizedBox()
                    : Container(
                        margin: EdgeInsets.all(20),
                        height: 200,
                        width: double.infinity,
                        color: Colors.deepPurple.shade50,
                        child: Image.file(
                          File(image!.path),
                          fit: BoxFit.contain,
                        ),
                      ),
                ElevatedButton(
                  onPressed: () {
                    _pickImageAndCloudinaryUpload();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurple.shade700,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text("Pick Image"),
                ),
                SizedBox(height: 10),

                // Image Link Input
                TextFormField(
                  controller: imageController,
                  validator: (v) => v!.isEmpty ? "This can't be empty." : null,
                  decoration: InputDecoration(
                    hintText: "Image Link",
                    label: Text("Image Link"),
                    fillColor: Colors.deepPurple.shade50,
                    filled: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
                SizedBox(height: 10),

                // Submit Button
                SizedBox(
                  height: 60,
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      if (formKey.currentState!.validate()) {
                        Map<String, dynamic> data = {
                          "title": titleController.text,
                          "category": categoryController.text,
                          "image": imageController.text
                        };

                        if (productId.isNotEmpty) {
                          DbService().updatePromos(
                              id: productId, data: data, isPromo: _isPromo);
                          Navigator.pop(context);
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text(
                                "${_isPromo ? "Promo" : "Banner"} Updated"),
                          ));
                        } else {
                          DbService()
                              .createPromos(data: data, isPromo: _isPromo);
                          Navigator.pop(context);
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content:
                                Text("${_isPromo ? "Promo" : "Banner"} Added"),
                          ));
                        }
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepPurple.shade700,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      productId.isNotEmpty
                          ? _isPromo
                              ? "Update Promo"
                              : "Update Banner"
                          : _isPromo
                              ? "Add Promo"
                              : "Add Banner",
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
