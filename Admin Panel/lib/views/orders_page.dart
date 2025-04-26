import 'package:ecommerce_admin_app/controllers/db_service.dart';
import 'package:ecommerce_admin_app/models/orders_model.dart';
import 'package:ecommerce_admin_app/providers/admin_provider.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:flutter_animate/flutter_animate.dart'; // Add the flutter_animate package for smooth transitions and animations

class OrdersPage extends StatefulWidget {
  const OrdersPage({super.key});

  @override
  State<OrdersPage> createState() => _OrdersPageState();
}

class _OrdersPageState extends State<OrdersPage> {
  int totalQuantityCalculator(List<OrderProductModel> products) {
    return products.fold(0, (qty, e) => qty + e.quantity);
  }

  Widget statusIcon(String status) {
    Color bgColor;
    Color textColor;
    String statusText;

    switch (status) {
      case "PAID":
        statusText = "PAID";
        bgColor = Colors.lightGreen;
        textColor = Colors.white;
        break;
      case "ON_THE_WAY":
        statusText = "ON THE WAY";
        bgColor = Colors.yellow;
        textColor = Colors.black;
        break;
      case "DELIVERED":
        statusText = "DELIVERED";
        bgColor = Colors.green.shade700;
        textColor = Colors.white;
        break;
      default:
        statusText = "CANCELED";
        bgColor = Colors.red;
        textColor = Colors.white;
        break;
    }

    return statusContainer(
      text: statusText,
      bgColor: bgColor,
      textColor: textColor,
    );
  }

