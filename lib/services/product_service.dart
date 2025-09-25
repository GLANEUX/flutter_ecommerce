// product_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/product_model.dart';

class ProductService {
  static const String baseUrl = 'https://fakestoreapi.com';

  // ---- Helpers -------------------------------------------------------------
  static Uri _productsUri({String? category}) {
    if (category == null || category.trim().toLowerCase() == 'all') {
      return Uri.parse('$baseUrl/products');
    }
    // encodage safe de la catégorie
    final encoded = Uri.encodeComponent(category.trim());
    return Uri.parse('$baseUrl/products/category/$encoded');
  }

  static Future<http.Response> _get(Uri uri) {
    return http
        .get(uri, headers: const {'Content-Type': 'application/json'})
        .timeout(const Duration(seconds: 10));
  }

  // ---- Produits ------------------------------------------------------------
  static Future<List<Product>> fetchProducts({String? category}) async {
    try {
      final response = await _get(_productsUri(category: category));
      if (response.statusCode == 200) {
        final List data = json.decode(response.body) as List;
        return data.map((e) => Product.fromJson(e)).toList();
      }
      throw Exception('Erreur serveur : ${response.statusCode}');
    } catch (e) {
      throw Exception('Impossible de charger les produits : $e');
    }
  }

  // ---- Catégories ----------------------------------------------------------
  static Future<List<String>> fetchCategories() async {
    try {
      final response = await _get(Uri.parse('$baseUrl/products/categories'));
      if (response.statusCode == 200) {
        final List data = json.decode(response.body) as List;
        // Optionnel : ordonner et capitaliser
        return data.map((e) => e.toString()).toList();
      }
      throw Exception('Erreur serveur : ${response.statusCode}');
    } catch (e) {
      throw Exception('Impossible de charger les catégories : $e');
    }
  }

  // ---- (Optionnel) un produit par id --------------------------------------
  static Future<Product> fetchProduct(int id) async {
    try {
      final response = await _get(Uri.parse('$baseUrl/products/$id'));
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        return Product.fromJson(data);
      }
      throw Exception('Erreur serveur : ${response.statusCode}');
    } catch (e) {
      throw Exception('Impossible de charger le produit : $e');
    }
  }
}
