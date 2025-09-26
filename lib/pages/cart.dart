import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../viewmodels/cart_viewmodel.dart';
import '../widgets/header/drawer.dart';
import '../widgets/header/sliver_app_bar.dart';

class CartPage extends StatelessWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context) {
    final cart = context.watch<CartViewModel>();
    final items = cart.items.values.toList();

    return Scaffold(
      drawer: const AppDrawer(),
      body: CustomScrollView(
        slivers: [
          const AppSliverAppBar(title: 'Panier'),

          // Contenu vide -> occuper l'espace avec un message centré
          if (items.isEmpty) ...[
            const SliverToBoxAdapter(child: SizedBox(height: 24)),
            const SliverFillRemaining(
              hasScrollBody: false,
              child: Center(child: Text('Votre panier est vide')),
            ),
          ] else ...[
            const SliverToBoxAdapter(child: SizedBox(height: 8)),

            // Liste des articles avec séparateur intégré
            SliverList(
              delegate: SliverChildBuilderDelegate((context, i) {
                final item = items[i];
                final p = item.product;
                final tile = ListTile(
                  leading: SizedBox(
                    width: 56,
                    height: 56,
                    child: Image.network(
                      p.image,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) =>
                          const Icon(Icons.image_not_supported),
                    ),
                  ),
                  title: Text(
                    p.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  subtitle: Text(
                    '${p.price.toStringAsFixed(2)} € x ${item.quantity}',
                  ),
                  trailing: SizedBox(
                    width: 120,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        IconButton(
                          tooltip: 'Diminuer',
                          icon: const Icon(Icons.remove_circle_outline),
                          onPressed: () => cart.decrease(p.id),
                        ),
                        Text('${item.quantity}'),
                        IconButton(
                          tooltip: 'Augmenter',
                          icon: const Icon(Icons.add_circle_outline),
                          onPressed: () => cart.increase(p.id),
                        ),
                        IconButton(
                          tooltip: 'Supprimer',
                          icon: const Icon(Icons.delete_outline),
                          onPressed: () => cart.remove(p.id),
                        ),
                      ],
                    ),
                  ),
                );

                if (i == items.length - 1)
                  return tile; // pas de divider après le dernier
                return Column(children: [tile, const Divider(height: 1)]);
              }, childCount: items.length),
            ),

            // Résumé total + CTA paiement
            SliverToBoxAdapter(
              child: Container(
                padding: const EdgeInsets.all(16),
                margin: const EdgeInsets.only(top: 8, bottom: 16),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface,
                  boxShadow: const [
                    BoxShadow(color: Colors.black12, blurRadius: 6),
                  ],
                ),
                child: Column(
                  children: [
                    _row('Sous-total', '${cart.subtotal.toStringAsFixed(2)} €'),
                    const SizedBox(height: 6),
                    _row('Livraison', '${cart.shipping.toStringAsFixed(2)} €'),
                    const Divider(height: 16),
                    _row(
                      'Total',
                      '${cart.total.toStringAsFixed(2)} €',
                      isBold: true,
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      width: double.infinity,
                      child: FilledButton(
                        onPressed: () =>
                            Navigator.pushNamed(context, '/checkout'),
                        child: const Text('Passer au paiement'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

Widget _row(String label, String value, {bool isBold = false}) {
  final style = isBold
      ? const TextStyle(fontWeight: FontWeight.w700, fontSize: 16)
      : const TextStyle();
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Text(label, style: style),
      Text(value, style: style),
    ],
  );
}
