import 'package:ecommerce_admin_app/containers/dashboard_text.dart';
import 'package:ecommerce_admin_app/containers/home_button.dart';
import 'package:ecommerce_admin_app/controllers/auth_service.dart';
import 'package:ecommerce_admin_app/providers/admin_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AdminHome extends StatefulWidget {
  const AdminHome({super.key});

  @override
  State<AdminHome> createState() => _AdminHomeState();
}

class _AdminHomeState extends State<AdminHome> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Admin iShop"),
        centerTitle: true,
        titleTextStyle: TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
        elevation: 0,
        backgroundColor: Colors.deepPurple.shade600,
        actions: [
          IconButton(
            onPressed: () async {
              Provider.of<AdminProvider>(context, listen: false)
                  .cancelProvider();
              await AuthService().logout();
              Navigator.pushNamedAndRemoveUntil(
                  context, "/login", (route) => false);
            },
            icon: Icon(Icons.logout),
            color: Colors.white,
          )
        ],
      ),
      /* body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
                height: 260,
                padding: EdgeInsets.all(12),
                margin: EdgeInsets.only(left: 10, right: 10, bottom: 10),
                decoration: BoxDecoration(
                    color: Colors.deepPurple.shade100,
                    borderRadius: BorderRadius.circular(10)),
                child: Consumer<AdminProvider>(
                  builder: (context, value, child) => Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      DashboardText(
                        keyword: "Total Categories",
                        value: "${value.categories.length}",
                      ),
                      DashboardText(
                        keyword: "Total Products",
                        value: "${value.products.length}",
                      ),
                      DashboardText(
                        keyword: "Total Orders",
                        value: "${value.totalOrders}",
                      ),
                      DashboardText(
                        keyword: "Order Not Shipped yet",
                        value: "${value.orderPendingProcess}",
                      ),
                      DashboardText(
                        keyword: "Order Shipped",
                        value: "${value.ordersOnTheWay}",
                      ),
                      DashboardText(
                        keyword: "Order Delivered",
                        value: "${value.ordersDelivered}",
                      ),
                      DashboardText(
                        keyword: "Order Cancelled",
                        value: "${value.ordersCancelled}",
                      ),
                    ],
                  ),
                )),

            // Buttons for admins
            Row(
              children: [
                HomeButton(
                    onTap: () {
                      Navigator.pushNamed(context, "/orders");
                    },
                    name: "Orders"),
                HomeButton(
                    onTap: () {
                      Navigator.pushNamed(context, "/products");
                    },
                    name: "Products"),
              ],
            ),
            Row(
              children: [
                HomeButton(
                    onTap: () {
                      Navigator.pushNamed(context, "/promos",
                          arguments: {"promo": true});
                    },
                    name: "Promos"),
                HomeButton(
                    onTap: () {
                      Navigator.pushNamed(context, "/promos",
                          arguments: {"promo": false});
                    },
                    name: "Banners"),
              ],
            ),
            Row(
              children: [
                HomeButton(
                    onTap: () {
                      Navigator.pushNamed(context, "/category");
                    },
                    name: "Categories"),
                HomeButton(
                    onTap: () {
                      Navigator.pushNamed(context, "/coupons");
                    },
                    name: "Coupons"),
              ],
            ),
          ],
        ),
      ),*/

      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // Dashboard Summary Container
              _buildDashboardSummary(context),

              SizedBox(height: 20), // Space between sections

              // Buttons Section (Admin navigation)
              _buildAdminButtons(context),

              SizedBox(height: 40), // Space before designer name

              // Designer Credit
              _buildDesignerCredit(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDashboardSummary(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      margin: EdgeInsets.only(bottom: 100),
      decoration: BoxDecoration(
        color: Colors.deepPurple.shade50,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 10,
            offset: Offset(0, 4), // Shadow direction
          ),
        ],
      ),
      child: Consumer<AdminProvider>(
        builder: (context, value, child) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildDashboardText("Total Categories", value.categories.length),
              _buildDashboardText("Total Products", value.products.length),
              _buildDashboardText("Total Orders", value.totalOrders),
              _buildDashboardText(
                  "Order Not Shipped Yet", value.orderPendingProcess),
              _buildDashboardText("Order Shipped", value.ordersOnTheWay),
              _buildDashboardText("Order Delivered", value.ordersDelivered),
              _buildDashboardText("Order Cancelled", value.ordersCancelled),
            ],
          );
        },
      ),
    );
  }

  Widget _buildDashboardText(String keyword, dynamic value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            keyword,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          Text(
            "$value",
            style: TextStyle(
              fontSize: 16,
              color: Colors.deepPurple.shade700,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAdminButtons(BuildContext context) {
    return Column(
      children: [
        _buildButtonRow(context, [
          _buildCustomButton(context, "Orders", "/orders", Icons.shopping_cart),
          _buildCustomButton(context, "Products", "/products", Icons.store),
        ]),
        SizedBox(height: 10),
        _buildButtonRow(context, [
          _buildCustomButton(context, "Promos", "/promos", Icons.local_offer,
              arguments: {"promo": true}),
          _buildCustomButton(context, "Banners", "/promos", Icons.photo,
              arguments: {"promo": false}),
        ]),
        SizedBox(height: 10),
        _buildButtonRow(context, [
          _buildCustomButton(
              context, "Categories", "/category", Icons.category),
          _buildCustomButton(
              context, "Coupons", "/coupons", Icons.card_giftcard),
        ]),
      ],
    );
  }

  Widget _buildButtonRow(BuildContext context, List<Widget> buttons) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: buttons,
    );
  }

  Widget _buildCustomButton(
      BuildContext context, String name, String route, IconData icon,
      {Object? arguments}) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: TextButton(
          onPressed: () {
            Navigator.pushNamed(context, route, arguments: arguments);
          },
          style: TextButton.styleFrom(
            padding: EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            backgroundColor: Colors.deepPurple.shade600,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: Colors.white, size: 24),
              SizedBox(height: 6),
              Text(
                name,
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Widget to display the designer credit at the bottom
  Widget _buildDesignerCredit() {
    return Center(
      child: Text(
        "Design by Ajay Kumar",
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: Colors.black54,
        ),
      ),
    );
  }
}
