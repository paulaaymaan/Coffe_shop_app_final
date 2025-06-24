
import 'package:coffee_shop_app/src/features/cart/data/cart_local_data_source.dart';
import 'package:coffee_shop_app/src/features/cart/domain/repositories/cart_repository.dart';
import 'package:coffee_shop_app/src/features/drink/domain/entities/drink.dart';
import 'package:coffee_shop_app/src/features/drink/data/models/drink_model.dart';

class CartRepositoryImpl implements CartRepository {
  final CartLocalDataSource _localDataSource;
  CartRepositoryImpl(this._localDataSource);

  @override
  Future<List<Drink>> getSavedCart() async {
    try {
      final models = await _localDataSource.loadCartItems();
      return models.map((model) => Drink.fromModel(model)).toList();
    } catch (e) {
      print('Error getting saved cart: $e');
      return [];
    }
  }

  @override
  Future<void> saveCart(List<Drink> cartItems) async {
    try {
      final models = cartItems.map((drink) => DrinkModel(
            id: drink.id,
            title: drink.title,
            description: drink.description,
            ingredients: drink.ingredients,
            image: drink.imageUrl,
            price: drink.price,
            type: drink.type,
            isFavorite: drink.isFavorite,
            quantity: drink.quantity,
          )).toList();
      await _localDataSource.saveCartItems(models);
    } catch (e) {
      print('Error saving cart: $e');
    }
  }
}