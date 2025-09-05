// // ================================
// // lib/pages/cart_page.dart
// // ================================
// import 'package:flutter/materia// ================================
// // lib/pages/cart_page.dart
// // ================================
// import 'package:flutter/material.dart';
// import '../models/product.dart';
// import '../widgets/drawer.dart';

// /// A simple in-memory cart service for demo/MVP purposes.
// /// Replace with a proper state management solution (Provider/Riverpod/BLoC) later.
// class CartService extends ChangeNotifier {
//   static final CartService _instance = CartService._internal();
//   factory CartService() => _instance;
//   CartService._internal();

//   final Map<String, _CartLine> _lines = {}; // key: product.id

//   List<_CartLine> get lines =>
//       _lines.values.toList()
//         ..sort((a, b) => a.product.title.compareTo(b.product.title));

//   int get totalItems => _lines.values.fold(0, (sum, l) => sum + l.quantity);

//   double get subtotal => _lines.values.fold(0.0, (sum, l) => sum + l.total);

//   void add(Product p, {int qty = 1}) {
//     final existing = _lines[p.id];
//     // if (existing == null) {
//     //   _lines[p.id] = _CartLine(product: p, quantity: qty);
//     // } else {
//     //   existing.quantity += qty;
//     // }
//     existing?.quantity += qty;

//     notifyListeners();
//   }

//   void remove(String productId) {
//     _lines.remove(productId);
//     notifyListeners();
//   }

//   void increase(String productId) {
//     final l = _lines[productId];
//     if (l != null) {
//       l.quantity += 1;
//       notifyListeners();
//     }
//   }

//   void decrease(String productId) {
//     final l = _lines[productId];
//     if (l != null) {
//       if (l.quantity > 1) {
//         l.quantity -= 1;
//       } else {
//         _lines.remove(productId);
//       }
//       notifyListeners();
//     }
//   }

//   void clear() {
//     _lines.clear();
//     notifyListeners();
//   }
// }

// class _CartLine {
//   final Product product;
//   int quantity;
//   _CartLine({required this.product});
//   num get total => product.price * quantity;
// }

// class CartPage extends StatefulWidget {
//   const CartPage({super.key});

//   @override
//   State<CartPage> createState() => _CartPageState();
// }

// class _CartPageState extends State<CartPage> {
//   final cart = CartService();

//   @override
//   void initState() {
//     super.initState();
//     cart.addListener(_onCartChanged);
//   }

//   @override
//   void dispose() {
//     cart.removeListener(_onCartChanged);
//     super.dispose();
//   }

//   void _onCartChanged() => setState(() {});

//   @override
//   Widget build(BuildContext context) {
//     final lines = cart.lines;
//     final hasItems = lines.isNotEmpty;

//     return Scaffold(
//       appBar: AppBar(title: const Text('Panier')),
//       drawer: const AppDrawer(),
//       body: hasItems
//           ? ListView.separated(
//               padding: const EdgeInsets.all(12),
//               itemCount: lines.length + 1,
//               separatorBuilder: (_, __) => const SizedBox(height: 12),
//               itemBuilder: (context, index) {
//                 if (index == lines.length) return _SummaryCard(cart: cart);
//                 final line = lines[index];
//                 return Dismissible(
//                   key: ValueKey(line.product.id),
//                   background: Container(
//                     color: Colors.red,
//                     alignment: Alignment.centerRight,
//                     padding: const EdgeInsets.symmetric(horizontal: 20),
//                     child: const Icon(Icons.delete, color: Colors.white),
//                   ),
//                   direction: DismissDirection.endToStart,
//                   onDismissed: (_) => cart.remove(line.product.id as String),
//                   child: _CartLineTile(line: line, cart: cart),
//                 );
//               },
//             )
//           : _EmptyCart(onBrowse: () => Navigator.pop(context)),
//     );
//   }
// }

// class _EmptyCart extends StatelessWidget {
//   final VoidCallback onBrowse;
//   const _EmptyCart({required this.onBrowse});
//   @override
//   Widget build(BuildContext context) {
//     return Center(
//       child: Padding(
//         padding: const EdgeInsets.all(24.0),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             const Icon(Icons.remove_shopping_cart, size: 64),
//             const SizedBox(height: 16),
//             const Text('Votre panier est vide.'),
//             const SizedBox(height: 16),
//             ElevatedButton.icon(
//               onPressed: onBrowse,
//               icon: const Icon(Icons.storefront),
//               label: const Text('Continuer mes achats'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// class _CartLineTile extends StatelessWidget {
//   final _CartLine line;
//   final CartService cart;
//   const _CartLineTile({required this.line, required this.cart});

