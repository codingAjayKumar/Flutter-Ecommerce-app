import 'package:ecommerce_admin_app/containers/additional_confirm.dart';
import 'package:ecommerce_admin_app/controllers/db_service.dart';
import 'package:ecommerce_admin_app/models/products_model.dart';
import 'package:ecommerce_admin_app/providers/admin_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProductsPage extends StatefulWidget {
  const ProductsPage({super.key});

  @override
  State<ProductsPage> createState() => _ProductsPageState();
}

class _ProductsPageState extends State<ProductsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Products"),
        backgroundColor: Colors.deepPurple.shade700,
        foregroundColor: Colors.white,
      ),
      body: Consumer<AdminProvider>(
        builder: (context, value, child) {
          List<ProductsModel> products =
              ProductsModel.fromJsonList(value.products) as List<ProductsModel>;

          if (products.isEmpty) {
            return Center(
              child: Text(
                "No Products Found",
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey),
              ),
            );
          }

          return ListView.builder(
            itemCount: products.length,
            itemBuilder: (context, index) {
              return Card(
                shadowColor: Colors.deepPurple.shade700,
                margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                elevation: 4,
                child: ListTile(
                  onLongPress: () {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: Text("Choose an action",
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        content: Text(
                            "Select whether you want to update or delete the product."),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context); // Close the dialog
                              showDialog(
                                context: context,
                                builder: (context) => AdditionalConfirm(
                                  contentText:
                                      "Are you sure you want to delete this product?",
                                  onYes: () {
                                    DbService().deleteProduct(
                                        docId: products[index].id);
                                    Navigator.pop(
                                        context); // Close the delete confirmation dialog
                                  },
                                  onNo: () {
                                    Navigator.pop(
                                        context); // Close the delete confirmation dialog
                                  },
                                ),
                              );
                            },
                            child: Text("Delete Product",
                                style: TextStyle(color: Colors.red)),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context); // Close the dialog
                              // Navigate to edit product page
                              Navigator.pushNamed(context, "/add_product",
                                  arguments: products[index]);
                            },
                            child: Text("Edit Product",
                                style: TextStyle(
                                    color: Colors.deepPurple.shade700)),
                          ),
                        ],
                      ),
                    );
                  },
                  onTap: () => Navigator.pushNamed(context, "/view_product",
                      arguments: products[index]),
                  leading: Container(
                    height: 50,
                    width: 50,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.grey.shade300),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.network(
                        products[index].image,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  title: Text(
                    products[index].name,
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  subtitle: Padding(
                    padding: const EdgeInsets.only(top: 4.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "₹ ${products[index].new_price.toString()}",
                          style: TextStyle(
                              fontSize: 14, fontWeight: FontWeight.w500),
                        ),
                        Container(
                          padding:
                              EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: Theme.of(context).primaryColor,
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: Text(
                            products[index].category.toUpperCase(),
                            style: TextStyle(color: Colors.white, fontSize: 12),
                          ),
                        ),
                      ],
                    ),
                  ),
                  trailing: IconButton(
                    icon: Icon(Icons.edit, color: Colors.deepPurple.shade700),
                    onPressed: () {
                      // Prompting user for confirmation to update or delete the product
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: Text("Update or Delete Product",
                              style: TextStyle(fontWeight: FontWeight.bold)),
                          content: Text(
                              "Do you want to update or delete this product?"),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context); // Close the dialog
                                // Navigate to edit product page
                                Navigator.pushNamed(context, "/add_product",
                                    arguments: products[index]);
                              },
                              child: Text("Update",
                                  style: TextStyle(color: Colors.green)),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context); // Close the dialog
                                showDialog(
                                  context: context,
                                  builder: (context) => AdditionalConfirm(
                                    contentText:
                                        "Are you sure you want to delete this product?",
                                    onYes: () {
                                      DbService().deleteProduct(
                                          docId: products[index].id);
                                      Navigator.pop(
                                          context); // Close the delete confirmation dialog
                                    },
                                    onNo: () {
                                      Navigator.pop(
                                          context); // Close the delete confirmation dialog
                                    },
                                  ),
                                );
                              },
                              child: Text("Delete",
                                  style: TextStyle(color: Colors.red)),
                            ),
                          ],
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
        backgroundColor: Colors.deepPurple.shade700,
        child: Icon(Icons.add_shopping_cart_sharp, color: Colors.white),
        onPressed: () {
          Navigator.pushNamed(context, "/add_product");
        },
      ),
    );
  }
}
