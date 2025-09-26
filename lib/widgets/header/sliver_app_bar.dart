import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/widgets/header/cart_icon_badge.dart';

class AppSliverAppBar extends StatelessWidget {
  const AppSliverAppBar({super.key, required this.title});
  final String title;

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      pinned: true,
      floating: true,
      snap: true, // plus fluide avec floating
      forceElevated: true, // petite ombre quand on scrolle
      title: Text(title),
      leading: Builder(
        builder: (context) => IconButton(
          icon: const Icon(Icons.menu),
          onPressed: () {
            // évite les crash si une page n’a pas de Drawer
            final scaffold = Scaffold.maybeOf(context);
            if (scaffold?.hasDrawer ?? false) {
              scaffold!.openDrawer();
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Pas de menu disponible sur cet écran'),
                ),
              );
            }
          },
        ),
      ),
      actions: [
        const CartIconBadge(),

        // réagit en live aux changements d’auth (login/logout)
        StreamBuilder<User?>(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snap) {
            final user = snap.data;
            return IconButton(
              tooltip: user != null ? 'Mon compte' : 'Se connecter',
              icon: const Icon(Icons.account_circle),
              onPressed: () {
                Navigator.pushNamed(
                  context,
                  user != null ? '/account' : '/login',
                );
              },
            );
          },
        ),
        const SizedBox(width: 8),
      ],
    );
  }
}
