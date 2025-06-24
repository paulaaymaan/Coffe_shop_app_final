
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:coffee_shop_app/src/features/cart/presentation/screens/cart_screen.dart'; 

const LatLng _defaultStoreLocation = LatLng(
  29.9679,
  31.2695,
); 
const String _storeAddressPlaceholder =
    'Your Store Location'; 

class DeliveryMapScreen extends ConsumerWidget {
  const DeliveryMapScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final deliveryLocationAsyncValue = ref.watch(
      editableDeliveryAddressProvider,
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Delivery Tracking'), 
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: Colors.black87,
      ),
      body: deliveryLocationAsyncValue.when(
        data: (deliveryLocation) {
          final storeLatLng = _defaultStoreLocation; 
          final deliveryLatLng =
              deliveryLocation
                  .coordinates; 

          final markers = <Marker>{
            Marker(
              markerId: const MarkerId('store_location'),
              position: storeLatLng,
              infoWindow: const InfoWindow(
                title: _storeAddressPlaceholder,
              ), // Store name
              icon: BitmapDescriptor.defaultMarkerWithHue(
                BitmapDescriptor.hueGreen,
              ), 
            ),
            Marker(
              markerId: const MarkerId('delivery_location'),
              position: deliveryLatLng,
              infoWindow: InfoWindow(
                title: 'Delivery Address',
                snippet: deliveryLocation.address,
              ), 
              icon: BitmapDescriptor.defaultMarkerWithHue(
                BitmapDescriptor.hueBlue,
              ), 
            ),
          };

          final polylines = <Polyline>{
            Polyline(
              polylineId: const PolylineId('delivery_route'),
              points: [
                storeLatLng,
                deliveryLatLng,
              ],
              color: Colors.orange, 
              width: 4, 
            ),
          };

          final bounds = LatLngBounds(
            southwest: LatLng(
              storeLatLng.latitude < deliveryLatLng.latitude
                  ? storeLatLng.latitude
                  : deliveryLatLng.latitude,
              storeLatLng.longitude < deliveryLatLng.longitude
                  ? storeLatLng.longitude
                  : deliveryLatLng.longitude,
            ),
            northeast: LatLng(
              storeLatLng.latitude > deliveryLatLng.latitude
                  ? storeLatLng.latitude
                  : deliveryLatLng.latitude,
              storeLatLng.longitude > deliveryLatLng.longitude
                  ? storeLatLng.longitude
                  : deliveryLatLng.longitude,
            ),
          );

          return GoogleMap(
            initialCameraPosition: CameraPosition(
              target:
                  storeLatLng, 
              zoom: 10,
            ),
            markers: markers,
            polylines: polylines,
            onMapCreated: (controller) {
              controller.animateCamera(
                CameraUpdate.newLatLngBounds(bounds, 100),
              ); 
            },
            myLocationEnabled: true, 
            myLocationButtonEnabled: true, 
          );
        },
        loading:
            () => const Center(
              child: CircularProgressIndicator(),
            ), 
        error:
            (error, st) => Center(
              child: Text('Error loading delivery map: ${error.toString()}'),
            ),
      ),
      bottomNavigationBar: null, 
    );
  }
}
