import 'package:flutter/material.dart';
import '../models/product_model.dart';
import 'app_product_card.dart';

class ProductsGridSliver extends StatelessWidget {
  const ProductsGridSliver({
    super.key,
    required this.products,
    this.onProductTap,
    this.crossAxisCount = 2,
  });

  final List<Product> products;
  final void Function(Product product)? onProductTap;
  final int crossAxisCount;

  @override
  Widget build(BuildContext context) {
    if (products.isEmpty) {
      return const SliverToBoxAdapter(
        child: Padding(
          padding: EdgeInsets.all(24),
          child: Center(child: Text('No products found')),
        ),
      );
    }

    return SliverPadding(
      padding: const EdgeInsets.fromLTRB(12, 8, 12, 16),
      sliver: SliverGrid(
        delegate: SliverChildBuilderDelegate((context, i) {
          final p = products[i];
          return AppProductCard(
            title: p.title,
            imageUrl: p.image,
            price: p.price,
            onTap: () => onProductTap?.call(p),
          );
        }, childCount: products.length),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: crossAxisCount,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: .68,
        ),
      ),
    );
  }
}
