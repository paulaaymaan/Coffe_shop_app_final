
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:coffee_shop_app/src/features/drink/domain/entities/drink.dart';
import 'package:coffee_shop_app/src/features/drink/data/models/drink_model.dart';
import 'package:coffee_shop_app/src/core/di.dart';
import 'package:coffee_shop_app/src/features/cart/data/cart_local_data_source.dart';

part 'cart_notifier.g.dart';

@riverpod
class CartItems extends _$CartItems {
  late final CartLocalDataSource _localDataSource;

  @override
  Future<List<Drink>> build() async {
    print('CartItems AsyncNotifier build() called. Loading initial state...');

    _localDataSource = ref.watch(
      cartLocalDataSourceProvider,
    ); 

    try {
      final loadedModels = await _localDataSource.loadCartItems();
      final loadedCart =
          loadedModels.map((model) => Drink.fromModel(model)).toList();
      print('CartItems: Successfully loaded ${loadedCart.length} items.');
      return loadedCart;
    } catch (e, st) {
      print('CartItems: *** ERROR LOADING CART ITEMS: $e\n$st ***');
      return [];
    }
  }

  Future<void> _saveCart(List<Drink> cartItems) async {
    try {
      final models =
          cartItems
              .map(
                (drink) => DrinkModel(
                  id: drink.id,
                  title: drink.title,
                  description: drink.description,
                  ingredients: drink.ingredients,
                  image: drink.imageUrl,
                  price: drink.price,
                  type: drink.type,
                  isFavorite: drink.isFavorite,
                  quantity: drink.quantity,
                ),
              )
              .toList();
      await _localDataSource.saveCartItems(models);
    } catch (e) {
      print('Error saving cart: $e');
    }
  }

  Future<void> addItem(Drink drink) async {
    final currentItems = state.valueOrNull ?? [];
    final existingItemIndex = currentItems.indexWhere(
      (item) => item.id == drink.id,
    );
    List<Drink> newList;
    if (existingItemIndex != -1) {
      final existingItem = currentItems[existingItemIndex];
      final updatedItem = existingItem.copyWith(
        quantity: existingItem.quantity + 1,
      );
      newList = List<Drink>.from(currentItems);
      newList[existingItemIndex] = updatedItem;
    } else {
      newList = [...currentItems, drink.copyWith(quantity: 1)];
    }
    state = AsyncData(newList);
    await _saveCart(newList);
  }

  Future<void> removeItem(Drink drink) async {
    final currentItems = state.valueOrNull ?? [];
    final existingItemIndex = currentItems.indexWhere(
      (item) => item.id == drink.id,
    );
    if (existingItemIndex != -1) {
      final existingItem = currentItems[existingItemIndex];
      List<Drink> newList;
      if (existingItem.quantity > 1) {
        final updatedItem = existingItem.copyWith(
          quantity: existingItem.quantity - 1,
        );
        newList = List<Drink>.from(currentItems);
        newList[existingItemIndex] = updatedItem;
      } else {
        newList = currentItems.where((item) => item.id != drink.id).toList();
      }
      state = AsyncData(newList);
      await _saveCart(newList);
    }
  }

  Future<void> clearCart() async {
    state = const AsyncData([]);
    await _saveCart([]);
  }
}

@riverpod
double cartTotalAmount(CartTotalAmountRef ref) {
  final cartItems = ref.watch(cartItemsProvider).valueOrNull ?? [];
  return cartItems.fold(
    0.0,
    (sum, item) => sum + (item.price ?? 0) * item.quantity,
  );
}

@riverpod
int cartTotalItemCount(CartTotalItemCountRef ref) {
  final cartItems = ref.watch(cartItemsProvider).valueOrNull ?? [];
  return cartItems.fold(0, (sum, item) => sum + item.quantity);
}
