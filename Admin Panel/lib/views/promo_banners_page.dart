import 'package:ecommerce_admin_app/containers/additional_confirm.dart';
import 'package:ecommerce_admin_app/controllers/db_service.dart';
import 'package:ecommerce_admin_app/models/promo_banners_model.dart';
import 'package:flutter/material.dart';

class PromoBannersPage extends StatefulWidget {
  const PromoBannersPage({super.key});

  @override
  State<PromoBannersPage> createState() => _PromoBannersPageState();
}

class _PromoBannersPageState extends State<PromoBannersPage> {
  bool _isInitialized = false;
  bool _isPromo = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_isInitialized) {
        final arguments = ModalRoute.of(context)?.settings.arguments;
        if (arguments != null && arguments is Map<String, dynamic>) {
          _isPromo = arguments['promo'] ?? true;
        }
        print("promo $_isPromo");
        _isInitialized = true;
        print("is initialized $_isInitialized");
        setState(() {});
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isPromo ? "Promos" : "Banners"),
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
      body: _isInitialized
          ? StreamBuilder(
              stream: DbService().readPromos(_isPromo),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  List<PromoBannersModel> promos =
                      PromoBannersModel.fromJsonList(snapshot.data!.docs)
                          as List<PromoBannersModel>;
                  if (promos.isEmpty) {
                    return Center(
                      child: Text(
                        "No ${_isPromo ? "Promos" : "Banners"} found",
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black45),
                      ),
                    );
                  }
                  return ListView.builder(
                    itemCount: promos.length,
                    itemBuilder: (context, index) {
                      return Card(
                        shadowColor: Colors.deepPurple.shade700,
                        margin:
                            EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                        elevation: 5, // Add shadow for each card
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(15), // Rounded corners
                        ),
                        child: ListTile(
                          onTap: () {
                            // Show the dialog to choose Update or Delete
                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: Text("What do you want to do?"),
                                content: Text("Please choose an action"),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.pop(
                                          context); // Close the current dialog
                                      // Show confirmation dialog for Delete
                                      showDialog(
                                        context: context,
                                        builder: (context) => AdditionalConfirm(
                                          contentText:
                                              "Are you sure you want to delete this?",
                                          onYes: () {
                                            DbService().deletePromos(
                                              id: promos[index].id,
                                              isPromo: _isPromo,
                                            );
                                            Navigator.pop(
                                                context); // Close the confirmation dialog
                                          },
                                          onNo: () {
                                            Navigator.pop(
                                                context); // Close the confirmation dialog
                                          },
                                        ),
                                      );
                                    },
                                    child: Text(
                                        "Delete ${_isPromo ? "Promo" : "Banner"}",
                                        style: TextStyle(color: Colors.red)),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      Navigator.pop(
                                          context); // Close the current dialog
                                      // Navigate to the update screen
                                      Navigator.pushNamed(
                                        context,
                                        "/update_promo",
                                        arguments: {
                                          "promo": _isPromo,
                                          "detail": promos[index]
                                        },
                                      );
                                    },
                                    child: Text(
                                        "Update ${_isPromo ? "Promo" : "Banner"}",
                                        style: TextStyle(color: Colors.blue)),
                                  ),
                                ],
                              ),
                            );
                          },
                          leading: Container(
                            height: 50,
                            width: 50,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              image: DecorationImage(
                                image: NetworkImage(promos[index].image),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          title: Text(
                            promos[index].title,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text(promos[index].category,
                              style: TextStyle(color: Colors.black54)),
                          trailing: IconButton(
                            icon: Icon(Icons.edit,
                                color: Colors.deepPurple.shade700),
                            onPressed: () {
                              // On Edit button, prompt the Update or Delete options
                              showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  title: Text("What do you want to do?"),
                                  content: Text("Please choose an action"),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.pop(
                                            context); // Close the current dialog
                                        // Show confirmation dialog for Delete
                                        showDialog(
                                          context: context,
                                          builder: (context) =>
                                              AdditionalConfirm(
                                            contentText:
                                                "Are you sure you want to delete this?",
                                            onYes: () {
                                              DbService().deletePromos(
                                                id: promos[index].id,
                                                isPromo: _isPromo,
                                              );
                                              Navigator.pop(
                                                  context); // Close the confirmation dialog
                                            },
                                            onNo: () {
                                              Navigator.pop(
                                                  context); // Close the confirmation dialog
                                            },
                                          ),
                                        );
                                      },
                                      child: Text(
                                          "Delete ${_isPromo ? "Promo" : "Banner"}",
                                          style: TextStyle(color: Colors.red)),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        Navigator.pop(
                                            context); // Close the current dialog
                                        // Navigate to the update screen
                                        Navigator.pushNamed(
                                          context,
                                          "/update_promo",
                                          arguments: {
                                            "promo": _isPromo,
                                            "detail": promos[index]
                                          },
                                        );
                                      },
                                      child: Text(
                                          "Update ${_isPromo ? "Promo" : "Banner"}",
                                          style: TextStyle(color: Colors.blue)),
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
                }

                return Center(
                  child: CircularProgressIndicator(),
                );
              },
            )
          : SizedBox(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(
            context,
            "/update_promo",
            arguments: {"promo": _isPromo},
          );
        },
        backgroundColor: Colors.deepPurple.shade700,
        child: Icon(Icons.add, color: Colors.white),
        elevation: 8, // Add shadow for FAB
      ),
    );
  }
}
