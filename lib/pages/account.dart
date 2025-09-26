// ================================
// lib/pages/account_page.dart
// ================================
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../widgets/header/drawer.dart';
import '../viewmodels/orders_viewmodel.dart';
import '../models/order_model.dart';

class AccountPage extends StatelessWidget {
  const AccountPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Mon compte')),
      drawer: const AppDrawer(),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: const [
          _HeaderCard(),
          SizedBox(height: 16),
          _AccountActions(),
          SizedBox(height: 16),
          _OrdersPreview(),
        ],
      ),
    );
  }
}

class _HeaderCard extends StatelessWidget {
  const _HeaderCard();

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    final title = (user?.displayName?.trim().isNotEmpty ?? false)
        ? 'Bonjour ${user!.displayName} 👋'
        : 'Bonjour 👋';
    final subtitle = user?.email ?? 'Utilisateur';

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: Theme.of(context).textTheme.titleMedium),
                  Text(subtitle, style: Theme.of(context).textTheme.bodyMedium),
                ],
              ),
            ),
            IconButton(
              onPressed: () => Navigator.pushNamed(context, '/profile/edit'),
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
  const _AccountActions();

  void _go(BuildContext context, String route) {
    final current = ModalRoute.of(context)?.settings.name;
    if (current == route) {
      Navigator.pop(context); // si vient du drawer
      return;
    }
    Navigator.pushNamed(context, route);
  }

  Future<void> _signOut(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    if (!context.mounted) return;
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Déconnecté avec succès')));
    Navigator.pushNamedAndRemoveUntil(context, '/', (_) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: [
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

class _OrdersPreview extends StatefulWidget {
  const _OrdersPreview();

  @override
  State<_OrdersPreview> createState() => _OrdersPreviewState();
}

class _OrdersPreviewState extends State<_OrdersPreview> {
  @override
  void initState() {
    super.initState();
    // Charge l'historique dès l’arrivée sur la page
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) context.read<OrdersViewModel>().load();
    });
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<OrdersViewModel>();
    final orders = vm.orders.take(3).toList(); // aperçu 3 dernières

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  'Dernières commandes',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const Spacer(),
                TextButton.icon(
                  onPressed: () => Navigator.pushNamed(context, '/orders'),
                  icon: const Icon(Icons.receipt_long),
                  label: const Text('Voir tout'),
                ),
              ],
            ),
            const SizedBox(height: 8),
            if (vm.isLoading)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 16),
                child: Center(child: CircularProgressIndicator()),
              )
            else if (orders.isEmpty)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 4),
                child: Text('Aucune commande pour le moment.'),
              )
            else
              ...orders.map((o) => _OrderRow(o)).toList(),
          ],
        ),
      ),
    );
  }
}

class _OrderRow extends StatelessWidget {
  const _OrderRow(this.order);
  final Order order;

  @override
  Widget build(BuildContext context) {
    final date =
        '${order.createdAt.day.toString().padLeft(2, '0')}/${order.createdAt.month.toString().padLeft(2, '0')}/${order.createdAt.year}';
    final total = '${order.total.toStringAsFixed(2)} €';

    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: const Icon(Icons.receipt_long),
      title: Text(
        'Commande #${order.id}',
        style: const TextStyle(fontWeight: FontWeight.w600),
      ),
      subtitle: Text('$date — ${order.items.length} article(s)'),
      trailing: Text(
        total,
        style: const TextStyle(fontWeight: FontWeight.w600),
      ),
      onTap: () => Navigator.pushNamed(context, '/orders'),
    );
  }
}