//   @override
//   Widget build(BuildContext context) {
//     final p = line.product;
//     return Card(
//       child: Padding(
//         padding: const EdgeInsets.all(12),
//         child: Row(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // Thumbnail
//             // ClipRRect(
//             //   borderRadius: BorderRadius.circular(8),
//             //   child: (p.thumbnail?.isNotEmpty ?? false)
//             //       ? Image.network(
//             //           p.thumbnail!,
//             //           width: 72,
//             //           height: 72,
//             //           fit: BoxFit.cover,
//             //         )
//             //       : Container(
//             //           width: 72,
//             //           height: 72,
//             //           color: Colors.grey.shade200,
//             //           child: const Icon(Icons.image_not_supported),
//             //         ),
//             // ),
//             const SizedBox(width: 12),
//             // Info + controls
//             Expanded(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(p.title, style: Theme.of(context).textTheme.titleMedium),
//                   const SizedBox(height: 6),
//                   Text(
//                     '${p.price.toStringAsFixed(2)} €',
//                     style: Theme.of(context).textTheme.bodyMedium,
//                   ),
//                   const SizedBox(height: 8),
//                   Row(
//                     children: [
//                       IconButton(
//                         onPressed: () => cart.decrease(p.id as String),
//                         icon: const Icon(Icons.remove_circle_outline),
//                       ),
//                       Text(
//                         '${line.quantity}',
//                         style: Theme.of(context).textTheme.titleMedium,
//                       ),
//                       IconButton(
//                         onPressed: () => cart.increase(p.id as String),
//                         icon: const Icon(Icons.add_circle_outline),
//                       ),
//                       const Spacer(),
//                       Text(
//                         '${line.total.toStringAsFixed(2)} €',
//                         style: Theme.of(context).textTheme.titleMedium,
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// class _SummaryCard extends StatelessWidget {
//   final CartService cart;
//   const _SummaryCard({required this.cart});
//   @override
//   Widget build(BuildContext context) {
//     return Card(
//       color: Theme.of(context).colorScheme.surfaceContainerHighest,
//       child: Padding(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.stretch,
//           children: [
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 const Text('Sous‑total'),
//                 Text('${cart.subtotal.toStringAsFixed(2)} €'),
//               ],
//             ),
//             const SizedBox(height: 8),
//             const Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [Text('Livraison'), Text('Calculée au paiement')],
//             ),
//             const Divider(height: 24),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Text('Total', style: Theme.of(context).textTheme.titleLarge),
//                 Text(
//                   '${cart.subtotal.toStringAsFixed(2)} €',
//                   style: Theme.of(context).textTheme.titleLarge,
//                 ),
//               ],
//             ),
//             const SizedBox(height: 12),
//             ElevatedButton.icon(
//               onPressed: cart.totalItems == 0
//                   ? null
//                   : () async {
//                       // TODO: hook to your checkout flow
//                       ScaffoldMessenger.of(context).showSnackBar(
//                         const SnackBar(
//                           content: Text('Redirection vers le paiement…'),
//                         ),
//                       );
//                     },
//               icon: const Icon(Icons.lock),
//               label: const Text('Passer au paiement'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
// l.dart';
// import '../models/product.dart';
// import '../widgets/drawer.dart';

// /// A simple in-memory cart service for demo/MVP purposes.
// /// Replace with a proper state management solution (Provider/Riverpod/BLoC) later.
// class CartService extends ChangeNotifier {
//   static final CartService _instance = CartService._internal();
//   factory CartService() => _instance;
//   CartService._internal();

//   final Map<String, _CartLine> _lines = {}; // key: product.id

//   List<_CartLine> get lines =>
//       _lines.values.toList()
//         ..sort((a, b) => a.product.title.compareTo(b.product.title));

//   int get totalItems => _lines.values.fold(0, (sum, l) => sum + l.quantity);

//   double get subtotal => _lines.values.fold(0.0, (sum, l) => sum + l.total);

//   void add(Product p, {int qty = 1}) {
//     final existing = _lines[p.id];
//     // if (existing == null) {
//     //   _lines[p.id] = _CartLine(product: p, quantity: qty);
//     // } else {
//     //   existing.quantity += qty;
//     // }
//     existing?.quantity += qty;

//     notifyListeners();
//   }

//   void remove(String productId) {
//     _lines.remove(productId);
//     notifyListeners();
//   }

//   void increase(String productId) {
//     final l = _lines[productId];
//     if (l != null) {
//       l.quantity += 1;
//       notifyListeners();
//     }
//   }

//   void decrease(String productId) {
//     final l = _lines[productId];
//     if (l != null) {
//       if (l.quantity > 1) {
//         l.quantity -= 1;
//       } else {
//         _lines.remove(productId);
//       }
//       notifyListeners();
//     }
//   }

//   void clear() {
//     _lines.clear();
//     notifyListeners();
//   }
// }

// class _CartLine {
//   final Product product;
//   int quantity;
//   _CartLine({required this.product});
//   num get total => product.price * quantity;
// }

// class CartPage extends StatefulWidget {
//   const CartPage({super.key});

//   @override
//   State<CartPage> createState() => _CartPageState();
// }

// class _CartPageState extends State<CartPage> {
//   final cart = CartService();

//   @override
//   void initState() {
//     super.initState();
//     cart.addListener(_onCartChanged);
//   }

//   @override
//   void dispose() {
//     cart.removeListener(_onCartChanged);
//     super.dispose();
//   }

//   void _onCartChanged() => setState(() {});

//   @override
//   Widget build(BuildContext context) {
//     final lines = cart.lines;
//     final hasItems = lines.isNotEmpty;

