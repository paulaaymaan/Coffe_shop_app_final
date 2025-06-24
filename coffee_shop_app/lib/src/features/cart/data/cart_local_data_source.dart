
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:coffee_shop_app/src/features/drink/data/models/drink_model.dart';
import 'package:coffee_shop_app/src/core/constants.dart';

abstract class CartLocalDataSource {
  Future<List<DrinkModel>> loadCartItems();
  Future<void> saveCartItems(List<DrinkModel> items);
}

class CartLocalDataSourceImpl implements CartLocalDataSource {
  final SharedPreferences _prefs;
  CartLocalDataSourceImpl(this._prefs);

  @override
  Future<List<DrinkModel>> loadCartItems() async {
    try {
      final String? cartJsonString = _prefs.getString(kCartItemsKey);
      if (cartJsonString != null && cartJsonString.isNotEmpty) {
        final List<dynamic> jsonList = jsonDecode(cartJsonString);
        return jsonList.map((json) => DrinkModel.fromJson(json)).toList();
      }
      return [];
    } catch (e) {
      print('Error loading cart items: $e');
      return [];
    }
  }

  @override
  Future<void> saveCartItems(List<DrinkModel> items) async {
    try {
      final List<Map<String, dynamic>> jsonList = items.map((item) => item.toJson()).toList();
      await _prefs.setString(kCartItemsKey, jsonEncode(jsonList));
    } catch (e) {
      print('Error saving cart items: $e');
    }
  }
}