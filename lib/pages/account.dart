// ================================
// lib/pages/account_page.dart
// ================================
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../widgets/drawer/drawer.dart';

class AccountPage extends StatelessWidget {
  const AccountPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Mon compte')),
      drawer: const AppDrawer(),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _HeaderCard(),
          const SizedBox(height: 16),
          const _AccountActions(),
          const SizedBox(height: 16),
          const _OrdersPreview(),
        ],
      ),
    );
  }
}

class _HeaderCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            const CircleAvatar(radius: 28, child: Icon(Icons.person)),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Bonjour 👋',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  Text(
                    'Utilisateur',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
            ),
            IconButton(
              onPressed: () {
                // TODO: navigate to edit profile
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Édition du profil bientôt disponible'),
                  ),
                );
              },
              icon: const Icon(Icons.edit),
              tooltip: 'Modifier le profil',
            ),
          ],
        ),
      ),
    );
  }
}

class _AccountActions extends StatelessWidget {
  Future<void> _signOut(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    Navigator.pushReplacementNamed(context, '/register');
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Déconnecté avec succès')));
  }

  const _AccountActions();
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: [
          ListTile(
            leading: const Icon(Icons.shopping_bag_outlined),
            title: const Text('Mes commandes'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              // TODO: navigate to orders page
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Historique des commandes bientôt dispo'),
                ),
              );
            },
          ),
          const Divider(height: 0),
          ListTile(
            leading: const Icon(Icons.location_on_outlined),
            title: const Text('Adresses'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {},
          ),
          const Divider(height: 0),
          ListTile(
            leading: const Icon(Icons.payment_outlined),
            title: const Text('Paiements'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {},
          ),
          const Divider(height: 0),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('Se déconnecter'),
            onTap: () => _signOut(context),
          ),
        ],
      ),
    );
  }
}

class _OrdersPreview extends StatelessWidget {
  const _OrdersPreview();
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Dernières commandes',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 12),
            const Text('Aucune commande pour le moment.'),
            const SizedBox(height: 8),
            OutlinedButton.icon(
              onPressed: () {
                // Optionally navigate to orders list
              },
              icon: const Icon(Icons.receipt_long),
              label: const Text('Voir tout'),
            ),
          ],
        ),
      ),
    );
  }
}
