import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
// import 'pages/cart_page.dart';
import 'pages/home.dart';
import 'pages/product.dart';
import 'pages/account.dart';
import 'pages/login.dart';
import 'pages/register.dart';
import 'pages/single_product.dart';
import 'pages/products.dart';

void main() async {
  // init les bindings de flutter (for firebase)
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fake Store',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(colorSchemeSeed: Colors.blue, useMaterial3: true),
      initialRoute: '/',
      routes: {
        '/': (_) => const ProductsPage(),
        '/all': (_) => const ProductsPage(),
        '/login': (_) => const LoginPage(),
        '/register': (_) => const RegisterPage(),
        '/account': (_) => const AccountPage(),
        // '/cart': (_) => const CartPage(),
      },
      onGenerateRoute: (settings) {
        if (settings.name == '/product') {
          final args = settings.arguments;
          return MaterialPageRoute(builder: (_) => ProductPage(product: args));
        }
        return null;
      },
    );
  }
}
