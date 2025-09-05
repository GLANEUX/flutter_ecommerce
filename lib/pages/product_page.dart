// ================================
// lib/pages/product_detail_page.dart
// ================================
import 'package:flutter/material.dart';
import '../models/product.dart';
import '../widgets/drawer.dart';
import 'cart_page.dart';

class ProductDetailPage extends StatelessWidget {
  final Product product;
  const ProductDetailPage({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(product.title)),
      drawer: const AppDrawer(),
      body: ListView(
        children: [
          // _ImagesGallery(images: product.images ?? const []),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.title,
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Text(
                      '${product.price.toStringAsFixed(2)} €',
                      style: Theme.of(context).textTheme.headlineSmall
                          ?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(width: 8),
                    Chip(label: Text(product.category)),
                  ],
                ),
                const SizedBox(height: 12),
                Text(product.description),
                const SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(
                      child: FilledButton.icon(
                        onPressed: () {
                          // CartService().add(product);
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Ajouté au panier')),
                          );
                        },
                        icon: const Icon(Icons.add_shopping_cart),
                        label: const Text('Ajouter au panier'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    IconButton.outlined(
                      onPressed: () => {
                        //   Navigator.of(context).push(
                        //   MaterialPageRoute(builder: (_) => const CartPage()),
                        // )
                      },
                      icon: const Icon(Icons.shopping_cart_checkout),
                      tooltip: 'Voir le panier',
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ImagesGallery extends StatefulWidget {
  final List<String> images;
  const _ImagesGallery({required this.images});
  @override
  State<_ImagesGallery> createState() => _ImagesGalleryState();
}

class _ImagesGalleryState extends State<_ImagesGallery> {
  int index = 0;
  @override
  Widget build(BuildContext context) {
    final imgs = widget.images.isNotEmpty ? widget.images : [''];
    return Column(
      children: [
        AspectRatio(
          aspectRatio: 1.2,
          child: PageView.builder(
            itemCount: imgs.length,
            onPageChanged: (i) => setState(() => index = i),
            itemBuilder: (context, i) {
              final url = imgs[i];
              if (url.isEmpty) {
                return Container(
                  color: Colors.grey.shade200,
                  child: const Icon(Icons.image, size: 64),
                );
              }
              return Image.network(url, fit: BoxFit.cover);
            },
          ),
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(imgs.length, (i) {
            final selected = i == index;
            return Container(
              width: selected ? 10 : 8,
              height: selected ? 10 : 8,
              margin: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: selected
                    ? Theme.of(context).colorScheme.primary
                    : Colors.grey,
              ),
            );
          }),
        ),
      ],
    );
  }
}
