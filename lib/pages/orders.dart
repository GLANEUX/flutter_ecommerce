import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/orders_viewmodel.dart';

class OrdersPage extends StatefulWidget {
  const OrdersPage({super.key});

  @override
  State<OrdersPage> createState() => _OrdersPageState();
}

class _OrdersPageState extends State<OrdersPage> {
  @override
  void initState() {
    super.initState();
    // charge la liste
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<OrdersViewModel>().load();
    });
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<OrdersViewModel>();

    return Scaffold(
      appBar: AppBar(title: const Text('Mes commandes')),
      body: vm.isLoading
          ? const Center(child: CircularProgressIndicator())
          : vm.orders.isEmpty
          ? const Center(child: Text('Aucune commande pour le moment'))
          : ListView.builder(
              itemCount: vm.orders.length,
              itemBuilder: (context, i) {
                final o = vm.orders[i];
                return ExpansionTile(
                  title: Text(
                    'Commande #${o.id}',
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                  subtitle: Text(
                    '${o.createdAt.toLocal()} — ${o.total.toStringAsFixed(2)} €',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  children: [
                    for (final it in o.items)
                      ListTile(
                        leading: Image.network(
                          it.image,
                          width: 48,
                          height: 48,
                          fit: BoxFit.cover,
                        ),
                        title: Text(
                          it.title,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        subtitle: Text(
                          '${it.price.toStringAsFixed(2)} € x ${it.quantity}',
                        ),
                        trailing: Text(
                          '${(it.price * it.quantity).toStringAsFixed(2)} €',
                        ),
                      ),
                    const Divider(height: 1),
                    Padding(
                      padding: const EdgeInsets.all(12),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            'Total : ${o.total.toStringAsFixed(2)} €',
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              },
            ),
    );
  }
}
