
import 'package:coffee_shop_app/src/features/drink/data/datasources/drink_api_data_source.dart';
import 'package:coffee_shop_app/src/features/drink/domain/entities/drink.dart';
import 'package:coffee_shop_app/src/features/drink/domain/repositories/drink_repository.dart';
import 'package:coffee_shop_app/src/features/drink/data/models/drink_model.dart';

class DrinkRepositoryImpl implements DrinkRepository {
  final DrinkApiDataSource _apiDataSource;

  DrinkRepositoryImpl(this._apiDataSource);

  List<Drink> _mapAndFilter(List<DrinkModel> models) {
    final filteredModels = models.where((model) =>
      model.image != null &&
      model.image != 'null' &&
      model.image != 'none' &&
      model.image.isNotEmpty
    ).toList();
    return filteredModels.map((model) => Drink.fromModel(model)).toList();
  }

  @override
  Future<List<Drink>> getAllDrinks() async {
    try {
      final allDrinksModels = await _apiDataSource.getAllDrinks();
      return _mapAndFilter(allDrinksModels);
    } catch (e) {
      print('Repository error fetching all drinks: $e');
      throw Exception('Failed to get all drinks');
    }
  }

  @override
  Future<List<Drink>> getHotDrinks() async {
    try {
      final hotDrinksModels = await _apiDataSource.getHotDrinks();
      return _mapAndFilter(hotDrinksModels);
    } catch (e) {
      print('Repository error fetching hot drinks: $e');
      throw Exception('Failed to get hot drinks');
    }
  }

  @override
  Future<List<Drink>> getColdDrinks() async {
    try {
      final coldDrinksModels = await _apiDataSource.getColdDrinks();
      return _mapAndFilter(coldDrinksModels);
    } catch (e) {
      print('Repository error fetching cold drinks: $e');
      throw Exception('Failed to get cold drinks');
    }
  }
}