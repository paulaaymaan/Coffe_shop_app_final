// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cart_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$cartTotalAmountHash() => r'7b08842b5cdaf9127c906b03bdb01704fb3eac62';

/// See also [cartTotalAmount].
@ProviderFor(cartTotalAmount)
final cartTotalAmountProvider = AutoDisposeProvider<double>.internal(
  cartTotalAmount,
  name: r'cartTotalAmountProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$cartTotalAmountHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef CartTotalAmountRef = AutoDisposeProviderRef<double>;
String _$cartTotalItemCountHash() =>
    r'07fe7cff16d9551c05841e7650ce6a06ec13084e';

/// See also [cartTotalItemCount].
@ProviderFor(cartTotalItemCount)
final cartTotalItemCountProvider = AutoDisposeProvider<int>.internal(
  cartTotalItemCount,
  name: r'cartTotalItemCountProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$cartTotalItemCountHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef CartTotalItemCountRef = AutoDisposeProviderRef<int>;
String _$cartItemsHash() => r'5c820c6265b4fde2862fff2edbd2188ad44bc803';

/// See also [CartItems].
@ProviderFor(CartItems)
final cartItemsProvider =
    AutoDisposeAsyncNotifierProvider<CartItems, List<Drink>>.internal(
      CartItems.new,
      name: r'cartItemsProvider',
      debugGetCreateSourceHash:
          const bool.fromEnvironment('dart.vm.product')
              ? null
              : _$cartItemsHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$CartItems = AutoDisposeAsyncNotifier<List<Drink>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
