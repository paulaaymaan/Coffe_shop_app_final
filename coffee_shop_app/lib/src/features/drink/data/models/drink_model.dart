
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';

part 'drink_model.freezed.dart';
part 'drink_model.g.dart';

@freezed
class DrinkModel with _$DrinkModel {
  const factory DrinkModel({
    required String title,
    required String description,
    @JsonKey(fromJson: _ingredientsFromJson) dynamic ingredients,
    required String image,
    required dynamic id,
    double? price,
    String? type,
    @Default(false) bool isFavorite,
    @Default(0) int quantity,
  }) = _DrinkModel;

  factory DrinkModel.fromJson(Map<String, dynamic> json) => _$DrinkModelFromJson(json);
}

dynamic _ingredientsFromJson(dynamic json) {
  if (json == null) return null;
  if (json is String) {
    try {
       if (json.startsWith('[') && json.endsWith(']')) {
          String content = json.substring(1, json.length - 1);
          return content.split(',').map((e) => e.trim()).where((e) => e.isNotEmpty).toList();
       }
       return [json.trim()];
    } catch (e) {
       print('Warning: Failed to parse ingredients string: $json. Error: $e');
       return json;
    }
  }
  if (json is List) {
    return json.map((e) => e.toString()).toList();
  }
  print('Warning: Unexpected ingredients type: ${json.runtimeType}. Value: $json');
  return json.toString();
}