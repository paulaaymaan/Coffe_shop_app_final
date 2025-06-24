
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geocoding/geocoding.dart';
import 'package:coffee_shop_app/src/features/location/domain/entities/delivery_location.dart';
import 'package:coffee_shop_app/src/features/cart/presentation/screens/cart_screen.dart'; 

const LatLng _defaultStoreLocation = LatLng(
  29.9679,
  31.2695,
); 
const String _storeAddressPlaceholder =
    'Your Store Location'; 

class EditAddressScreen extends ConsumerStatefulWidget {
  const EditAddressScreen({super.key, DeliveryLocation? initialLocation});

  @override
  ConsumerState<EditAddressScreen> createState() => _EditAddressScreenState();
}

class _EditAddressScreenState extends ConsumerState<EditAddressScreen> {
  GoogleMapController? _mapController;
  LatLng? _selectedLocation;
  String _displayedAddress =
      'Getting address...'; 
  bool _isResolvingAddress =
      false; 

  @override
  void initState() {
    super.initState();
    final currentDeliveryLocation =
        ref.read(editableDeliveryAddressProvider).valueOrNull;

    if (currentDeliveryLocation != null) {
      _selectedLocation =
          currentDeliveryLocation
              .coordinates; 
      _displayedAddress =
          currentDeliveryLocation
              .address; 
      print(
        'EditAddressScreen: Initialized with current delivery location: $_displayedAddress',
      );
      if (_displayedAddress.startsWith('Getting address...') ||
          _displayedAddress.startsWith('Error getting address:')) {
        _updateDisplayedAddress(_selectedLocation!);
      }
    } else {
      _selectedLocation = _defaultStoreLocation;
      _updateDisplayedAddress(
        _defaultStoreLocation,
      ); 
      print(
        'EditAddressScreen: Initialized with default store location as fallback.',
      );
    }
  }

  void _onMapCreated(GoogleMapController controller) {
    _mapController = controller;

    if (_selectedLocation != null) {
      _mapController?.animateCamera(
        CameraUpdate.newLatLngZoom(_selectedLocation!, 14),
      );
    } else {
      _mapController?.animateCamera(
        CameraUpdate.newLatLngZoom(_defaultStoreLocation, 14),
      );
    }

  }

  void _onMapTap(LatLng location) {
    print(
      'EditAddressScreen: Map tapped at ${location.latitude}, ${location.longitude}',
    );
    if (!_isResolvingAddress || _selectedLocation != location) {
      setState(() {
        _selectedLocation =
            location; 
        _displayedAddress = 'Getting address...'; 
        _isResolvingAddress = true; 
      });
      _updateDisplayedAddress(location);
      _mapController?.animateCamera(CameraUpdate.newLatLng(location));
    }
  }

  Future<void> _updateDisplayedAddress(LatLng location) async {
    if (_selectedLocation != location && _isResolvingAddress) {
      print(
        'EditAddressScreen: Selected location changed during geocoding. Aborting old resolution.',
      );
      return;
    }


    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
        location.latitude,
        location.longitude,
      );

      String resolvedAddress;
      if (placemarks.isNotEmpty) {
        Placemark place = placemarks.first;
        resolvedAddress = '';
        if (place.street != null && place.street!.isNotEmpty)
          resolvedAddress += place.street!;
        if (place.subLocality != null &&
            place.subLocality!.isNotEmpty &&
            !resolvedAddress.contains(place.subLocality!))
          resolvedAddress +=
              (resolvedAddress.isEmpty ? '' : ', ') + place.subLocality!;
        if (place.locality != null &&
            place.locality!.isNotEmpty &&
            !resolvedAddress.contains(place.locality!))
          resolvedAddress +=
              (resolvedAddress.isEmpty ? '' : ', ') + place.locality!;
        if (place.administrativeArea != null &&
            place.administrativeArea!.isNotEmpty &&
            !resolvedAddress.contains(place.administrativeArea!))
          resolvedAddress +=
              (resolvedAddress.isEmpty ? '' : ', ') + place.administrativeArea!;
        if (place.country != null &&
            place.country!.isNotEmpty &&
            !resolvedAddress.contains(place.country!))
          resolvedAddress +=
              (resolvedAddress.isEmpty ? '' : ', ') + place.country!;

        if (resolvedAddress.isEmpty) {
          resolvedAddress =
              'Lat: ${location.latitude.toStringAsFixed(4)}, Lng: ${location.longitude.toStringAsFixed(4)}';
        }

        print('EditAddressScreen: Geocoding success: $resolvedAddress');
      } else {
        resolvedAddress = "Address not found for this location";
        print('EditAddressScreen: Geocoding found no placemarks.');
      }

