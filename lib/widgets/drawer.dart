import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  void _go(BuildContext context, String route) {
    Navigator.pop(context);
    final current = ModalRoute.of(context)?.settings.name;
    if (current == route) return;
    Navigator.pushReplacementNamed(context, route);
  }

  Future<void> _signOut(BuildContext context) async {
    // Déconnecte l'utilisateur de Firebase
    await FirebaseAuth.instance.signOut();
    // Ferme le drawer
    Navigator.pop(context);
    // Affiche un message de confirmation
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Déconnecté avec succès')));
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Drawer(
      child: SafeArea(
        child: ListView(
          padding: EdgeInsets.zero,

          children: [
            DrawerHeader(
              decoration: const BoxDecoration(color: Colors.blue),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Mon App',
                    style: TextStyle(color: Colors.white, fontSize: 24),
                  ),
                  const SizedBox(height: 10),
                  // 🔥 AJOUT : Affichage conditionnel selon l'état de connexion
                  if (user != null) ...[
                    // Si l'utilisateur est connecté
                    const Icon(
                      Icons.account_circle,
                      color: Colors.white,
                      size: 40,
                    ),
                    const SizedBox(height: 5),
                    Text(
                      user.email ?? 'Utilisateur connecté',
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                      ),
                    ),
                  ] else
                    // Si l'utilisateur n'est pas connecté
                    const Text(
                      'Non connecté',
                      style: TextStyle(color: Colors.white70, fontSize: 16),
                    ),
                ],
              ),
            ),
            ListTile(
              leading: Icon(Icons.home),
              title: const Text('Accueil'),
              onTap: () => _go(context, '/'),
            ),
            ListTile(
              leading: Icon(Icons.shopping_bag),
              title: const Text('Voir tout'),
              onTap: () => _go(context, '/all'),
            ),

            ListTile(
              leading: Icon(Icons.shopping_cart),
              title: Text('Panier'),
              onTap: () => _go(context, '/cart'),
            ),
            const Divider(),
            if (user == null) ...[
              // Si pas connecté, affiche les options de connexion
              ListTile(
                leading: const Icon(Icons.login, color: Colors.green),
                title: const Text('Se connecter'),
                onTap: () => _go(context, '/login'),
              ),
              ListTile(
                leading: const Icon(Icons.person_add, color: Colors.blue),
                title: const Text('S\'inscrire'),
                onTap: () => _go(context, '/register'),
              ),
            ] else ...[
              // Si connecté, affiche l'option de déconnexion
              ListTile(
                leading: const Icon(Icons.logout, color: Colors.red),
                title: const Text('Se déconnecter'),
                onTap: () => _signOut(context),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
