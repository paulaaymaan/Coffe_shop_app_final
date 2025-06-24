
import 'package:coffee_shop_app/src/features/drink/data/models/drink_model.dart';

class Drink {
  final String id;
  final String title;
  final String description;
  final dynamic ingredients;
  final String imageUrl;
  final double price;
  final String? type;
  final bool isFavorite;
  final int quantity;

  const Drink({
    required this.id,
    required this.title,
    required this.description,
    required this.ingredients,
    required this.imageUrl,
    required this.price,
    this.type,
    this.isFavorite = false,
    this.quantity = 0,
  });

  factory Drink.fromModel(DrinkModel model) {
    return Drink(
      id: model.id.toString(),
      title: model.title,
      description: model.description,
      ingredients: model.ingredients,
      imageUrl: model.image,
      price: model.price ?? 0.0,
      type: model.type,
      isFavorite: model.isFavorite,
      quantity: model.quantity,
    );
  }

  Drink copyWith({
    String? id,
    String? title,
    String? description,
    dynamic ingredients,
    String? imageUrl,
    double? price,
    String? type,
    bool? isFavorite,
    int? quantity,
  }) {
    return Drink(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      ingredients: ingredients ?? this.ingredients,
      imageUrl: imageUrl ?? this.imageUrl,
      price: price ?? this.price,
      type: type ?? this.type,
      isFavorite: isFavorite ?? this.isFavorite,
      quantity: quantity ?? this.quantity,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Drink && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}