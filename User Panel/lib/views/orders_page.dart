import 'package:ecommerce_app/containers/additional_confirm.dart';
import 'package:ecommerce_app/controllers/db_service.dart';
import 'package:ecommerce_app/models/cart_model.dart';
import 'package:ecommerce_app/models/orders_model.dart';
import 'package:ecommerce_app/providers/cart_provider.dart';
import 'package:ecommerce_app/views/checkout_page.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class OrdersPage extends StatefulWidget {
  const OrdersPage({super.key});

  @override
  State<OrdersPage> createState() => _OrdersPageState();
}

class _OrdersPageState extends State<OrdersPage> {
  totalQuantityCalculator(List<OrderProductModel> products) {
    int qty = 0;
    products.map((e) => qty += e.quantity).toList();
    return qty;
  }

  Widget statusIcon(String status) {
    if (status == "PAID") {
      return statusContainer(
        text: "PAID",
        bgColor: Colors.lightGreen,
        textColor: Colors.white,
        icon: Icons.check_circle,
      );
    }
    if (status == "ON_THE_WAY") {
      return statusContainer(
        text: "ON THE WAY",
        bgColor: Colors.yellow,
        textColor: Colors.black,
        icon: Icons.local_shipping,
      );
    } else if (status == "DELIVERED") {
      return statusContainer(
        text: "DELIVERED",
        bgColor: Colors.green.shade700,
        textColor: Colors.white,
        icon: Icons.delivery_dining,
      );
    } else {
      return statusContainer(
        text: "CANCELED",
        bgColor: Colors.red,
        textColor: Colors.white,
        icon: Icons.cancel,
      );
    }
  }

  Widget statusContainer(
      {required String text,
      required Color bgColor,
      required Color textColor,
      required IconData icon}) {
    return Container(
      padding: EdgeInsets.all(8),
      color: bgColor,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: textColor, size: 16),
          SizedBox(width: 5),
          Text(
            text,
            style: TextStyle(color: textColor),
          ),
        ],
      ),
    );
  }

  Widget orderQuickInfo(OrdersModel order) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            // Displaying Quick Information (Order ID, Date, Quantity, Total)
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Order ID: ${order.id}",
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  Text(
                      "Order Date: ${DateFormat('dd MMM yyyy, hh:mm a').format(DateTime.fromMillisecondsSinceEpoch(order.created_at))}"),
                  Text("Items: ${totalQuantityCalculator(order.products)}"),
                  Text("Total: ₹${order.total}"),
                ],
              ),
            ),
            // Displaying the status icon
            statusIcon(order.status),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Orders",
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w600,
            color: Colors
                .white, // Make sure the text is visible if the background is transparent
          ),
        ),
        centerTitle: true, // Centers the title
        backgroundColor: Colors.blue, // Adjust the background color as needed
        scrolledUnderElevation: 0, // No shadow when scrolling
        elevation: 0, // Remove elevation to make the app bar flat
      ),
      body: StreamBuilder(
        stream: DbService().readOrders(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<OrdersModel> orders =
                OrdersModel.fromJsonList(snapshot.data!.docs)
                    as List<OrdersModel>;
            if (orders.isEmpty) {
              return Center(
                child: Text("No orders found"),
              );
            } else {
              return ListView.builder(
                itemCount: orders.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, "/view_order",
                          arguments: orders[index]);
                    },
                    child: orderQuickInfo(
                        orders[index]), // Quick info for each order
                  );
                },
              );
            }
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}

class ViewOrder extends StatefulWidget {
  const ViewOrder({super.key});

  @override
  State<ViewOrder> createState() => _ViewOrderState();
}

