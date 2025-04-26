import 'package:ecommerce_admin_app/containers/additional_confirm.dart';
import 'package:ecommerce_admin_app/controllers/db_service.dart';
import 'package:ecommerce_admin_app/models/coupon_model.dart';
import 'package:flutter/material.dart';

class CouponsPage extends StatefulWidget {
  const CouponsPage({super.key});

  @override
  State<CouponsPage> createState() => _CouponsPageState();
}

class _CouponsPageState extends State<CouponsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple.shade700,
        foregroundColor: Colors.white,
        title: Text(
          "Coupons",
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        elevation: 10,
      ),
      body: StreamBuilder(
        stream: DbService().readCouponCode(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<CouponModel> coupons =
                CouponModel.fromJsonList(snapshot.data!.docs)
                    as List<CouponModel>;

            if (coupons.isEmpty) {
              return Center(
                child: Text(
                  "No coupons found",
                  style: TextStyle(
                      fontSize: 18, color: Colors.deepPurple.shade700),
                ),
              );
            } else {
              return ListView.builder(
                itemCount: coupons.length,
                itemBuilder: (context, index) {
                  return Card(
                    margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                    elevation: 8,
                    shadowColor: Colors.deepPurple.shade700,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: ListTile(
                      onTap: () {
                        // You can still allow tapping to edit the coupon or prompt for delete/update
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: Text("What would you like to do?"),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                  showDialog(
                                    context: context,
                                    builder: (context) => AdditionalConfirm(
                                      contentText: "Delete cannot be undone.",
                                      onNo: () {
                                        Navigator.pop(context);
                                      },
                                      onYes: () {
                                        DbService().deleteCouponCode(
                                            docId: coupons[index].id);
                                        Navigator.pop(context);
                                      },
                                    ),
                                  );
                                },
                                child: Text("Delete Coupon"),
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                  // Show the ModifyCoupon dialog for updating the coupon
                                  showDialog(
                                    context: context,
                                    builder: (context) => ModifyCoupon(
                                      id: coupons[index].id,
                                      code: coupons[index].code,
                                      desc: coupons[index].desc,
                                      discount: coupons[index].discount,
                                    ),
                                  );
                                },
                                child: Text("Update Coupon"),
                              ),
                            ],
                          ),
                        );
                      },
                      title: Text(
                        coupons[index].code,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      subtitle: Text(
                        coupons[index].desc,
                        style: TextStyle(color: Colors.green.shade700),
                      ),
                      trailing: IconButton(
                        icon: Icon(
                          Icons.edit,
                          color: Colors.deepPurple.shade700,
                        ),
                        onPressed: () {
                          // Show the dialog with options to delete or update
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: Text("Choose an action"),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                    showDialog(
                                      context: context,
                                      builder: (context) => AdditionalConfirm(
                                        contentText:
                                            "Are you sure you want to delete this coupon? This action cannot be undone.",
                                        onNo: () {
                                          Navigator.pop(context);
                                        },
                                        onYes: () {
                                          DbService().deleteCouponCode(
                                              docId: coupons[index].id);
                                          Navigator.pop(context);
                                        },
                                      ),
                                    );
                                  },
                                  child: Text("Delete Coupon"),
                                ),
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                    showDialog(
                                      context: context,
                                      builder: (context) => ModifyCoupon(
                                        id: coupons[index].id,
                                        code: coupons[index].code,
                                        desc: coupons[index].desc,
                                        discount: coupons[index].discount,
                                      ),
                                    );
                                  },
                                  child: Text("Update Coupon"),
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
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) => ModifyCoupon(
              id: "",
              code: "",
              desc: "",
              discount: 0,
            ),
          );
        },
        backgroundColor: Colors.deepPurple.shade700,
        child: Icon(
          Icons.add,
          color: Colors.white,
        ),
        elevation: 10,
      ),
    );
  }
}

class ModifyCoupon extends StatefulWidget {
  final String id, code, desc;
  final int discount;
  const ModifyCoupon(
      {super.key,
      required this.id,
      required this.code,
      required this.desc,
      required this.discount});

  @override
  State<ModifyCoupon> createState() => _ModifyCouponState();
}

class _ModifyCouponState extends State<ModifyCoupon> {
  final formKey = GlobalKey<FormState>();
  TextEditingController descController = TextEditingController();
  TextEditingController codeController = TextEditingController();
  TextEditingController disPercentController = TextEditingController();

  @override
  void initState() {
    descController.text = widget.desc;
    codeController.text = widget.code;
    disPercentController.text = widget.discount.toString();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        widget.id.isNotEmpty ? "Update Coupon" : "Add Coupon",
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
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
                "All inputs will be automatically converted to uppercase.",
                style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: codeController,
                validator: (v) =>
                    v!.isEmpty ? "Coupon code cannot be empty." : null,
                decoration: InputDecoration(
                  hintText: "Enter Coupon Code",
                  labelText: "Coupon Code",
                  fillColor: Colors.grey.shade50,
                  filled: true,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                ),
                textCapitalization: TextCapitalization.characters,
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: descController,
                validator: (v) =>
                    v!.isEmpty ? "Description cannot be empty." : null,
                decoration: InputDecoration(
                  hintText: "Enter Description",
                  labelText: "Description",
                  fillColor: Colors.grey.shade50,
                  filled: true,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                ),
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: disPercentController,
                validator: (v) =>
                    v!.isEmpty ? "Discount percentage cannot be empty." : null,
                decoration: InputDecoration(
                  hintText: "Enter Discount %",
                  labelText: "Discount %",
                  fillColor: Colors.grey.shade50,
                  filled: true,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                ),
                keyboardType: TextInputType.number,
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          style: TextButton.styleFrom(
            foregroundColor: Colors.red,
            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
          ),
          child: Text("Cancel", style: TextStyle(fontSize: 16)),
        ),
        TextButton(
          onPressed: () {
            if (formKey.currentState!.validate()) {
              var data = {
                "code": codeController.text.toUpperCase(),
                "desc": descController.text,
                "discount": int.parse(disPercentController.text)
              };

              if (widget.id.isNotEmpty) {
                DbService().updateCouponCode(docId: widget.id, data: data);
                ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Coupon Code updated.")));
              } else {
                DbService().createCouponCode(data: data);
                ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Coupon Code added.")));
              }
              Navigator.pop(context);
            }
          },
          style: TextButton.styleFrom(
            foregroundColor: Colors.white,
            backgroundColor: Colors.deepPurple,
            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
          ),
          child: Text(
            widget.id.isNotEmpty ? "Update Coupon" : "Add Coupon",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }
}
