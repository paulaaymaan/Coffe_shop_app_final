import 'package:shared_preferences/shared_preferences.dart';
import 'package:coffee_shop_app/src/features/location/domain/entities/delivery_location.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:permission_handler/permission_handler.dart';

abstract class LocationLocalDataSource {
  Future<void> saveLocation(DeliveryLocation location);
  DeliveryLocation? getLastLocation();
  Future<bool> checkLocationPermission();
  Future<void> requestLocationPermission();
  Future<bool> isLocationPermissionPermanentlyDenied();
  Future<void> openAppSettings();
}

class LocationLocalDataSourceImpl implements LocationLocalDataSource {
  static const _locationKey = 'last_delivery_location';
  static const _latitudeKey = 'last_latitude';
  static const _longitudeKey = 'last_longitude';
  static const _addressKey = 'last_address';

  final SharedPreferences _prefs;

  LocationLocalDataSourceImpl(this._prefs);

  @override
  Future<void> saveLocation(DeliveryLocation location) async {
    await _prefs.setDouble(_latitudeKey, location.coordinates.latitude);
    await _prefs.setDouble(_longitudeKey, location.coordinates.longitude);
    await _prefs.setString(_addressKey, location.address);
  }

  @override
  DeliveryLocation? getLastLocation() {
    final lat = _prefs.getDouble(_latitudeKey);
    final lng = _prefs.getDouble(_longitudeKey);
    final address = _prefs.getString(_addressKey);

    if (lat != null && lng != null) {
      return DeliveryLocation(
        coordinates: LatLng(lat, lng),
        address: address ?? 'Unknown address',
      );
    }
    return null;
  }

  @override
  Future<bool> checkLocationPermission() async {
    final status = await Permission.location.status;
    return status.isGranted;
  }

  @override
  Future<void> requestLocationPermission() async {
    await Permission.location.request();
  }

  @override
  Future<bool> isLocationPermissionPermanentlyDenied() async {
    final status = await Permission.location.status;
    return status.isPermanentlyDenied;
  }

  @override
  Future<void> openAppSettings() async {
    await openAppSettings();
  }
}