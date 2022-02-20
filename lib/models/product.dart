import 'dart:convert';

class Product {
  const Product({
    required this.productId,
    required this.productName,
    required this.merchantId,
    required this.calories,
    required this.price,
    this.servingSize,
    this.ingredients,
  });

  final String productId;
  final String productName;
  final String merchantId;
  final num calories;
  final num price;
  final String? servingSize;
  final String? ingredients;

  Product copyWith({
    String? productId,
    String? productName,
    String? merchantId,
    num? calories,
    num? price,
    String? servingSize,
    String? ingredients,
  }) {
    return Product(
      productId: productId ?? this.productId,
      productName: productName ?? this.productName,
      merchantId: merchantId ?? this.merchantId,
      calories: calories ?? this.calories,
      price: price ?? this.price,
      servingSize: servingSize ?? this.servingSize,
      ingredients: ingredients ?? this.ingredients,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'productId': productId,
      'productName': productName,
      'merchantId': merchantId,
      'calories': calories,
      'price': price,
      'servingSize': servingSize,
      'ingredients': ingredients,
    };
  }

  factory Product.fromMap(Map<String, dynamic> map) {
    return Product(
      productId: map['productId'],
      productName: map['productName'],
      merchantId: map['merchantId'],
      calories: map['calories'],
      price: map['price'],
      servingSize: map['servingSize'],
      ingredients: map['ingredients'],
    );
  }

  String toJson() => json.encode(toMap());

  factory Product.fromJson(String source) =>
      Product.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Product(productId: $productId, productName: $productName, merchantId: $merchantId, calories: $calories, price: $price, servingSize: $servingSize, ingredients: $ingredients)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Product &&
        other.productId == productId &&
        other.productName == productName &&
        other.merchantId == merchantId &&
        other.calories == calories &&
        other.price == price &&
        other.servingSize == servingSize &&
        other.ingredients == ingredients;
  }

  @override
  int get hashCode {
    return productId.hashCode ^
        productName.hashCode ^
        merchantId.hashCode ^
        calories.hashCode ^
        price.hashCode ^
        servingSize.hashCode ^
        ingredients.hashCode;
  }
}
