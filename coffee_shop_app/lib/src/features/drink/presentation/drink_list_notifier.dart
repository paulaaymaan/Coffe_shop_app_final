
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:coffee_shop_app/src/core/di.dart';
import 'package:coffee_shop_app/src/features/drink/domain/entities/drink.dart';

part 'drink_list_notifier.g.dart';

enum DrinkFilter { all, hot, cold }

@riverpod
class DrinkList extends _$DrinkList {
  String _searchQuery = '';
  List<Drink> _allDrinks = [];

  String get searchQuery => _searchQuery;

  @override
  Future<List<Drink>> build() async {
    _searchQuery = '';
    _allDrinks = await ref.watch(getAllDrinksUseCaseProvider).call();
    return _allDrinks; 
  }

  List<Drink> _applyFilterAndSearch(DrinkFilter filter) {
    List<Drink> filteredList;

    switch (filter) {
      case DrinkFilter.hot:
        filteredList =
            _allDrinks.where((drink) => drink.type == 'hot').toList();
        break;
      case DrinkFilter.cold:
        filteredList =
            _allDrinks.where((drink) => drink.type == 'cold').toList();
        break;
      case DrinkFilter.all:
      default:
        filteredList = _allDrinks;
        break;
    }

    if (_searchQuery.isNotEmpty) {
      filteredList =
          filteredList
              .where(
                (drink) => drink.title.toLowerCase().contains(
                  _searchQuery.toLowerCase(),
                ),
              )
              .toList();
    }

    return filteredList;
  }

  void filterDrinks(DrinkFilter filter) {
    state = AsyncData(_applyFilterAndSearch(filter));
  }

  void setSearchQuery(String query) {
    _searchQuery = query;
    final currentFilter = ref.read(selectedDrinkFilterProvider);
    state = AsyncData(_applyFilterAndSearch(currentFilter));
  }
}

@riverpod
class SelectedDrinkFilter extends _$SelectedDrinkFilter {
  @override
  DrinkFilter build() => DrinkFilter.all;

  void setFilter(DrinkFilter filter) {
    if (state != filter) {
      state = filter;
      ref.read(drinkListProvider.notifier).filterDrinks(filter);
    }
  }
}
