
import 'package:coffee_shop_app/src/features/drink/domain/entities/drink.dart';

abstract class CartRepository {
  Future<List<Drink>> getSavedCart();
  Future<void> saveCart(List<Drink> cartItems);
}