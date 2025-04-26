import 'package:ecommerce_app/containers/category_container.dart';
import 'package:ecommerce_app/containers/discount_container.dart';
import 'package:ecommerce_app/containers/home_page_maker_container.dart';
import 'package:ecommerce_app/containers/promo_container.dart';
import 'package:ecommerce_app/views/checkout_page.dart';
import 'package:ecommerce_app/views/discount_page.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "iShop",
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        foregroundColor: Colors.blue,
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.discount_rounded),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const DiscountPage()),
            );
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.shopping_cart_checkout_rounded),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const CheckoutPage()),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Padding(
              padding: EdgeInsets.symmetric(vertical: 8.0),
              child: PromoContainer(),
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 8.0),
              child: DiscountContainer(),
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 8.0),
              child: CategoryContainer(),
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 8.0),
              child: HomePageMakerContainer(),
            ),
          ],
        ),
      ),
    );
  }
}
