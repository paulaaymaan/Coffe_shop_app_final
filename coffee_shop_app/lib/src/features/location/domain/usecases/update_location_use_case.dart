import 'package:coffee_shop_app/src/features/location/domain/entities/delivery_location.dart';
import 'package:coffee_shop_app/src/features/location/domain/repositories/location_repository.dart';

class UpdateLocationUseCase {
  final LocationRepository _repository;
  UpdateLocationUseCase(this._repository);
  
  Future<void> call(DeliveryLocation newLocation) => 
      _repository.updateLocation(newLocation);
}