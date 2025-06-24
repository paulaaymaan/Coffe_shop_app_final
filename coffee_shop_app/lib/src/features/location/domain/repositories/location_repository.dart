import 'package:coffee_shop_app/src/features/location/domain/entities/delivery_location.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

abstract class LocationRepository {
  Future<DeliveryLocation> getCurrentLocation();
  Future<String> getAddressFromCoordinates(LatLng coords);
  Future<void> updateLocation(DeliveryLocation newLocation);
  
  Future<bool> checkLocationPermission();
  Future<void> requestLocationPermission();
  Future<bool> isLocationPermissionPermanentlyDenied();
  Future<void> openAppSettings();
}