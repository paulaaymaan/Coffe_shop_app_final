// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'drink_list_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$drinkListHash() => r'43c953053800b801375b19bfbf07e36ec757d043';

/// See also [DrinkList].
@ProviderFor(DrinkList)
final drinkListProvider =
    AutoDisposeAsyncNotifierProvider<DrinkList, List<Drink>>.internal(
      DrinkList.new,
      name: r'drinkListProvider',
      debugGetCreateSourceHash:
          const bool.fromEnvironment('dart.vm.product')
              ? null
              : _$drinkListHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$DrinkList = AutoDisposeAsyncNotifier<List<Drink>>;
String _$selectedDrinkFilterHash() =>
    r'5bf17b358753644e6257d0d4883b56ebd5c94ae5';

/// See also [SelectedDrinkFilter].
@ProviderFor(SelectedDrinkFilter)
final selectedDrinkFilterProvider =
    AutoDisposeNotifierProvider<SelectedDrinkFilter, DrinkFilter>.internal(
      SelectedDrinkFilter.new,
      name: r'selectedDrinkFilterProvider',
      debugGetCreateSourceHash:
          const bool.fromEnvironment('dart.vm.product')
              ? null
              : _$selectedDrinkFilterHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$SelectedDrinkFilter = AutoDisposeNotifier<DrinkFilter>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
