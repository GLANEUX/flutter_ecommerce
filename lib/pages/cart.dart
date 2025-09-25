import 'package:flutter/material.dart';
import 'package:flutter_application_1/widgets/drawer/drawer.dart';
import 'package:provider/provider.dart';
import '../viewmodels/cart_viewmodel.dart';

class CartPage extends StatelessWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context) {
    final cart = context.watch<CartViewModel>();
    final items = cart.items.values.toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Panier'),
        backgroundColor: Colors.blue[600],
        foregroundColor: Colors.white,
      ),
      // 🔥 AJOUT : Le drawer est accessible même depuis la page de connexion
      drawer: const AppDrawer(),
      body: items.isEmpty
          ? const Center(child: Text('Votre panier est vide'))
          : Column(
              children: [
                Expanded(
                  child: ListView.separated(
                    itemCount: items.length,
                    separatorBuilder: (_, __) => const Divider(height: 1),
                    itemBuilder: (context, i) {
                      final item = items[i];
                      final p = item.product;
                      return ListTile(
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
                                icon: const Icon(Icons.remove_circle_outline),
                                onPressed: () => cart.decrease(p.id),
                              ),
                              Text('${item.quantity}'),
                              IconButton(
                                icon: const Icon(Icons.add_circle_outline),
                                onPressed: () => cart.increase(p.id),
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete_outline),
                                onPressed: () => cart.remove(p.id),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),

                // Résumé
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surface,
                    boxShadow: const [
                      BoxShadow(color: Colors.black12, blurRadius: 6),
                    ],
                  ),
                  child: Column(
                    children: [
                      _row(
                        'Sous-total',
                        '${cart.subtotal.toStringAsFixed(2)} €',
                      ),
                      const SizedBox(height: 6),
                      _row(
                        'Livraison',
                        '${cart.shipping.toStringAsFixed(2)} €',
                      ),
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
                          onPressed: () {
                            // TODO: Checkout (mock)
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Checkout non implémenté'),
                              ),
                            );
                          },
                          child: const Text('Passer au paiement'),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
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
}