      if (mounted && _selectedLocation == location) {
        setState(() {
          _displayedAddress = resolvedAddress;
          _isResolvingAddress = false; 
        });
      } else if (_selectedLocation != location) {
        print('EditAddressScreen: Geocoding finished for old location.');
        if (mounted) {
          setState(() {
            _isResolvingAddress = false; 
          });
        }
      }
    } catch (e) {
      print('EditAddressScreen: Geocoding error: $e');
      if (mounted && _selectedLocation == location) {
        setState(() {
          _displayedAddress =
              'Error getting address: ${e.toString().split(':').first}';
          _isResolvingAddress = false; 
        });
      } else if (_selectedLocation != location) {
        print('EditAddressScreen: Geocoding error for old location.');
        if (mounted) {
          setState(() {
            _isResolvingAddress = false;
          });
        }
      }
    }
  }

  Set<Marker> _buildMarkers() {
    final markers = <Marker>{
      Marker(
        markerId: const MarkerId('store_location'),
        position: _defaultStoreLocation, 
        infoWindow: const InfoWindow(title: _storeAddressPlaceholder),
        icon: BitmapDescriptor.defaultMarkerWithHue(
          BitmapDescriptor.hueGreen,
        ), 
      ),
    };
    if (_selectedLocation != null) {
      markers.add(
        Marker(
          markerId: const MarkerId('selected_location'),
          position: _selectedLocation!, 
          infoWindow: InfoWindow(
            title: 'Delivery Location',
            snippet: _displayedAddress,
          ),
          icon: BitmapDescriptor.defaultMarkerWithHue(
            BitmapDescriptor.hueBlue,
          ), 
        ),
      );
    }
    return markers;
  }

  Set<Polyline> _buildPolylines() {
    if (_selectedLocation == null ||
        _selectedLocation == _defaultStoreLocation) {
      return {};
    }
    return {
      Polyline(
        polylineId: const PolylineId('route_to_selected'),
        points: [_defaultStoreLocation, _selectedLocation!],
        color: Colors.orange, 
        width: 4, 
      ),
    };
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Delivery Address'),
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: Colors.black87,
      ),
      body: Column(
        children: [
          Expanded(
            child: GoogleMap(
              onMapCreated: _onMapCreated,
              initialCameraPosition: CameraPosition(
                target:
                    _selectedLocation ??
                    _defaultStoreLocation, 
                zoom: 14,
              ),
              markers:
                  _buildMarkers(), 
              polylines:
                  _buildPolylines(), 
              onTap: _onMapTap, 
              myLocationEnabled: true, 
              myLocationButtonEnabled:
                  true, 
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Selected Location: $_displayedAddress',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14, color: Colors.grey[800]),
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed:
                    _selectedLocation == null ||
                            _isResolvingAddress ||
                            _displayedAddress.startsWith(
                              'Error getting address:',
                            )
                        ? null 
                        : () {
                          final newDeliveryLocation = DeliveryLocation(
                            coordinates: _selectedLocation!,
                            address: _displayedAddress,
                          );
                          Navigator.pop(context, newDeliveryLocation);
                        },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  backgroundColor: const Color(0xFFC67C4E),
                  disabledBackgroundColor: const Color(
                    0xFFC67C4E,
                  ).withOpacity(0.5),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Confirm New Address',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }
}
