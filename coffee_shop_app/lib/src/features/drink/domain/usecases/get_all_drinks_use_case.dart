
import 'package:coffee_shop_app/src/features/drink/domain/entities/drink.dart';
import 'package:coffee_shop_app/src/features/drink/domain/repositories/drink_repository.dart';

class GetAllDrinksUseCase {
  final DrinkRepository _repository;
  GetAllDrinksUseCase(this._repository);
  Future<List<Drink>> call() => _repository.getAllDrinks();
}