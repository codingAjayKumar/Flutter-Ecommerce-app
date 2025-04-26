import 'package:ecommerce_app/controllers/auth_service.dart';
import 'package:ecommerce_app/providers/cart_provider.dart';
import 'package:ecommerce_app/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Profile",
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.2,
          ),
        ),
        elevation: 0,
        backgroundColor: Colors.blueAccent,
        foregroundColor: Colors.white,
        scrolledUnderElevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Consumer<UserProvider>(
              builder: (context, userProvider, child) => Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text(
                      userProvider.name,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    subtitle: Text(
                      userProvider.email,
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey[600],
                      ),
                    ),
                    onTap: () {
                      Navigator.pushNamed(context, "/update_profile");
                    },
                    trailing: Icon(
                      Icons.edit_outlined,
                      color: Colors.blueAccent,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 20),
            _buildListTile(
              context,
              title: "Orders",
              icon: Icons.local_shipping_outlined,
              onTap: () {
                Navigator.pushNamed(context, "/orders");
              },
            ),
            _buildListTile(
              context,
              title: "Discount & Offers",
              icon: Icons.discount_outlined,
              onTap: () {
                Navigator.pushNamed(context, "/discount");
              },
            ),
            _buildListTile(
              context,
              title: "Help & Support",
              icon: Icons.support_agent,
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Mail us at ecommerce@shop.com")));
              },
            ),
            SizedBox(height: 20),
            Divider(
              thickness: 1,
              color: Colors.grey[300],
            ),
            _buildListTile(
              context,
              title: "Logout",
              icon: Icons.logout_outlined,
              onTap: () async {
                Provider.of<UserProvider>(context, listen: false)
                    .cancelProvider();
                Provider.of<CartProvider>(context, listen: false)
                    .cancelProvider();
                await AuthService().logout();
                Navigator.pushNamedAndRemoveUntil(
                    context, "/login", (route) => false);
              },
              iconColor: Colors.redAccent,
            ),
          ],
        ),
      ),
    );
  }

  ListTile _buildListTile(
    BuildContext context, {
    required String title,
    required IconData icon,
    required VoidCallback onTap,
    Color? iconColor,
  }) {
    return ListTile(
      contentPadding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 0),
      leading: Icon(
        icon,
        color: iconColor ?? Colors.blueAccent,
      ),
      title: Text(
        title,
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w500,
        ),
      ),
      onTap: onTap,
    );
  }
}
