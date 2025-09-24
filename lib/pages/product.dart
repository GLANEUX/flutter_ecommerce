// import 'package:flutter/material.dart';
// import '../models/product_model.dart';
// import '../services/product_service.dart';
// import '../widgets/app_sliver_app_bar.dart';
// import '../widgets/drawer.dart';
// import '../widgets/products_grid_sliver.dart';

// class AllProductPage extends StatefulWidget {
//   const AllProductPage({super.key});

//   @override
//   State<AllProductPage> createState() => _AllProductPageState();
// }

// class _AllProductPageState extends State<AllProductPage> {
//   late Future<List<Product>> _futureProducts;
//   late Future<List<String>> _futureCategories;
//   String _selectedCategory = 'All';

//   @override
//   void initState() {
//     super.initState();
//     _futureProducts = ProductService.fetchProducts();
//     _futureCategories = ProductService.fetchCategories();
//   }

//   void _selectCategory(String cat) {
//     setState(() {
//       _selectedCategory = cat;
//       _futureProducts = ProductService.fetchProducts(category: cat);
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       drawer: const AppDrawer(),
//       body: FutureBuilder<List<Product>>(
//         future: _futureProducts,
//         builder: (context, snapProducts) {
//           if (snapProducts.connectionState != ConnectionState.done) {
//             return const Center(child: CircularProgressIndicator());
//           }
//           if (snapProducts.hasError) {
//             return Center(child: Text('Error: ${snapProducts.error}'));
//           }
//           final products = snapProducts.data ?? const <Product>[];

//           return CustomScrollView(
//             slivers: [
//               // AppBar
//               AppSliverAppBar(title: 'Fake Store'),

//               // Catégories (dynamiques)
//               SliverToBoxAdapter(
//                 child: FutureBuilder<List<String>>(
//                   future: _futureCategories,
//                   builder: (context, snapCats) {
//                     if (snapCats.connectionState != ConnectionState.done) {
//                       return const SizedBox(height: 52);
//                     }
//                     if (snapCats.hasError || !(snapCats.hasData)) {
//                       return const SizedBox.shrink();
//                     }
//                     final cats = snapCats.data!;
//                     return SizedBox(
//                       height: 52,
//                       child: ListView.separated(
//                         padding: const EdgeInsets.symmetric(
//                           horizontal: 12,
//                           vertical: 8,
//                         ),
//                         scrollDirection: Axis.horizontal,
//                         separatorBuilder: (_, __) => const SizedBox(width: 8),
//                         itemCount: cats.length,
//                         itemBuilder: (context, i) {
//                           final c = cats[i];
//                           final selected =
//                               c.toLowerCase() ==
//                               _selectedCategory.toLowerCase();
//                           return ChoiceChip(
//                             selected: selected,
//                             label: Text(_prettyCat(c)),
//                             onSelected: (_) => _selectCategory(c),
//                           );
//                         },
//                       ),
//                     );
//                   },
//                 ),
//               ),

//               // Grille produits (externalisée)
//               ProductsGridSliver(
//                 products: products,
//                 onProductTap: (p) {
//                   Navigator.pushNamed(context, '/product', arguments: p.id);
//                 },
//               ),
//             ],
//           );
//         },
//       ),
//     );
//   }

//   String _prettyCat(String c) {
//     if (c.isEmpty) return c;
//     // "men's clothing" -> "Men's clothing"
//     return c[0].toUpperCase() + c.substring(1);
//   }
// }
