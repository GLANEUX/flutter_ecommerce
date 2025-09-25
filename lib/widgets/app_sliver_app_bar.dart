import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/widgets/cart_icon_badge.dart';

class AppSliverAppBar extends StatelessWidget {
  const AppSliverAppBar({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return SliverAppBar(
      pinned: true,
      floating: true,
      title: Text(title),
      leading: Builder(
        builder: (context) => IconButton(
          icon: const Icon(Icons.menu),
          onPressed: () => Scaffold.of(context).openDrawer(),
        ),
      ),
      actions: [
        // Badge Panier
        const CartIconBadge(),

        // Bouton Compte
        IconButton(
          tooltip: user != null ? 'Mon compte' : 'Se connecter',
          icon: const Icon(Icons.account_circle),
          onPressed: () {
            if (user != null) {
              Navigator.pushNamed(context, '/account');
            } else {
              Navigator.pushNamed(context, '/login');
            }
          },
        ),

        const SizedBox(width: 8),
      ],
    );
  }
}
