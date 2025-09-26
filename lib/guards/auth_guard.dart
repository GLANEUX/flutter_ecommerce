import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

/// Protège une page : si l'utilisateur N'EST PAS connecté,
/// redirige vers /login et affiche un écran neutre le temps du redirect.
class RequireAuth extends StatelessWidget {
  const RequireAuth({super.key, required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snap) {
        // Indéterminé -> petit loader
        if (snap.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        // Non connecté -> redirection vers /login
        if (snap.data == null) {
          // évite setState pendant build
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (ModalRoute.of(context)?.settings.name != '/login') {
              Navigator.pushNamedAndRemoveUntil(
                context,
                '/login',
                (_) => false,
              );
            }
          });
          // Écran vide le temps du redirect
          return const Scaffold(body: SizedBox.shrink());
        }

        // Connecté -> page protégée
        return child;
      },
    );
  }
}

/// Inverse : si l'utilisateur EST connecté, redirige vers '/'
/// À utiliser sur Login / Register.
class RedirectIfAuthenticated extends StatelessWidget {
  const RedirectIfAuthenticated({super.key, required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snap) {
        if (snap.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        if (snap.data != null) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (ModalRoute.of(context)?.settings.name != '/') {
              Navigator.pushNamedAndRemoveUntil(context, '/', (_) => false);
            }
          });
          return const Scaffold(body: SizedBox.shrink());
        }
        return child;
      },
    );
  }
}
