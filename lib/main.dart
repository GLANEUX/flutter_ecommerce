import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
// import 'pages/cart_page.dart';
import 'pages/home_page.dart';
import 'pages/allProducts_page.dart';
import 'pages/account_page.dart';
import 'pages/login_page.dart';
import 'pages/register_page.dart';

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
        '/': (_) => const MyHomePage(),
        '/all': (_) => const AllProductPage(),
        '/login': (_) => const LoginPage(),
        '/register': (_) => const RegisterPage(),
        '/account': (_) => const AccountPage(),
        // '/cart': (_) => const CartPage(),
      },
    );
  }
}
