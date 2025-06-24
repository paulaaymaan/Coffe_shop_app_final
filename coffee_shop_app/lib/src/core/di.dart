import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:permission_handler/permission_handler.dart';

import 'package:coffee_shop_app/src/features/drink/data/datasources/drink_api_data_source.dart';
import 'package:coffee_shop_app/src/features/drink/data/repositories/drink_repository_impl.dart';
import 'package:coffee_shop_app/src/features/drink/domain/repositories/drink_repository.dart';
import 'package:coffee_shop_app/src/features/drink/domain/usecases/get_all_drinks_use_case.dart';
import 'package:coffee_shop_app/src/features/drink/domain/usecases/get_cold_drinks_use_case.dart';
import 'package:coffee_shop_app/src/features/drink/domain/usecases/get_hot_drinks_use_case.dart';

import 'package:coffee_shop_app/src/features/cart/data/cart_local_data_source.dart';
import 'package:coffee_shop_app/src/features/cart/domain/repositories/cart_repository.dart';
import 'package:coffee_shop_app/src/features/cart/data/cart_repository_impl.dart';

import 'package:coffee_shop_app/src/features/location/data/local/location_local_data_source.dart';
import 'package:coffee_shop_app/src/features/location/domain/repositories/location_repository.dart';
import 'package:coffee_shop_app/src/features/location/data/location_repository_impl.dart';
import 'package:coffee_shop_app/src/features/location/domain/usecases/get_current_location_use_case.dart';
import 'package:coffee_shop_app/src/features/location/domain/usecases/update_location_use_case.dart';
import 'package:coffee_shop_app/src/features/location/domain/usecases/check_location_permission_use_case.dart';

import 'package:coffee_shop_app/src/features/onboarding/data/onboarding_local_data_source.dart';
import 'package:coffee_shop_app/src/features/onboarding/domain/repositories/onboarding_repository.dart';
import 'package:coffee_shop_app/src/features/onboarding/data/onboarding_repository_impl.dart';
import 'package:coffee_shop_app/src/features/onboarding/domain/usecases/check_onboarding_complete_use_case.dart';
import 'package:coffee_shop_app/src/features/onboarding/domain/usecases/set_onboarding_complete_use_case.dart';

part 'di.g.dart';


@riverpod
Future<SharedPreferences> sharedPreferences(SharedPreferencesRef ref) {
  return SharedPreferences.getInstance();
}

@riverpod
GeolocatorPlatform geolocatorPlatform(GeolocatorPlatformRef ref) {
  return GeolocatorPlatform.instance;
}


@riverpod
DrinkApiDataSource drinkApiDataSource(DrinkApiDataSourceRef ref) {
  return DrinkApiDataSourceImpl();
}

@riverpod
DrinkRepository drinkRepository(DrinkRepositoryRef ref) {
  return DrinkRepositoryImpl(ref.watch(drinkApiDataSourceProvider));
}

@riverpod
GetAllDrinksUseCase getAllDrinksUseCase(GetAllDrinksUseCaseRef ref) {
  return GetAllDrinksUseCase(ref.watch(drinkRepositoryProvider));
}

@riverpod
GetHotDrinksUseCase getHotDrinksUseCase(GetHotDrinksUseCaseRef ref) {
  return GetHotDrinksUseCase(ref.watch(drinkRepositoryProvider));
}

@riverpod
GetColdDrinksUseCase getColdDrinksUseCase(GetColdDrinksUseCaseRef ref) {
  return GetColdDrinksUseCase(ref.watch(drinkRepositoryProvider));
}


@riverpod
CartLocalDataSource cartLocalDataSource(CartLocalDataSourceRef ref) {
  final prefs = ref.watch(sharedPreferencesProvider).requireValue;
  return CartLocalDataSourceImpl(prefs);
}

@riverpod
CartRepository cartRepository(CartRepositoryRef ref) {
  final localDataSource = ref.watch(cartLocalDataSourceProvider);
  return CartRepositoryImpl(localDataSource);
}


@riverpod
LocationLocalDataSource locationLocalDataSource(LocationLocalDataSourceRef ref) {
  final prefs = ref.watch(sharedPreferencesProvider).requireValue;
  return LocationLocalDataSourceImpl(prefs);
}

@riverpod
LocationRepository locationRepository(LocationRepositoryRef ref) {
  final geolocator = ref.watch(geolocatorPlatformProvider);
  final localDataSource = ref.watch(locationLocalDataSourceProvider);
  return LocationRepositoryImpl(geolocator, localDataSource);
}

@riverpod
GetCurrentLocationUseCase getCurrentLocationUseCase(GetCurrentLocationUseCaseRef ref) {
  return GetCurrentLocationUseCase(ref.watch(locationRepositoryProvider));
}

@riverpod
UpdateLocationUseCase updateLocationUseCase(UpdateLocationUseCaseRef ref) {
  return UpdateLocationUseCase(ref.watch(locationRepositoryProvider));
}

@riverpod
CheckLocationPermissionUseCase checkLocationPermissionUseCase(CheckLocationPermissionUseCaseRef ref) {
  return CheckLocationPermissionUseCase(ref.watch(locationRepositoryProvider));
}

@riverpod
RequestLocationPermissionUseCase requestLocationPermissionUseCase(RequestLocationPermissionUseCaseRef ref) {
  return RequestLocationPermissionUseCase(ref.watch(locationRepositoryProvider));
}


@riverpod
OnboardingLocalDataSource onboardingLocalDataSource(OnboardingLocalDataSourceRef ref) {
  final prefs = ref.watch(sharedPreferencesProvider).requireValue;
  return OnboardingLocalDataSourceImpl(prefs);
}

@riverpod
OnboardingRepository onboardingRepository(OnboardingRepositoryRef ref) {
  final localDataSource = ref.watch(onboardingLocalDataSourceProvider);
  return OnboardingRepositoryImpl(localDataSource);
}

@riverpod
CheckOnboardingCompleteUseCase checkOnboardingCompleteUseCase(CheckOnboardingCompleteUseCaseRef ref) {
  return CheckOnboardingCompleteUseCase(ref.watch(onboardingRepositoryProvider));
}

@riverpod
SetOnboardingCompleteUseCase setOnboardingCompleteUseCase(SetOnboardingCompleteUseCaseRef ref) {
  return SetOnboardingCompleteUseCase(ref.watch(onboardingRepositoryProvider));
}