class _ViewOrderState extends State<ViewOrder> {
  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as OrdersModel;
    return Scaffold(
      appBar: AppBar(
        title: Text("Order Summary"),
        backgroundColor: Colors.blueAccent,
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 16, vertical: 12), // Increased padding
                child: Text(
                  "Delivery Details",
                  style: TextStyle(
                    fontSize: 20, // Increased font size
                    fontWeight: FontWeight.w600, // Bolder font weight
                    color: Colors.blueGrey, // Custom text color
                    letterSpacing:
                        1.2, // Added letter spacing for better readability
                  ),
                ),
              ),
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(16),
                color: Colors.grey.shade100,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Order ID with icon
                    Row(
                      children: [
                        Icon(Icons.confirmation_number,
                            color: Colors.blue, size: 20),
                        SizedBox(width: 8),
                        Text(
                          "Order Id : ${args.id}",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 8),

                    // Formatted Order Date with icon
                    Row(
                      children: [
                        Icon(Icons.calendar_today,
                            color: Colors.green, size: 20),
                        SizedBox(width: 8),
                        Text(
                          "Order On : ${DateFormat('dd MMM yyyy, hh:mm a').format(DateTime.fromMillisecondsSinceEpoch(args.created_at))}",
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[700],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 8),

                    // Name with icon
                    Row(
                      children: [
                        Icon(Icons.person, color: Colors.orange, size: 20),
                        SizedBox(width: 8),
                        Text(
                          "Order by : ${args.name}",
                          style: TextStyle(
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 8),

                    // Phone Number with icon
                    Row(
                      children: [
                        Icon(Icons.phone, color: Colors.teal, size: 20),
                        SizedBox(width: 8),
                        Text(
                          "Phone no : ${args.phone}",
                          style: TextStyle(
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 8),

                    // Delivery Address with icon
                    Row(
                      children: [
                        Icon(Icons.location_on, color: Colors.red, size: 20),
                        SizedBox(width: 8),
                        // Use Flexible to allow the text to wrap and take the remaining space
                        Flexible(
                          child: Text("Delivery Address : ${args.address}",
                              style: TextStyle(
                                fontSize: 14,
                                fontStyle: FontStyle.italic,
                              ),
                              overflow: TextOverflow
                                  .ellipsis, // If the text is too long, show ellipsis
                              maxLines: 5 // Limit the number of lines
                              ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: args.products
                    .map((e) => Container(
                          width: double.infinity,
                          padding: EdgeInsets.all(10),
                          margin: EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade200,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Row(
                                  children: [
                                    Container(
                                      height: 50,
                                      width: 50,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(8),
                                        border: Border.all(
                                            color: Colors.grey.shade300),
                                      ),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(8),
                                        child: Image.network(
                                          e.image,
                                          fit: BoxFit.cover,
                                          errorBuilder:
                                              (context, error, stackTrace) =>
                                                  Icon(
                                            Icons.broken_image,
                                            color: Colors.grey,
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            e.name,
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                          SizedBox(height: 4),
                                          Text(
                                            "₹${e.single_price.toString()} x ${e.quantity.toString()} quantity",
                                            style: TextStyle(
                                              color: Colors.grey[600],
                                              fontSize: 14,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                Divider(
                                  thickness: 1,
                                  color: Colors.grey[300],
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "Total Price:",
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    Text(
                                      "₹${e.total_price.toString()}",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20,
                                        color: Colors.green[700],
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 10),
                                ElevatedButton.icon(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => CheckoutPage()),
                                    );
                                  },
                                  icon: Icon(Icons.shopping_cart,
                                      color: Colors.white),
                                  label: Text("Buy Again"),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.blueAccent,
                                    foregroundColor: Colors.white,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                ),
                              ]),
                        ))
                    .toList(),
              ),
              Padding(
                padding: const EdgeInsets.all(4.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: Text(
                        "Discount: ₹${args.discount}",
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 22,
                          color: Colors.greenAccent[700],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: Text(
                        "Total: ₹${args.total}",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 24,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: Text(
                        "Status: ${args.status}",
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 20,
                          color: Colors.blueAccent,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 8,
              ),
              args.status == "PAID" || args.status == "ON_THE_WAY"
                  ? SizedBox(
                      height: 60,
                      width: MediaQuery.of(context).size.width * 0.9,
                      child: ElevatedButton(
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (context) => ModifyOrder(
                              order: args,
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 15),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 5,
                          shadowColor: Colors.blueAccent,
                        ).copyWith(
                          overlayColor:
                              MaterialStateProperty.all(Colors.lightBlueAccent),
                        ),
                        child: const Text(
                          " Modify Order",
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      ),
                    )
                  : SizedBox(),
            ],
          ),
        ),
      ),
    );
  }
}

class ModifyOrder extends StatefulWidget {
  final OrdersModel order;
  const ModifyOrder({super.key, required this.order});

  @override
  State<ModifyOrder> createState() => _ModifyOrderState();
}

class _ModifyOrderState extends State<ModifyOrder> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Row(
        children: [
          const Icon(Icons.edit, color: Colors.blue),
          const SizedBox(width: 8),
          const Text("Modify this Order"),
        ],
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Choose what you want to do"),
          const SizedBox(height: 12),
          TextButton.icon(
            icon: const Icon(Icons.cancel_outlined, color: Colors.red),
            onPressed: () {
              Navigator.pop(context);
              showDialog(
                context: context,
                builder: (context) => AdditionalConfirm(
                  contentText:
                      "After canceling, this cannot be changed. You need to order again.",
                  onYes: () async {
                    await DbService().updateOrderStatus(
                      docId: widget.order.id,
                      data: {"status": "CANCELLED"},
                    );
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Order Updated")),
                    );
                    Navigator.pop(context);
                    Navigator.pop(context);
                  },
                  onNo: () {
                    Navigator.pop(context);
                  },
                ),
              );
            },
            label:
                const Text("Cancel Order", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
