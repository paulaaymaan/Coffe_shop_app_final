
import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:coffee_shop_app/src/features/drink/domain/entities/drink.dart';
import 'package:coffee_shop_app/src/features/drink/data/models/drink_model.dart';
import 'package:coffee_shop_app/src/core/constants.dart';

class FavoriteDrinksNotifier extends StateNotifier<List<Drink>> {
  FavoriteDrinksNotifier() : super([]) {
    _loadFavorites();
  }

  Future<void> _loadFavorites() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String? jsonString = prefs.getString(kFavoriteDrinksKey);
      if (jsonString != null) {
        final List<dynamic> jsonList = jsonDecode(jsonString);
        state = jsonList
            .map((json) => Drink.fromModel(DrinkModel.fromJson(json)))
            .toList();
      }
    } catch (e) {
      print('Error loading favorites: $e');
    }
  }

  Future<void> _saveFavorites() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final List<Map<String, dynamic>> jsonList = state
          .map((drink) => DrinkModel(
                id: drink.id,
                title: drink.title,
                description: drink.description,
                ingredients: drink.ingredients,
                image: drink.imageUrl,
                price: drink.price,
                type: drink.type,
                isFavorite: true,
                quantity: 0,
              ).toJson())
          .toList();
      await prefs.setString(kFavoriteDrinksKey, jsonEncode(jsonList));
    } catch (e) {
      print('Error saving favorites: $e');
    }
  }

  void toggleFavorite(Drink drink) {
    final isCurrentlyFavorite = state.any((item) => item.id == drink.id);
    if (isCurrentlyFavorite) {
      state = state.where((item) => item.id != drink.id).toList();
    } else {
      state = [...state, drink.copyWith(isFavorite: true)];
    }
    _saveFavorites();
  }
}

final favoriteDrinksProvider = StateNotifierProvider<FavoriteDrinksNotifier, List<Drink>>((ref) {
  return FavoriteDrinksNotifier();
});