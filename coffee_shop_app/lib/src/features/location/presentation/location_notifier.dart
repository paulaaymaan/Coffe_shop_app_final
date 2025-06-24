import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:coffee_shop_app/src/features/location/domain/entities/delivery_location.dart';
import 'package:coffee_shop_app/src/core/di.dart';
import 'package:coffee_shop_app/src/features/location/domain/usecases/check_location_permission_use_case.dart';

part 'location_notifier.g.dart';

@riverpod
class CurrentLocation extends _$CurrentLocation {
  @override
  Future<DeliveryLocation?> build() async {
    try {
      final hasPermission = await ref.read(checkLocationPermissionUseCaseProvider).execute();
      
      if (!hasPermission) {
        return null;
      }
      
      return await ref.read(getCurrentLocationUseCaseProvider).call();
    } catch (e) {
      print('Error in CurrentLocation provider: $e');
      return null;
    }
  }

  Future<void> updateLocation(DeliveryLocation newLocation) async {
    try {
      state = const AsyncValue.loading();
      await ref.read(updateLocationUseCaseProvider).call(newLocation);
      state = AsyncValue.data(newLocation);
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }

  Future<bool> checkPermission() async {
    return await ref.read(checkLocationPermissionUseCaseProvider).execute();
  }

  Future<bool> requestPermission() async {
    return await ref.read(requestLocationPermissionUseCaseProvider).execute();
  }

  Future<void> openAppSettings() async {
    await ref.read(locationRepositoryProvider).openAppSettings();
  }
}