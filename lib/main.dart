import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'pages/home.dart';
import 'pages/product.dart';
import 'pages/account.dart';
import 'pages/login.dart';
import 'pages/register.dart';
import 'pages/single_product.dart';
import 'pages/products.dart';

import 'viewmodels/products_viewmodel.dart'; // <-- IMPORTANT

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const AppBootstrap());
}

class AppBootstrap extends StatelessWidget {
  const AppBootstrap({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => ProductsViewModel()..loadProducts(), // précharge
        ),
      ],
      child: const MyApp(),
    );
  }
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
        '/products': (_) => const ProductsPage(),
        '/login': (_) => const LoginPage(),
        '/register': (_) => const RegisterPage(),
        '/account': (_) => const AccountPage(),
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
