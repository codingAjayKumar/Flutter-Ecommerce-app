import 'package:ecommerce_app/contants/discount.dart';
import 'package:ecommerce_app/models/cart_model.dart';
import 'package:ecommerce_app/models/products_model.dart';
import 'package:ecommerce_app/providers/cart_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ViewProduct extends StatefulWidget {
  const ViewProduct({super.key});

  @override
  State<ViewProduct> createState() => _ViewProductState();
}

class _ViewProductState extends State<ViewProduct> {
  @override
  Widget build(BuildContext context) {
    final arguments =
        ModalRoute.of(context)!.settings.arguments as ProductsModel;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Product Details"),
        scrolledUnderElevation: 0,
        backgroundColor: Colors.deepPurple.shade700,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Product Image with improved shadow
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.white70.withOpacity(0.1),
                      spreadRadius: 2,
                      blurRadius: 8,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Image.network(
                    arguments.image,
                    height: 350,
                    width: double.infinity,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              // Product Information
              Text(
                arguments.name,
                style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.5),
                maxLines: 10,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 10),
              ProductPrice(product: arguments),
              const SizedBox(height: 10),
              StockStatus(maxQuantity: arguments.maxQuantity),
              const SizedBox(height: 16),
              Text(
                arguments.description,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  color: Colors.grey.shade700,
                  height: 1.6,
                  letterSpacing: 0.5,
                ),
                textAlign: TextAlign.justify,
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: arguments.maxQuantity != 0
          ? Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Row(
                children: [
                  Expanded(
                    child: ProductActionButton(
                      title: "Add to Cart",
                      backgroundColor: Colors.blue.shade600,
                      textColor: Colors.white,
                      onPressed: () {
                        Provider.of<CartProvider>(context, listen: false)
                            .addToCart(
                          CartModel(productId: arguments.id, quantity: 1),
                        );
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("Added to cart")),
                        );
                      },
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: ProductActionButton(
                      title: "Buy Now",
                      backgroundColor: Colors.white,
                      textColor: Colors.blue.shade600,
                      onPressed: () {
                        Provider.of<CartProvider>(context, listen: false)
                            .addToCart(
                          CartModel(productId: arguments.id, quantity: 1),
                        );
                        Navigator.pushNamed(context, "/checkout");
                      },
                    ),
                  ),
                ],
              ),
            )
          : const SizedBox(),
    );
  }
}

class ProductPrice extends StatelessWidget {
  final ProductsModel product;

  const ProductPrice({required this.product, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          "₹ ${product.old_price}",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w500,
            color: Colors.grey.shade600,
            decoration: TextDecoration.lineThrough,
          ),
        ),
        const SizedBox(width: 12),
        Text(
          "₹ ${product.new_price}",
          style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w700,
            color: Colors.green,
          ),
        ),
        const SizedBox(width: 10),
        const Icon(Icons.arrow_downward, color: Colors.red, size: 20),
        Text(
          "${discountPercent(product.old_price, product.new_price)}% OFF",
          style: const TextStyle(
              fontSize: 18, fontWeight: FontWeight.bold, color: Colors.red),
        ),
      ],
    );
  }
}

class StockStatus extends StatelessWidget {
  final int maxQuantity;

  const StockStatus({required this.maxQuantity, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          maxQuantity == 0 ? Icons.remove_shopping_cart : Icons.check_circle,
          color: maxQuantity == 0 ? Colors.red : Colors.green,
          size: 20,
        ),
        const SizedBox(width: 8),
        Text(
          maxQuantity == 0 ? "Out of Stock" : "Only $maxQuantity left in stock",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: maxQuantity == 0 ? Colors.red : Colors.green,
          ),
        ),
      ],
    );
  }
}

class ProductActionButton extends StatelessWidget {
  final String title;
  final Color backgroundColor;
  final Color textColor;
  final VoidCallback onPressed;

  const ProductActionButton({
    required this.title,
    required this.backgroundColor,
    required this.textColor,
    required this.onPressed,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 55,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor,
          foregroundColor: textColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 4,
          padding: const EdgeInsets.symmetric(horizontal: 20),
        ),
        child: Text(
          title,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            letterSpacing: 0.5,
          ),
        ),
      ),
    );
  }
}
