import 'dart:math';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/cart_viewmodel.dart';
import '../viewmodels/orders_viewmodel.dart';
import '../models/order_model.dart';

class CheckoutPage extends StatefulWidget {
  const CheckoutPage({super.key});

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  bool _processing = false;

  Future<void> _pay() async {
    final cart = context.read<CartViewModel>();
    if (cart.items.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Panier vide')));
      return;
    }

    setState(() => _processing = true);

    // 🧪 Mock paiement (2 secondes)
    await Future.delayed(const Duration(seconds: 2));

    // Crée l'objet Order
    final items = cart.items.values
        .map(
          (ci) => OrderItem(
            productId: ci.product.id,
            title: ci.product.title,
            image: ci.product.image,
            price: ci.product.price.toDouble(),
            quantity: ci.quantity,
          ),
        )
        .toList();

    final order = Order(
      id: '${DateTime.now().millisecondsSinceEpoch}-${Random().nextInt(9999)}',
      items: items,
      subtotal: cart.subtotal.toDouble(),
      shipping: cart.shipping.toDouble(),
      total: cart.total.toDouble(),
      createdAt: DateTime.now(),
    );

    // Sauvegarde locale + clear panier
    await context.read<OrdersViewModel>().add(order);
    cart.clear();

    if (!mounted) return;
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Paiement réussi ✅')));
    Navigator.pushReplacementNamed(context, '/orders');
  }

  @override
  Widget build(BuildContext context) {
    final cart = context.watch<CartViewModel>();

    return Scaffold(
      appBar: AppBar(title: const Text('Checkout')),
      body: cart.items.isEmpty
          ? const Center(child: Text('Votre panier est vide'))
          : Column(
              children: [
                Expanded(
                  child: ListView.separated(
                    padding: const EdgeInsets.all(16),
                    itemCount: cart.items.length,
                    separatorBuilder: (_, __) => const Divider(height: 1),
                    itemBuilder: (context, i) {
                      final item = cart.items.values.toList()[i];
                      final p = item.product;
                      return ListTile(
                        leading: Image.network(
                          p.image,
                          width: 56,
                          height: 56,
                          fit: BoxFit.cover,
                        ),
                        title: Text(
                          p.title,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        subtitle: Text(
                          '${p.price.toStringAsFixed(2)} € x ${item.quantity}',
                        ),
                        trailing: Text(
                          (p.price * item.quantity).toStringAsFixed(2) + ' €',
                        ),
                      );
                    },
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(16),
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
                        bold: true,
                      ),
                      const SizedBox(height: 12),
                      SizedBox(
                        width: double.infinity,
                        height: 48,
                        child: FilledButton(
                          onPressed: _processing ? null : _pay,
                          child: _processing
                              ? const SizedBox(
                                  height: 22,
                                  width: 22,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                  ),
                                )
                              : const Text('Payer maintenant (mock)'),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }

  Widget _row(String label, String value, {bool bold = false}) {
    final style = bold
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
