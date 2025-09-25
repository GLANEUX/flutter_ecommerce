import 'package:flutter/material.dart';
import 'package:flutter_application_1/models/product_model.dart';

class ProductPage extends StatelessWidget {
  final Product product;

  const ProductPage({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(product.title)),
      body: Center(child: Text(product.description)),
    );
  }
}