//     return Scaffold(
//       appBar: AppBar(title: const Text('Panier')),
//       drawer: const AppDrawer(),
//       body: hasItems
//           ? ListView.separated(
//               padding: const EdgeInsets.all(12),
//               itemCount: lines.length + 1,
//               separatorBuilder: (_, __) => const SizedBox(height: 12),
//               itemBuilder: (context, index) {
//                 if (index == lines.length) return _SummaryCard(cart: cart);
//                 final line = lines[index];
//                 return Dismissible(
//                   key: ValueKey(line.product.id),
//                   background: Container(
//                     color: Colors.red,
//                     alignment: Alignment.centerRight,
//                     padding: const EdgeInsets.symmetric(horizontal: 20),
//                     child: const Icon(Icons.delete, color: Colors.white),
//                   ),
//                   direction: DismissDirection.endToStart,
//                   onDismissed: (_) => cart.remove(line.product.id as String),
//                   child: _CartLineTile(line: line, cart: cart),
//                 );
//               },
//             )
//           : _EmptyCart(onBrowse: () => Navigator.pop(context)),
//     );
//   }
// }

// class _EmptyCart extends StatelessWidget {
//   final VoidCallback onBrowse;
//   const _EmptyCart({required this.onBrowse});
//   @override
//   Widget build(BuildContext context) {
//     return Center(
//       child: Padding(
//         padding: const EdgeInsets.all(24.0),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             const Icon(Icons.remove_shopping_cart, size: 64),
//             const SizedBox(height: 16),
//             const Text('Votre panier est vide.'),
//             const SizedBox(height: 16),
//             ElevatedButton.icon(
//               onPressed: onBrowse,
//               icon: const Icon(Icons.storefront),
//               label: const Text('Continuer mes achats'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// class _CartLineTile extends StatelessWidget {
//   final _CartLine line;
//   final CartService cart;
//   const _CartLineTile({required this.line, required this.cart});

//   @override
//   Widget build(BuildContext context) {
//     final p = line.product;
//     return Card(
//       child: Padding(
//         padding: const EdgeInsets.all(12),
//         child: Row(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // Thumbnail
//             // ClipRRect(
//             //   borderRadius: BorderRadius.circular(8),
//             //   child: (p.thumbnail?.isNotEmpty ?? false)
//             //       ? Image.network(
//             //           p.thumbnail!,
//             //           width: 72,
//             //           height: 72,
//             //           fit: BoxFit.cover,
//             //         )
//             //       : Container(
//             //           width: 72,
//             //           height: 72,
//             //           color: Colors.grey.shade200,
//             //           child: const Icon(Icons.image_not_supported),
//             //         ),
//             // ),
//             const SizedBox(width: 12),
//             // Info + controls
//             Expanded(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(p.title, style: Theme.of(context).textTheme.titleMedium),
//                   const SizedBox(height: 6),
//                   Text(
//                     '${p.price.toStringAsFixed(2)} €',
//                     style: Theme.of(context).textTheme.bodyMedium,
//                   ),
//                   const SizedBox(height: 8),
//                   Row(
//                     children: [
//                       IconButton(
//                         onPressed: () => cart.decrease(p.id as String),
//                         icon: const Icon(Icons.remove_circle_outline),
//                       ),
//                       Text(
//                         '${line.quantity}',
//                         style: Theme.of(context).textTheme.titleMedium,
//                       ),
//                       IconButton(
//                         onPressed: () => cart.increase(p.id as String),
//                         icon: const Icon(Icons.add_circle_outline),
//                       ),
//                       const Spacer(),
//                       Text(
//                         '${line.total.toStringAsFixed(2)} €',
//                         style: Theme.of(context).textTheme.titleMedium,
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// class _SummaryCard extends StatelessWidget {
//   final CartService cart;
//   const _SummaryCard({required this.cart});
//   @override
//   Widget build(BuildContext context) {
//     return Card(
//       color: Theme.of(context).colorScheme.surfaceContainerHighest,
//       child: Padding(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.stretch,
//           children: [
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 const Text('Sous‑total'),
//                 Text('${cart.subtotal.toStringAsFixed(2)} €'),
//               ],
//             ),
//             const SizedBox(height: 8),
//             const Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [Text('Livraison'), Text('Calculée au paiement')],
//             ),
//             const Divider(height: 24),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Text('Total', style: Theme.of(context).textTheme.titleLarge),
//                 Text(
//                   '${cart.subtotal.toStringAsFixed(2)} €',
//                   style: Theme.of(context).textTheme.titleLarge,
//                 ),
//               ],
//             ),
//             const SizedBox(height: 12),
//             ElevatedButton.icon(
//               onPressed: cart.totalItems == 0
//                   ? null
//                   : () async {
//                       // TODO: hook to your checkout flow
//                       ScaffoldMessenger.of(context).showSnackBar(
//                         const SnackBar(
//                           content: Text('Redirection vers le paiement…'),
//                         ),
//                       );
//                     },
//               icon: const Icon(Icons.lock),
//               label: const Text('Passer au paiement'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
