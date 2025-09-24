// ================================
// lib/pages/product_detail_page.dart
// ================================
import 'package:flutter/material.dart';

class ProductPage extends StatelessWidget {
  final dynamic product; // ou mieux : final Product product;

  const ProductPage({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(product.title)),
      body: Center(child: Text(product.description)),
    );
  }
}
