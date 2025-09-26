import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_application_1/widgets/header/drawer_footer.dart';
import 'package:flutter_application_1/widgets/header/drawer_header.dart';
import 'package:provider/provider.dart';
import '../../viewmodels/cart_viewmodel.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  void _go(BuildContext context, String route) {
    Navigator.pop(context);
    final current = ModalRoute.of(context)?.settings.name;
    if (current == route) return;
    Navigator.pushReplacementNamed(context, route);
  }

  Future<void> _signOut(BuildContext context) async {
    if (!context.mounted) return;

    try {
      await FirebaseAuth.instance.signOut();

      if (!context.mounted) return;

      Navigator.pop(context);
      Navigator.pushReplacementNamed(context, '/');
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Déconnecté avec succès')));
    } catch (e) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Erreur lors de la déconnexion')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    final cartCount = context.select<CartViewModel, int>((c) => c.totalItems);

    return Drawer(
      child: SafeArea(
        child: Column(
          children: [
            DrawerHeaders(
              title: 'Fake Store',
              caption: user?.email ?? 'Bienvenue',
            ),
            // ===== ITEMS =====
            Expanded(
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  ListTile(
                    leading: const Icon(Icons.home_outlined),
                    title: const Text('Accueil'),
                    onTap: () => _go(context, '/'),
                  ),
                  ListTile(
                    leading: const Icon(Icons.storefront_outlined),
                    title: const Text('Tous les produits'),
                    onTap: () => _go(context, '/products'),
                  ),
                  ListTile(
                    leading: Stack(
                      clipBehavior: Clip.none,
                      children: [
                        const Icon(Icons.shopping_cart_outlined),
                        if (cartCount > 0)
                          Positioned(
                            right: -6,
                            top: -4,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 6,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.red,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Text(
                                '$cartCount',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 11,
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                    title: const Text('Panier'),
                    onTap: () => _go(context, '/cart'),
                  ),
                  const Divider(),

                  if (user == null) ...[
                    ListTile(
                      leading: const Icon(
                        Icons.login_outlined,
                        color: Colors.green,
                      ),
                      title: const Text('Se connecter'),
                      onTap: () => _go(context, '/login'),
                    ),
                    ListTile(
                      leading: const Icon(
                        Icons.person_add_alt_1_outlined,
                        color: Colors.blue,
                      ),
                      title: const Text('S’inscrire'),
                      onTap: () => _go(context, '/register'),
                    ),
                  ] else ...[
                    ListTile(
                      leading: const Icon(Icons.account_circle_outlined),
                      title: const Text('Mon compte'),
                      onTap: () => _go(context, '/account'),
                    ),
                    ListTile(
                      leading: const Icon(
                        Icons.logout_outlined,
                        color: Colors.red,
                      ),
                      title: const Text('Se déconnecter'),
                      onTap: () => _signOut(context),
                    ),
                  ],
                ],
              ),
            ),
            // =================
            DrawerFooter(),
          ],
        ),
      ),
    );
  }
}
