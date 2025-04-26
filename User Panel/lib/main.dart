import 'package:ecommerce_app/controllers/auth_service.dart';
import 'package:ecommerce_app/firebase_options.dart';
import 'package:ecommerce_app/providers/cart_provider.dart';
import 'package:ecommerce_app/providers/user_provider.dart';
import 'package:ecommerce_app/views/cart_page.dart';
import 'package:ecommerce_app/views/checkout_page.dart';
import 'package:ecommerce_app/views/discount_page.dart';
import 'package:ecommerce_app/views/home.dart';
import 'package:ecommerce_app/views/home_nav.dart';
import 'package:ecommerce_app/views/login.dart';
import 'package:ecommerce_app/views/orders_page.dart';
import 'package:ecommerce_app/views/signup.dart';
import 'package:ecommerce_app/views/specific_products.dart';
import 'package:ecommerce_app/views/update_profile.dart';
import 'package:ecommerce_app/views/view_product.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Load environment variables
  await dotenv.load(fileName: ".env");

  // Check for the STRIPE_PUBLISH_KEY in the .env file
  final stripePublishKey = dotenv.env["STRIPE_PUBLISH_KEY"];
  if (stripePublishKey == null) {
    throw Exception("STRIPE_PUBLISH_KEY not found in .env");
  }

  // Configure Stripe with the publishable key
  Stripe.publishableKey = stripePublishKey;
  Stripe.merchantIdentifier = 'merchant.flutter.stripe.test';
  Stripe.urlScheme = 'flutterstripe';
  await Stripe.instance.applySettings();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => UserProvider()),
        ChangeNotifierProvider(create: (context) => CartProvider()),
      ],
      child: MaterialApp(
        title: 'eCommerce App',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
          useMaterial3: true,
        ),
        routes: {
          "/": (context) => const CheckUser(),
          "/login": (context) => const LoginPage(),
          "/home": (context) => const HomeNav(),
          "/signup": (context) => const SingupPage(),
          "/update_profile": (context) => const UpdateProfile(),
          "/discount": (context) => const DiscountPage(),
          "/specific": (context) => const SpecificProducts(),
          "/view_product": (context) => const ViewProduct(),
          "/cart": (context) => const CartPage(),
          "/checkout": (context) => const CheckoutPage(),
          "/orders": (context) => const OrdersPage(),
          "/view_order": (context) => const ViewOrder(),
        },
      ),
    );
  }
}

class CheckUser extends StatefulWidget {
  const CheckUser({super.key});

  @override
  _CheckUserState createState() => _CheckUserState();
}

class _CheckUserState extends State<CheckUser> {
  @override
  void initState() {
    super.initState();
    _checkUserLoginStatus();
  }

  // Method to check user login status and navigate accordingly
  Future<void> _checkUserLoginStatus() async {
    try {
      final isLoggedIn = await AuthService().isLoggedIn();

      if (isLoggedIn == null) {
        // Log an error and navigate to login screen
        debugPrint("Error: isLoggedIn returned null");
        Navigator.pushReplacementNamed(context, "/login");
      } else if (isLoggedIn) {
        // User is logged in, navigate to home screen
        Navigator.pushReplacementNamed(context, "/home");
      } else {
        // User is not logged in, navigate to login screen
        Navigator.pushReplacementNamed(context, "/login");
      }
    } catch (e) {
      // Handle potential exceptions
      debugPrint("Error checking login status: $e");
      Navigator.pushReplacementNamed(context, "/login");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
