import 'package:coffee_shop_app/src/features/location/data/local/location_local_data_source.dart';
import 'package:coffee_shop_app/src/features/location/domain/repositories/location_repository.dart';
import 'package:coffee_shop_app/src/features/location/domain/entities/delivery_location.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter/services.dart';

class LocationRepositoryImpl implements LocationRepository {
  final GeolocatorPlatform _geolocator;
  final LocationLocalDataSource _localDataSource;

  LocationRepositoryImpl(this._geolocator, this._localDataSource);

  @override
  Future<DeliveryLocation> getCurrentLocation() async {
    try {
      if (!await _localDataSource.checkLocationPermission()) {
        throw Exception('Location permission not granted');
      }

      final lastLocation = _localDataSource.getLastLocation();
      if (lastLocation != null) return lastLocation;

      final position = await _geolocator.getCurrentPosition();
      final coords = LatLng(position.latitude, position.longitude);
      final address = await getAddressFromCoordinates(coords);
      
      final newLocation = DeliveryLocation(coordinates: coords, address: address);
      await _localDataSource.saveLocation(newLocation);
      
      return newLocation;
    } on PlatformException catch (e) {
      throw Exception('Platform Error getting location: ${e.message}');
    } catch (e) {
      throw Exception('Failed to get current location: $e');
    }
  }

  @override
  Future<String> getAddressFromCoordinates(LatLng coords) async {
    try {
      final placemarks = await placemarkFromCoordinates(
        coords.latitude, 
        coords.longitude,
      );
      
      if (placemarks.isNotEmpty) {
        final place = placemarks.first;
        final parts = [
          place.street,
          place.subLocality,
          place.locality,
          place.administrativeArea,
          place.country
        ].where((p) => p != null && p.isNotEmpty).toList();
        
        return parts.join(', ');
      }
      return 'Lat: ${coords.latitude.toStringAsFixed(4)}, Lng: ${coords.longitude.toStringAsFixed(4)}';
    } catch (e) {
      print('Error getting address from coordinates: $e');
      return 'Unknown address';
    }
  }
  
  @override
  Future<void> updateLocation(DeliveryLocation newLocation) async {
    await _localDataSource.saveLocation(newLocation);
  }

  @override
  Future<bool> checkLocationPermission() async {
    return await _localDataSource.checkLocationPermission();
  }

  @override
  Future<void> requestLocationPermission() async {
    await _localDataSource.requestLocationPermission();
  }

  @override
  Future<bool> isLocationPermissionPermanentlyDenied() async {
    return await _localDataSource.isLocationPermissionPermanentlyDenied();
  }

  @override
  Future<void> openAppSettings() async {
    await _localDataSource.openAppSettings();
  }
}