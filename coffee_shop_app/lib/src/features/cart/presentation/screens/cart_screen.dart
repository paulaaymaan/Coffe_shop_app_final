

import 'package:coffee_shop_app/src/core/di.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:coffee_shop_app/src/features/cart/presentation/cart_notifier.dart';
import 'package:coffee_shop_app/src/features/drink/domain/entities/drink.dart';
import 'package:coffee_shop_app/src/features/location/domain/entities/delivery_location.dart';
import 'package:coffee_shop_app/src/features/location/presentation/screens/edit_address_screen.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'cart_screen.g.dart';

const LatLng _defaultStoreLocation = LatLng(29.9679, 31.2695);

@riverpod
class EditableDeliveryAddress extends _$EditableDeliveryAddress {
  @override
  FutureOr<DeliveryLocation> build() async {
    print('EditableDeliveryAddress provider build() called.');
    final prefs = await SharedPreferences.getInstance();

    final savedLat = prefs.getDouble('saved_latitude');
    final savedLng = prefs.getDouble('saved_longitude');
    final savedAddress = prefs.getString('saved_address');

    if (savedLat != null && savedLng != null && savedAddress != null) {
      print('Loaded saved delivery address.');
      return DeliveryLocation(
        coordinates: LatLng(savedLat, savedLng),
        address: savedAddress,
      );
    }

    return await _getCurrentLocation();
  }

  Future<DeliveryLocation> _getCurrentLocation() async {
    String address = 'Getting current location...';
    LatLng coords = const LatLng(0.0, 0.0);

    try {
      final position =
          await ref.read(geolocatorPlatformProvider).getCurrentPosition();
      coords = LatLng(position.latitude, position.longitude);

      final placemarks = await placemarkFromCoordinates(
        coords.latitude,
        coords.longitude,
      );

      if (placemarks.isNotEmpty) {
        final place = placemarks.first;
        final parts =
            [
              place.street,
              place.subLocality,
              place.locality,
              place.administrativeArea,
              place.country,
            ].where((p) => p != null && p!.isNotEmpty).map((p) => p!).toList();
        address = parts.join(', ');
      } else {
        address = 'Lat: ${coords.latitude}, Lng: ${coords.longitude}';
      }
    } catch (e) {
      address = 'Location Error: ${e.toString().split(':').first}';
      print('Error resolving location: $e');
    }

    return DeliveryLocation(coordinates: coords, address: address);
  }

  void setAddress(DeliveryLocation newLocation) async {
    print('Setting new delivery address: ${newLocation.address}');

    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble('saved_latitude', newLocation.coordinates.latitude);
    await prefs.setDouble('saved_longitude', newLocation.coordinates.longitude);
    await prefs.setString('saved_address', newLocation.address);

    state = AsyncData(newLocation);
  }
}

class CartScreen extends ConsumerWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cartItems = ref.watch(cartItemsProvider);
    final totalAmount = ref.watch(cartTotalAmountProvider);
    final deliveryLocationAsyncValue = ref.watch(
      editableDeliveryAddressProvider,
    );
    final currencyFormat = NumberFormat.currency(locale: 'en_US', symbol: '\$');

    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Cart'),
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: Colors.black87,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Delivery Address',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[800],
                  ),
                ),
                const SizedBox(height: 8),
                deliveryLocationAsyncValue.when(
                  data:
                      (deliveryLocation) => Text(
                        deliveryLocation.address,
                        style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                  loading:
                      () => const Text(
                        'Loading address...',
                        style: TextStyle(fontSize: 14, color: Colors.grey),
                      ),
                  error:
                      (error, st) => Text(
                        '$error',
                        style: const TextStyle(fontSize: 14, color: Colors.red),
                      ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    OutlinedButton.icon(
                      onPressed: () async {
                        final current = deliveryLocationAsyncValue.valueOrNull;
                        final newLocation =
                            await Navigator.push<DeliveryLocation>(
                              context,
                              MaterialPageRoute(
                                builder:
                                    (context) => EditAddressScreen(
                                      initialLocation:
                                          deliveryLocationAsyncValue.hasValue
                                              ? current
                                              : null,
                                    ),
                              ),
                            );
                        if (newLocation != null) {
                          ref
                              .read(editableDeliveryAddressProvider.notifier)
                              .setAddress(newLocation);
                        }
                      },
                      icon: const Icon(
                        Icons.edit_location_alt_outlined,
                        size: 18,
                      ),
                      label: const Text('Edit Address'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: const Color(0xFFC67C4E),
                        side: BorderSide(
                          color: const Color(0xFFC67C4E).withOpacity(0.5),
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const Divider(height: 1, thickness: 1),
          Expanded(
            child: cartItems.when(
              data: (items) {
                if (items.isEmpty) {
                  return Center(
                    child: Text(
                      'Your cart is empty!',
                      style: TextStyle(fontSize: 18, color: Colors.grey[600]),
                    ),
                  );
                }

                return ListView.builder(
                  itemCount: items.length, 
                  itemBuilder:
                      (context, index) => CartItemWidget(
                        item: items[index],
                      ), 
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error:
                  (error, stackTrace) => Center(
                    child: Text(
                      'Error loading cart: ${error.toString()}',
                      style: const TextStyle(color: Colors.red),
                    ),
                  ),
            ),
          ),
          if (cartItems.hasValue &&
              cartItems.value!.isNotEmpty) 
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Order Summary',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[800],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Total Amount',
                        style: TextStyle(fontSize: 16, color: Colors.grey[700]),
                      ),
                      Text(
                        currencyFormat.format(totalAmount),
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFFC67C4E),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed:
                          !deliveryLocationAsyncValue.hasValue
                              ? null
                              : () {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Order made successfully!'),
                                    duration: Duration(seconds: 2),
                                  ),
                                );
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
                        'Order',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}

class CartItemWidget extends ConsumerWidget {
  final Drink item;

  const CartItemWidget({super.key, required this.item});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currencyFormat = NumberFormat.currency(locale: 'en_US', symbol: '\$');

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.network(
              item.imageUrl,
              width: 80,
              height: 80,
              fit: BoxFit.cover,
              errorBuilder:
                  (context, error, stackTrace) => Container(
                    width: 80,
                    height: 80,
                    color: Colors.grey[300],
                    child: const Center(
                      child: Icon(Icons.broken_image, color: Colors.grey),
                    ),
                  ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),
                Text(
                  currencyFormat.format(item.price * item.quantity),
                  style: const TextStyle(
                    fontSize: 16,
                    color: Color(0xFFC67C4E),
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    InkWell(
                      onTap:
                          () => ref
                              .read(cartItemsProvider.notifier)
                              .removeItem(item),
                      borderRadius: BorderRadius.circular(20),
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey.shade400),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Icon(
                          item.quantity > 1
                              ? Icons.remove
                              : Icons.delete_outline,
                          size: 20,
                          color: Colors.grey[700],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12.0),
                      child: Text(
                        '${item.quantity}',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    InkWell(
                      onTap:
                          () => ref
                              .read(cartItemsProvider.notifier)
                              .addItem(item),
                      borderRadius: BorderRadius.circular(20),
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey.shade400),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Icon(
                          Icons.add,
                          size: 20,
                          color: Colors.grey[700],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
