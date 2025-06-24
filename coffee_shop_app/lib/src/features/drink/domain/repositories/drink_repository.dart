
import 'package:coffee_shop_app/src/features/drink/domain/entities/drink.dart';

abstract class DrinkRepository {
  Future<List<Drink>> getAllDrinks();
  Future<List<Drink>> getHotDrinks();
  Future<List<Drink>> getColdDrinks();
}