import 'dart:convert';

class OrderItem {
  final int productId;
  final String title;
  final String image;
  final double price;
  final int quantity;

  OrderItem({
    required this.productId,
    required this.title,
    required this.image,
    required this.price,
    required this.quantity,
  });

  double get lineTotal => price * quantity;

  Map<String, dynamic> toMap() => {
    'productId': productId,
    'title': title,
    'image': image,
    'price': price,
    'quantity': quantity,
  };

  factory OrderItem.fromMap(Map<String, dynamic> map) => OrderItem(
    productId: map['productId'],
    title: map['title'],
    image: map['image'],
    price: (map['price'] as num).toDouble(),
    quantity: map['quantity'],
  );
}

class Order {
  final String id; // ex: timestamp-random
  final List<OrderItem> items;
  final double subtotal;
  final double shipping;
  final double total;
  final DateTime createdAt;

  Order({
    required this.id,
    required this.items,
    required this.subtotal,
    required this.shipping,
    required this.total,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() => {
    'id': id,
    'items': items.map((e) => e.toMap()).toList(),
    'subtotal': subtotal,
    'shipping': shipping,
    'total': total,
    'createdAt': createdAt.toIso8601String(),
  };

  factory Order.fromMap(Map<String, dynamic> map) => Order(
    id: map['id'],
    items: (map['items'] as List).map((e) => OrderItem.fromMap(e)).toList(),
    subtotal: (map['subtotal'] as num).toDouble(),
    shipping: (map['shipping'] as num).toDouble(),
    total: (map['total'] as num).toDouble(),
    createdAt: DateTime.parse(map['createdAt']),
  );

  String toJson() => jsonEncode(toMap());
  factory Order.fromJson(String s) => Order.fromMap(jsonDecode(s));
}
