import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../models/product_model.dart';
import '../services/product_service.dart';

import '../widgets/header/drawer.dart';
import '../widgets/bannerCarousel.dart';
import '../widgets/header/sliver_app_bar.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late Future<List<Product>> _futureAllProducts;
  late Future<List<String>> _futureCategories;

  @override
  void initState() {
    super.initState();
    _futureAllProducts = ProductService.fetchProducts();
    _futureCategories = ProductService.fetchCategories();
  }

  void _goToProducts({String? category}) {
    // Si tu veux propager le filtre via arguments :
    Navigator.pushNamed(context, '/products', arguments: category);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const AppDrawer(),
      body: FutureBuilder<List<Product>>(
        future: _futureAllProducts,
        builder: (context, snap) {
          if (snap.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snap.hasError) {
            return Center(child: Text('Erreur: ${snap.error}'));
          }
          final all = snap.data ?? const <Product>[];
          final featured = _topRated(all, 6);

          return CustomScrollView(
            slivers: [
              const AppSliverAppBar(title: 'Fake Store'),

              const SliverToBoxAdapter(child: SizedBox(height: 12)),
              const SliverToBoxAdapter(child: BannerCarousel()),
              const SliverToBoxAdapter(child: SizedBox(height: 8)),

              // Ruban Catégories
              SliverToBoxAdapter(
                child: FutureBuilder<List<String>>(
                  future: _futureCategories,
                  builder: (context, snapCats) {
                    if (snapCats.connectionState != ConnectionState.done) {
                      return const SizedBox(
                        height: 52,
                        child: Center(
                          child: SizedBox(
                            width: 22,
                            height: 22,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          ),
                        ),
                      );
                    }
                    if (snapCats.hasError || !(snapCats.hasData)) {
                      return const SizedBox.shrink();
                    }
                    final cats = ['All', ...snapCats.data!];
                    return SizedBox(
                      height: 52,
                      child: ListView.separated(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                        scrollDirection: Axis.horizontal,
                        separatorBuilder: (_, __) => const SizedBox(width: 8),
                        itemCount: cats.length,
                        itemBuilder: (context, i) {
                          final c = cats[i];
                          return ChoiceChip(
                            selected: false,
                            label: Text(_pretty(c)),
                            onSelected: (_) => _goToProducts(category: c),
                          );
                        },
                      ),
                    );
                  },
                ),
              ),

              // ===== En vedette =====
              SliverToBoxAdapter(
                child: _SectionHeader(
                  title: 'En vedette',
                  actionLabel: 'Voir tout',
                  onAction: () => _goToProducts(),
                ),
              ),
              SliverToBoxAdapter(
                child: _ProductsStrip(
                  products: featured,
                  onTap: (p) =>
                      Navigator.pushNamed(context, '/product', arguments: p),
                ),
              ),

              // ===== 3 rayons par catégorie =====
              SliverToBoxAdapter(
                child: FutureBuilder<List<String>>(
                  future: _futureCategories,
                  builder: (context, snapCats) {
                    if (snapCats.connectionState != ConnectionState.done ||
                        snapCats.hasError ||
                        !(snapCats.hasData)) {
                      return const SizedBox(height: 8);
                    }
                    final top3 = snapCats.data!.take(3).toList();

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        for (final c in top3) ...[
                          _SectionHeader(
                            title: _pretty(c),
                            actionLabel: 'Voir tout',
                            onAction: () => _goToProducts(category: c),
                          ),
                          FutureBuilder<List<Product>>(
                            future: ProductService.fetchProducts(category: c),
                            builder: (context, snapList) {
                              if (snapList.connectionState !=
                                  ConnectionState.done) {
                                return const SizedBox(
                                  height: 220,
                                  child: Center(
                                    child: CircularProgressIndicator(),
                                  ),
                                );
                              }
                              if (snapList.hasError || !(snapList.hasData)) {
                                return const SizedBox(height: 8);
                              }
                              final list = snapList.data!.take(10).toList();
                              return _ProductsStrip(
                                products: list,
                                onTap: (p) => Navigator.pushNamed(
                                  context,
                                  '/product',
                                  arguments: p,
                                ),
                              );
                            },
                          ),
                          const SizedBox(height: 8),
                        ],
                      ],
                    );
                  },
                ),
              ),

              const SliverToBoxAdapter(child: SizedBox(height: 16)),
            ],
          );
        },
      ),
    );
  }

  // Helpers
  List<Product> _topRated(List<Product> all, int n) {
    final copy = List<Product>.from(all);
    copy.sort((a, b) {
      final ar = (a.rating?.rate ?? 0).compareTo(b.rating?.rate ?? 0);
      return ar != 0
          ? ar
          : (a.rating?.count ?? 0).compareTo(b.rating?.count ?? 0);
    });
    return copy.reversed.take(n).toList();
  }

  String _pretty(String c) =>
      c.isEmpty ? c : c[0].toUpperCase() + c.substring(1);
}

/// -------- Widgets “boîte” (non-slivers) --------

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.title, this.actionLabel, this.onAction});

  final String title;
  final String? actionLabel;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 8),
      child: Row(
        children: [
          Text(
            title,
            style: Theme.of(
              context,
            ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
          ),
          const Spacer(),
          if (actionLabel != null && onAction != null)
            TextButton(onPressed: onAction, child: Text(actionLabel!)),
        ],
      ),
    );
  }
}

class _ProductsStrip extends StatelessWidget {
  const _ProductsStrip({required this.products, required this.onTap});

  final List<Product> products;
  final void Function(Product p) onTap;

  @override
  Widget build(BuildContext context) {
    if (products.isEmpty) return const SizedBox.shrink();
    return SizedBox(
      height: 220,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        scrollDirection: Axis.horizontal,
        itemCount: products.length,
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        itemBuilder: (context, i) {
          final p = products[i];
          return _SmallProductCard(product: p, onTap: () => onTap(p));
        },
      ),
    );
  }
}

class _SmallProductCard extends StatelessWidget {
  const _SmallProductCard({required this.product, this.onTap});

  final Product product;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Ink(
        width: 150,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: scheme.outlineVariant),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Image
            ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(12),
              ),
              child: CachedNetworkImage(
                imageUrl: product.image,
                height: 110,
                fit: BoxFit.cover,
                placeholder: (_, __) => Container(
                  height: 110,
                  color: Colors.grey[200],
                  child: const Center(
                    child: SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                  ),
                ),
                errorWidget: (_, __, ___) => Container(
                  height: 110,
                  color: Colors.grey[200],
                  child: const Icon(Icons.image_not_supported),
                ),
              ),
            ),

            // Infos
            Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Text(
                        '€${product.price.toStringAsFixed(2)}',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const Spacer(),
                      const Icon(Icons.star, size: 14),
                      const SizedBox(width: 2),
                      Text((product.rating?.rate ?? 0).toStringAsFixed(1)),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
