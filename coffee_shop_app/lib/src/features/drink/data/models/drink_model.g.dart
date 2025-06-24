// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'drink_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$DrinkModelImpl _$$DrinkModelImplFromJson(Map<String, dynamic> json) =>
    _$DrinkModelImpl(
      title: json['title'] as String,
      description: json['description'] as String,
      ingredients: _ingredientsFromJson(json['ingredients']),
      image: json['image'] as String,
      id: json['id'],
      price: (json['price'] as num?)?.toDouble(),
      type: json['type'] as String?,
      isFavorite: json['isFavorite'] as bool? ?? false,
      quantity: (json['quantity'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$$DrinkModelImplToJson(_$DrinkModelImpl instance) =>
    <String, dynamic>{
      'title': instance.title,
      'description': instance.description,
      'ingredients': instance.ingredients,
      'image': instance.image,
      'id': instance.id,
      'price': instance.price,
      'type': instance.type,
      'isFavorite': instance.isFavorite,
      'quantity': instance.quantity,
    };
