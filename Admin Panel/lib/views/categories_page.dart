import 'dart:io';

import 'package:ecommerce_admin_app/containers/additional_confirm.dart';
import 'package:ecommerce_admin_app/controllers/cloudinary_service.dart';
import 'package:ecommerce_admin_app/controllers/db_service.dart';
import 'package:ecommerce_admin_app/models/categories_model.dart';
import 'package:ecommerce_admin_app/providers/admin_provider.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class CategoriesPage extends StatefulWidget {
  const CategoriesPage({super.key});

  @override
  State<CategoriesPage> createState() => _CategoriesPageState();
}

class _CategoriesPageState extends State<CategoriesPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Categories"),
        backgroundColor: Colors.deepPurple.shade700,
        foregroundColor: Colors.white,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.deepPurple.shade700],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        elevation: 10, // Add shadow for AppBar
      ),
      body: Consumer<AdminProvider>(
        builder: (context, value, child) {
          List<CategoriesModel> categories =
              CategoriesModel.fromJsonList(value.categories);
          if (value.categories.isEmpty) {
            return Center(
              child: Text("No Categories Found",
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black45)),
            );
          }
          return ListView.builder(
            itemCount: value.categories.length,
            itemBuilder: (context, index) {
              return Card(
                shadowColor: Colors.deepPurple.shade700,
                margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                elevation: 5, // Add shadow for each card
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15), // Rounded corners
                ),
                child: ListTile(
                  leading: Container(
                    height: 50,
                    width: 50,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      image: DecorationImage(
                        image: NetworkImage(categories[index].image == null ||
                                categories[index].image == ""
                            ? "https://demofree.sirv.com/nope-not-here.jpg"
                            : categories[index].image),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: Text("What do you want to do?"),
                        content: Text("Delete action cannot be undone"),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                              showDialog(
                                context: context,
                                builder: (context) => AdditionalConfirm(
                                  contentText:
                                      "Are you sure you want to delete this?",
                                  onYes: () {
                                    DbService().deleteCategories(
                                        docId: categories[index].id);
                                    Navigator.pop(context);
                                  },
                                  onNo: () {
                                    Navigator.pop(context);
                                  },
                                ),
                              );
                            },
                            child: Text("Delete Category",
                                style: TextStyle(color: Colors.red)),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                              showDialog(
                                context: context,
                                builder: (context) => ModifyCategory(
                                  isUpdating: true,
                                  categoryId: categories[index].id,
                                  priority: categories[index].priority,
                                  image: categories[index].image,
                                  name: categories[index].name,
                                ),
                              );
                            },
                            child: Text("Update Category",
                                style: TextStyle(color: Colors.blue)),
                          ),
                        ],
                      ),
                    );
                  },
                  title: Text(
                    categories[index].name,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text("Priority : ${categories[index].priority}",
                      style: TextStyle(color: Colors.black54)),
                  trailing: IconButton(
                    icon: Icon(Icons.edit, color: Colors.deepPurple.shade700),
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) => ModifyCategory(
                          isUpdating: true,
                          categoryId: categories[index].id,
                          priority: categories[index].priority,
                          image: categories[index].image,
                          name: categories[index].name,
                        ),
                      );
                    },
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) => ModifyCategory(
              isUpdating: false,
              categoryId: "",
              priority: 0,
            ),
          );
        },
        backgroundColor: Colors.deepPurple.shade700,
        child: Icon(Icons.category_outlined, color: Colors.white),
        elevation: 8, // Add shadow for floating action button
      ),
    );
  }
}

class ModifyCategory extends StatefulWidget {
  final bool isUpdating;
  final String? name;
  final String categoryId;
  final String? image;
  final int priority;
  const ModifyCategory(
      {super.key,
      required this.isUpdating,
      this.name,
      required this.categoryId,
      this.image,
      required this.priority});

  @override
  State<ModifyCategory> createState() => _ModifyCategoryState();
}

class _ModifyCategoryState extends State<ModifyCategory> {
  final formKey = GlobalKey<FormState>();
  final ImagePicker picker = ImagePicker();
  late XFile? image = null;
  TextEditingController categoryController = TextEditingController();
  TextEditingController imageController = TextEditingController();
  TextEditingController priorityController = TextEditingController();

  @override
  void initState() {
    if (widget.isUpdating && widget.name != null) {
      categoryController.text = widget.name!;
      imageController.text = widget.image!;
      priorityController.text = widget.priority.toString();
    }
    super.initState();
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

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        widget.isUpdating ? "Update Category" : "Add Category",
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.deepPurple.shade700,
        ),
      ),
      content: SingleChildScrollView(
        child: Form(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "All will be converted to lowercase",
                style: TextStyle(
                  color: Colors.deepPurple.shade500,
                  fontSize: 14,
                ),
              ),
              SizedBox(
                height: 10,
              ),
              // Category Name Input
              TextFormField(
                controller: categoryController,
                validator: (v) => v!.isEmpty ? "This can't be empty." : null,
                decoration: InputDecoration(
                  hintText: "Category Name",
                  label: Text("Category Name"),
                  fillColor: Colors.grey.shade50,
                  filled: true,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                "This will be used in ordering categories",
                style: TextStyle(
                  color: Colors.deepPurple.shade500,
                  fontSize: 14,
                ),
              ),
              SizedBox(
                height: 10,
              ),
              // Priority Input
              TextFormField(
                controller: priorityController,
                validator: (v) => v!.isEmpty ? "This can't be empty." : null,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  hintText: "Priority",
                  label: Text("Priority"),
                  fillColor: Colors.grey.shade50,
                  filled: true,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              // Image Preview
              image == null
                  ? imageController.text.isNotEmpty
                      ? Container(
                          margin: EdgeInsets.all(20),
                          height: 200,
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
              // Pick Image Button
              ElevatedButton(
                onPressed: () {
                  // Pick Image and Upload
                  _pickImageAndCloudinaryUpload();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple.shade700,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text("Select Image"),
              ),
              SizedBox(
                height: 10,
              ),
              // Image Link Input
              TextFormField(
                controller: imageController,
                validator: (v) => v!.isEmpty ? "This can't be empty." : null,
                decoration: InputDecoration(
                  hintText: "Image Link",
                  label: Text("Image Link"),
                  fillColor: Colors.grey.shade50,
                  filled: true,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      actions: [
        // Cancel Button
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          style: TextButton.styleFrom(
            foregroundColor: Colors.deepPurple.shade700,
          ),
          child: Text(
            "Cancel",
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        // Add/Update Button
        TextButton(
          onPressed: () async {
            if (formKey.currentState!.validate()) {
              if (widget.isUpdating) {
                // Update Category
                await DbService()
                    .updateCategories(docId: widget.categoryId, data: {
                  "name": categoryController.text.toLowerCase(),
                  "image": imageController.text,
                  "priority": int.parse(priorityController.text)
                });
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text("Category Updated"),
                ));
              } else {
                // Add Category
                await DbService().createCategories(data: {
                  "name": categoryController.text.toLowerCase(),
                  "image": imageController.text,
                  "priority": int.parse(priorityController.text)
                });
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text("Category Added"),
                ));
              }
              Navigator.pop(context);
            }
          },
          style: TextButton.styleFrom(
            backgroundColor: Colors.deepPurple.shade700,
          ),
          child: Text(
            widget.isUpdating ? "Update" : "Add",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }
}
