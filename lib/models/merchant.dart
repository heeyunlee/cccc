import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'package:cccc/models/product.dart';

class Merchant {
  const Merchant({
    required this.merchantId,
    required this.name,
    required this.products,
  });

  final String merchantId;
  final String name;
  final List<Product> products;

  Merchant copyWith({
    String? merchantId,
    String? name,
    List<Product>? products,
  }) {
    return Merchant(
      merchantId: merchantId ?? this.merchantId,
      name: name ?? this.name,
      products: products ?? this.products,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'merchantId': merchantId,
      'name': name,
      'products': products.map((x) => x.toMap()).toList(),
    };
  }

  factory Merchant.fromMap(Map<String, dynamic> map) {
    return Merchant(
      merchantId: map['merchantId'] ?? '',
      name: map['name'] ?? '',
      products: List<Product>.from(
        map['products']?.map((x) => Product.fromMap(x)),
      ),
    );
  }

  String toJson() => json.encode(toMap());

  factory Merchant.fromJson(String source) =>
      Merchant.fromMap(json.decode(source));

  @override
  String toString() =>
      'Merchant(merchantId: $merchantId, name: $name, products: $products)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Merchant &&
        other.merchantId == merchantId &&
        other.name == name &&
        listEquals(other.products, products);
  }

  @override
  int get hashCode => merchantId.hashCode ^ name.hashCode ^ products.hashCode;
}