  Widget statusContainer({
    required String text,
    required Color bgColor,
    required Color textColor,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            spreadRadius: 3,
            blurRadius: 5,
            offset: Offset(0, 2), // Shadow position
          ),
        ],
      ),
      child: Text(
        text,
        style: TextStyle(color: textColor, fontWeight: FontWeight.bold),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple.shade700,
        foregroundColor: Colors.white,
        title: Text(
          "orders",
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        elevation: 10,
      ),
      body: Consumer<AdminProvider>(
        builder: (context, value, child) {
          List<OrdersModel> orders =
              OrdersModel.fromJsonList(value.orders) as List<OrdersModel>;

          if (orders.isEmpty) {
            return Center(
                child: Text("No orders found", style: TextStyle(fontSize: 18)));
          }

          return ListView.builder(
            itemCount: orders.length,
            itemBuilder: (context, index) {
              final order = orders[index];
              return _buildOrderCard(order);
            },
          );
        },
      ),
    );
  }

  Widget _buildOrderCard(OrdersModel order) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, "/view_order", arguments: order);
      },
      child: AnimatedContainer(
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        margin: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
        padding: EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              spreadRadius: 3,
              blurRadius: 5,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Order by ${order.name}",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            Text(
                "Ordered on ${DateTime.fromMillisecondsSinceEpoch(order.created_at).toLocal()}"),
            SizedBox(height: 10),
            statusIcon(order.status),
          ],
        ),
      ).animate().flip(duration: Duration(seconds: 1), curve: Curves.easeInOut),
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
        backgroundColor: Colors.deepPurple.shade700,
        foregroundColor: Colors.white,
        title: Text(
          "Order Details",
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        elevation: 10,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionTitle("Delivery Details"),
            _buildOrderDetails(args),
            _buildProductsList(args),
            _buildSummarySection(args),
            SizedBox(height: 8),
            _buildModifyButton(args),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Text(title,
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
    );
  }

  Widget _buildOrderDetails(OrdersModel order) {
    return Container(
      padding: const EdgeInsets.all(16), // Adjusted padding for better spacing
      margin: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white, // A cleaner background color
        borderRadius:
            BorderRadius.circular(20), // Rounded corners for a modern look
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1), // Subtle shadow for depth
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Order ID: ${order.id}",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          SizedBox(height: 8),
          Text(
            "Order On: ${DateFormat('MMM dd, yyyy, h:mm a').format(DateTime.fromMillisecondsSinceEpoch(order.created_at).toLocal())}",
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade600,
            ),
          ),
          SizedBox(height: 8),
          Text(
            "Order by: ${order.name}",
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Colors.black87,
            ),
          ),
          SizedBox(height: 8),
          Text(
            "Phone: ${order.phone}",
            style: TextStyle(
              fontSize: 14,
              color: Colors.blueAccent, // Phone numbers could be highlighted
            ),
          ),
          SizedBox(height: 8),
          Text(
            "Delivery Address: ${order.address}",
            style: TextStyle(
              fontSize: 14,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProductsList(OrdersModel order) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: order.products.map((product) {
        return GestureDetector(
          onTap: () {
            // Handle product click (if any)
          },
          child: AnimatedContainer(
            duration: Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            padding: const EdgeInsets.all(10),
            margin: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  spreadRadius: 3,
                  blurRadius: 5,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              children: [
                Image.network(product.image, height: 50, width: 50),
                SizedBox(width: 10),
                Expanded(child: Text(product.name)),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text("₹${product.single_price} x ${product.quantity}",
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    Text("₹${product.total_price}",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 20)),
                  ],
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildSummarySection(OrdersModel order) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Discount: ₹${order.discount}",
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 18,
              color: Colors.green, // Adds a touch of color for emphasis
            ),
          ),
          SizedBox(height: 8), // Adds spacing between items
          Text(
            "Total: ₹${order.total}",
            style: TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 20,
              color: Colors.black, // Total amount emphasized
            ),
          ),
          SizedBox(height: 8), // Adds spacing between items
          Row(
            children: [
              Icon(
                order.status == 'Completed' ? Icons.check_circle : Icons.error,
                color: order.status == 'Completed' ? Colors.green : Colors.red,
              ),
              SizedBox(width: 8),
              Text(
                "Status: ${order.status}",
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 18,
                  color:
                      order.status == 'Completed' ? Colors.green : Colors.red,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildModifyButton(OrdersModel order) {
    return SizedBox(
      height: 60,
      width: MediaQuery.of(context).size.width * 0.9,
      child: ElevatedButton(
        onPressed: () => showDialog(
          context: context,
          builder: (context) => ModifyOrder(order: order),
        ),
        child: Text(
          "Modify Order",
          style: TextStyle(
            fontSize: 16, // Increased font size for readability
            fontWeight: FontWeight.bold, // Bold font for emphasis
          ),
        ),
        style: ElevatedButton.styleFrom(
          foregroundColor: Colors.white,
          backgroundColor: Colors.blue, // Text color
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(
                30), // Rounded corners for a more modern look
          ),
          padding: EdgeInsets.symmetric(
              vertical: 15), // Vertical padding for better touch targets
          elevation: 8, // Subtle shadow effect for depth
          shadowColor: Colors.black
              .withOpacity(0.2), // Slight shadow to make the button stand out
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
  Future<void> updateOrderStatus(String status) async {
    await DbService()
        .updateOrderStatus(docId: widget.order.id, data: {"status": status});
    Navigator.pop(context); // Close the dialog
    Navigator.pop(context); // Close the order view page
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius:
            BorderRadius.circular(16), // Rounded corners for a more modern look
      ),
      title: Text(
        "Modify this Order",
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 18,
        ),
      ),
      content: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Choose an option to update the status:",
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[700],
              ),
            ),
            SizedBox(height: 16), // Space between description and buttons

            // Button 1
            ElevatedButton(
              onPressed: () => updateOrderStatus("PAID"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue, // Button color
                padding: EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                elevation: 2,
              ),
              child: Text(
                "Order Paid by User",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            SizedBox(height: 12), // Space between buttons

            // Button 2
            ElevatedButton(
              onPressed: () => updateOrderStatus("ON_THE_WAY"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange, // Button color
                padding: EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                elevation: 2,
              ),
              child: Text(
                "Order Shipped",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            SizedBox(height: 12),

            // Button 3
            ElevatedButton(
              onPressed: () => updateOrderStatus("DELIVERED"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green, // Button color
                padding: EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                elevation: 2,
              ),
              child: Text(
                "Order Delivered",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            SizedBox(height: 12),

            // Button 4
            ElevatedButton(
              onPressed: () => updateOrderStatus("CANCELLED"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red, // Button color
                padding: EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                elevation: 2,
              ),
              child: Text(
                "Cancel Order",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
