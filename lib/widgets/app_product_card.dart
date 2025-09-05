import 'package:flutter/material.dart';

class AppProductCard extends StatelessWidget {
  const AppProductCard({
    super.key,
    required this.title,
    required this.imageUrl,
    required this.price,
    this.rating,
    this.onTap,
  });

  final String title;
  final String imageUrl;
  final num price;
  final num? rating;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Ink(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.black12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // AspectRatio(
            //   aspectRatio: 1,
            //   child: ClipRRect(
            //     borderRadius: const BorderRadius.vertical(
            //       top: Radius.circular(16),
            //     ),
            //     child: Image.network(imageUrl, fit: BoxFit.cover),
            //   ),
            // ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Text(
                        '€${price.toStringAsFixed(2)}',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Spacer(),
                      if (rating != null)
                        Row(
                          children: [
                            const Icon(Icons.star, size: 16),
                            const SizedBox(width: 2),
                            Text(rating!.toStringAsFixed(1)),
                          ],
                        ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  FilledButton.tonal(
                    onPressed: onTap,
                    style: FilledButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                    ),
                    child: const Text('Add to cart'),
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
