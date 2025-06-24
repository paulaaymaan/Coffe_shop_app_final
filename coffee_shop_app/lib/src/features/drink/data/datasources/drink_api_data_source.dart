
import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'package:coffee_shop_app/src/features/drink/data/models/drink_model.dart';
import 'dart:math';

const String _hotDrinksAssetPath = 'assets/hot_drinks.json';
const String _coldDrinksAssetPath = 'assets/cold_drinks.json';

abstract class DrinkApiDataSource {
  Future<List<DrinkModel>> getHotDrinks();
  Future<List<DrinkModel>> getColdDrinks();
  Future<List<DrinkModel>> getAllDrinks();
}

class DrinkApiDataSourceImpl implements DrinkApiDataSource {
  final Random _random = Random();

  DrinkApiDataSourceImpl();

  double _generateRandomPrice() {
    return double.parse((_random.nextDouble() * 7.0 + 3.0).toStringAsFixed(2));
  }

  Future<List<DrinkModel>> _loadDrinksFromAsset(String assetPath, String type) async {
    try {
      final String jsonString = await rootBundle.loadString(assetPath);
      final List<dynamic> jsonList = jsonDecode(jsonString);
      return jsonList.map((json) {
        final drink = DrinkModel.fromJson(json);
        return drink.copyWith(price: _generateRandomPrice(), type: type);
      }).toList();
    } catch (e, st) {
      print('Error loading drinks from asset $assetPath: $e\n$st');
      throw Exception('Failed to load drinks from asset: $e');
    }
  }

  @override
  Future<List<DrinkModel>> getHotDrinks() async {
    return _loadDrinksFromAsset(_hotDrinksAssetPath, 'hot');
  }

  @override
  Future<List<DrinkModel>> getColdDrinks() async {
    return _loadDrinksFromAsset(_coldDrinksAssetPath, 'cold');
  }

  @override
  Future<List<DrinkModel>> getAllDrinks() async {
    try {
      final hotDrinks = await getHotDrinks();
      final coldDrinks = await getColdDrinks();
      return [...hotDrinks, ...coldDrinks];
    } catch (e, st) {
      print('Error combining drinks from assets: $e\n$st');
      throw Exception('Failed to load or combine all drink data from assets: ${e.toString()}');
    }
  }
}