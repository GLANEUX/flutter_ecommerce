import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/product.dart';

class ProductService {
  static const _base = 'https://fakestoreapi.com';

  static Future<List<Product>> fetchProducts({String? category}) async {
    final uri = (category == null || category.toLowerCase() == 'all')
        ? Uri.parse('$_base/products')
        : Uri.parse('$_base/products/category/$category');

    final res = await http.get(uri);
    if (res.statusCode != 200) {
      throw Exception('Failed to load products (${res.statusCode})');
    }
    final List data = json.decode(res.body) as List;
    return data
        .map((e) => Product.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  static Future<List<String>> fetchCategories() async {
    final res = await http.get(Uri.parse('$_base/products/categories'));
    if (res.statusCode != 200) {
      throw Exception('Failed to load categories (${res.statusCode})');
    }
    final List data = json.decode(res.body) as List;
    return ['All', ...data.map((e) => e.toString())];
  }
}
