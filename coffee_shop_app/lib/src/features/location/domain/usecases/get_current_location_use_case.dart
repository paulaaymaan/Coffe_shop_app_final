
import 'package:coffee_shop_app/src/features/location/domain/entities/delivery_location.dart';
import 'package:coffee_shop_app/src/features/location/domain/repositories/location_repository.dart';

class GetCurrentLocationUseCase {
  final LocationRepository _repository;
  GetCurrentLocationUseCase(this._repository);
  Future<DeliveryLocation> call() => _repository.getCurrentLocation();
}