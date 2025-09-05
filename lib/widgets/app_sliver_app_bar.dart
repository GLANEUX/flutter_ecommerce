import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

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
        Padding(
          padding: const EdgeInsetsDirectional.only(end: 12),
          child: CircleAvatar(
            child: IconButton(
              icon: const Icon(Icons.account_circle),
              onPressed: () {
                if (user != null) {
                  Navigator.pushReplacementNamed(context, '/account');
                } else {
                  Navigator.pushReplacementNamed(context, '/login');
                }
              },
            ),
          ),
        ),
      ],
    );
  }
}
