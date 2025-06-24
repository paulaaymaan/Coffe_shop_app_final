
import 'package:google_maps_flutter/google_maps_flutter.dart';

class DeliveryLocation {
  final LatLng coordinates;
  final String address;

  const DeliveryLocation({
    required this.coordinates,
    required this.address,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is DeliveryLocation && other.coordinates == coordinates && other.address == address;
  }

  @override
  int get hashCode => coordinates.hashCode ^ address.hashCode;
}