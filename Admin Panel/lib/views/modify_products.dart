import 'dart:io';
import 'package:ecommerce_admin_app/controllers/cloudinary_service.dart';
import 'package:ecommerce_admin_app/controllers/db_service.dart';
import 'package:ecommerce_admin_app/models/products_model.dart';
import 'package:ecommerce_admin_app/providers/admin_provider.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class ModifyProduct extends StatefulWidget {
  const ModifyProduct({super.key});

  @override
  State<ModifyProduct> createState() => _ModifyProductState();
}

class _ModifyProductState extends State<ModifyProduct> {
  late String productId = "";
  final formKey = GlobalKey<FormState>();
  TextEditingController nameController = TextEditingController();
  TextEditingController oldPriceController = TextEditingController();
  TextEditingController newPriceController = TextEditingController();
  TextEditingController quantityController = TextEditingController();
  TextEditingController categoryController = TextEditingController();
  TextEditingController descController = TextEditingController();
  TextEditingController imageController = TextEditingController();
  final ImagePicker picker = ImagePicker();
  late XFile? image = null;

  // NEW: upload to cloudinary
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
  setData(ProductsModel data) {
    productId = data.id;
    nameController.text = data.name;
    oldPriceController.text = data.old_price.toString();
    newPriceController.text = data.new_price.toString();
    quantityController.text = data.maxQuantity.toString();
    categoryController.text = data.category;
    descController.text = data.description;
    imageController.text = data.image;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final arguments = ModalRoute.of(context)!.settings.arguments;
    if (arguments != null && arguments is ProductsModel) {
      setData(arguments);
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple.shade700,
        foregroundColor: Colors.white,
        title: Text(
          productId.isNotEmpty ? "Update Product" : "Add Product",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
        elevation: 10,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
          child: Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormField(
                  controller: nameController,
                  validator: (v) => v!.isEmpty ? "This can't be empty." : null,
                  decoration: InputDecoration(
                    hintText: "Enter product name",
                    labelText: "Product Name",
                    filled: true,
                    fillColor: Colors.deepPurple.shade50,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.0),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                  ),
                ),
                SizedBox(height: 16),
                _buildTextFormField(
                  controller: oldPriceController,
                  label: "Original Price",
                  hint: "Enter original price",
                  keyboardType: TextInputType.number,
                ),
                SizedBox(height: 16),
                _buildTextFormField(
                  controller: newPriceController,
                  label: "Sell Price",
                  hint: "Enter sell price",
                  keyboardType: TextInputType.number,
                ),
                SizedBox(height: 16),
                _buildTextFormField(
                  controller: quantityController,
                  label: "Quantity Left",
                  hint: "Enter quantity",
                  keyboardType: TextInputType.number,
                ),
                SizedBox(height: 16),
                GestureDetector(
                  onTap: () {
                    _showCategoryPicker(context);
                  },
                  child: AbsorbPointer(
                    child: _buildTextFormField(
                      controller: categoryController,
                      label: "Category",
                      hint: "Select product category",
                    ),
                  ),
                ),
                SizedBox(height: 16),
                TextFormField(
                  controller: descController,
                  validator: (v) => v!.isEmpty ? "This can't be empty." : null,
                  decoration: InputDecoration(
                    hintText: "Enter product description",
                    labelText: "Description",
                    filled: true,
                    fillColor: Colors.deepPurple.shade50,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.0),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                  ),
                  maxLines: 4,
                ),
                SizedBox(height: 16),
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
                ElevatedButton.icon(
                  onPressed: _pickImageAndCloudinaryUpload,
                  icon: Icon(Icons.upload_file),
                  label: Text("Pick Image"),
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                    backgroundColor: Colors.deepPurple.shade700,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                  ),
                ),
                SizedBox(height: 16),
                TextFormField(
                  controller: imageController,
                  validator: (v) => v!.isEmpty ? "This can't be empty." : null,
                  decoration: InputDecoration(
                    hintText: "Image URL",
                    labelText: "Image URL",
                    filled: true,
                    fillColor: Colors.deepPurple.shade50,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.0),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                  ),
                ),
                SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () {
                      if (formKey.currentState!.validate()) {
                        Map<String, dynamic> data = {
                          "name": nameController.text,
                          "old_price": int.parse(oldPriceController.text),
                          "new_price": int.parse(newPriceController.text),
                          "quantity": int.parse(quantityController.text),
                          "category": categoryController.text,
                          "desc": descController.text,
                          "image": imageController.text,
                        };

                        if (productId.isNotEmpty) {
                          DbService()
                              .updateProduct(docId: productId, data: data);
                          Navigator.pop(context);
                          ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text("Product Updated")));
                        } else {
                          DbService().createProduct(data: data);
                          Navigator.pop(context);
                          ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text("Product Added")));
                        }
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Colors.deepPurple.shade700,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                    ),
                    child: Text(
                      productId.isNotEmpty ? "Update Product" : "Add Product",
                      style: TextStyle(fontSize: 16),
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

  // Helper method for creating a styled text field
  Widget _buildTextFormField({
    required TextEditingController controller,
    required String label,
    required String hint,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      validator: (v) => v!.isEmpty ? "This can't be empty." : null,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        filled: true,
        fillColor: Colors.deepPurple.shade50,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: BorderSide.none,
        ),
        contentPadding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      ),
    );
  }

  // Helper method for category picker
  void _showCategoryPicker(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Select Category:"),
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Consumer<AdminProvider>(
              builder: (context, value, child) => SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: value.categories
                      .map((e) => TextButton(
                            onPressed: () {
                              categoryController.text = e["name"];
                              setState(() {});
                              Navigator.pop(context);
                            },
                            child: Text(e["name"]),
                          ))
                      .toList(),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
