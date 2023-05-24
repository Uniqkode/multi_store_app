import 'package:flutter/material.dart';
import 'package:multi_store_app/auth/cust_login.dart';
import 'package:multi_store_app/auth/customer_signup.dart';
import 'package:multi_store_app/auth/supplier_login.dart';
import 'package:multi_store_app/auth/supplier_signup.dart';
import 'package:multi_store_app/main_screen/customer_home_screen.dart';
import 'package:multi_store_app/main_screen/supplier_home.dart';
import 'package:multi_store_app/main_screen/welcome_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:multi_store_app/providers/cart_provider.dart';
import 'package:multi_store_app/providers/stripe_id.dart';
import 'package:multi_store_app/providers/wishlist_provider.dart';
import 'package:provider/provider.dart';
import 'package:flutter_stripe/flutter_stripe.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Stripe.publishableKey = stripePublishableKey;
  Stripe.merchantIdentifier = 'merchant.flutter.stripe.test';
  Stripe.urlScheme = 'flutterstripe';
  await Stripe.instance.applySettings();

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(create: (_) => Cart()),
    ChangeNotifierProvider(create: (_) => Wish()),
  ], child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Multi Store',
        debugShowCheckedModeBanner: false,
        initialRoute: '/welcome_screen',
        routes: {
          '/customer_signup': (context) => const CustomerReg(),
          '/supplier_signup': (context) => const SupplierReg(),
          '/supplier_login': (context) => const SupplierLogin(),
          '/cust_login': (context) => const CustomerLogin(),
          '/welcome_screen': (context) => const Welcomescreen(),
          '/customer_home': (context) => const CustomerHomeScreen(),
          '/supplier_home': (context) => const SupplierHomeScreen(),
        });
  }
}
