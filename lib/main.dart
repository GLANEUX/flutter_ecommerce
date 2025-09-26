import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_application_1/guards/auth_guard.dart';
import 'package:flutter_application_1/viewmodels/cart_viewmodel.dart';
import 'firebase_options.dart';

import 'package:provider/provider.dart';
import 'viewmodels/products_viewmodel.dart';
import 'pages/home.dart';
import 'pages/account.dart';
import 'pages/login.dart';
import 'pages/register.dart';
import 'pages/products.dart';
import 'pages/cart.dart';
import 'pages/checkout.dart';
import 'pages/orders.dart';
import 'viewmodels/orders_viewmodel.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform, // Android & Web OK
  );
  runApp(const AppBootstrap());
}

class AppBootstrap extends StatelessWidget {
  const AppBootstrap({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ProductsViewModel()),
        ChangeNotifierProvider(create: (_) => CartViewModel()),
        ChangeNotifierProvider(create: (_) => OrdersViewModel()),
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
        '/': (_) => const RequireAuth(child: MyHomePage()),
        '/products': (_) => const RequireAuth(child: ProductsPage()),

        // ✅ PAGES PROTÉGÉES
        '/account': (_) => const RequireAuth(child: AccountPage()),
        '/checkout': (_) => const RequireAuth(child: CheckoutPage()),
        '/orders': (_) => const RequireAuth(child: OrdersPage()),
        '/cart': (_) => const RequireAuth(child: CartPage()),

        // ✅ PAGES PUBLIQUES (redirigent si déjà connecté)
        '/login': (_) => const RedirectIfAuthenticated(child: LoginPage()),
        '/register': (_) =>
            const RedirectIfAuthenticated(child: RegisterPage()),
      },
    );
  }
}
