import 'package:coffee_shop_app/src/features/location/domain/repositories/location_repository.dart';

class CheckLocationPermissionUseCase {
  final LocationRepository repository;

  CheckLocationPermissionUseCase(this.repository);

  Future<bool> execute() async {
    return await repository.checkLocationPermission();
  }
}

class RequestLocationPermissionUseCase {
  final LocationRepository repository;

  RequestLocationPermissionUseCase(this.repository);

  Future<bool> execute() async {
    await repository.requestLocationPermission();
    return await repository.checkLocationPermission();
  }
}