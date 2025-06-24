
import 'dart:async'; 
import 'dart:math'; 

import 'package:coffee_shop_app/src/features/location/data/services/location_service.dart';
import 'package:coffee_shop_app/src/features/location/presentation/widgets/permission_dialog.dart';
import 'package:flutter/material.dart'; 
import 'package:flutter/services.dart'; 
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart'; 
import 'package:flutter/foundation.dart'; 

import 'package:coffee_shop_app/src/features/cart/presentation/cart_notifier.dart'; 
import 'package:coffee_shop_app/src/features/drink/domain/entities/drink.dart'; 
import 'package:coffee_shop_app/src/features/drink/presentation/drink_list_notifier.dart'; 
import 'package:coffee_shop_app/src/features/location/presentation/location_notifier.dart'; 
import 'package:coffee_shop_app/src/features/drink/presentation/favorite_notifier.dart'; 

import 'package:coffee_shop_app/src/features/cart/presentation/screens/cart_screen.dart'; 
import 'package:coffee_shop_app/src/features/drink/presentation/screens/detail_screen.dart'; 
import 'package:coffee_shop_app/src/features/drink/presentation/screens/favorite_screen.dart'; 

import 'package:coffee_shop_app/src/presentation/common_widgets/filter_options_modal.dart'; 
import 'package:coffee_shop_app/src/presentation/common_widgets/badge_icon.dart'; 


class LocationWidget extends ConsumerWidget {
  const LocationWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locationAsyncValue = ref.watch(editableDeliveryAddressProvider);

    return locationAsyncValue.when(
      data: (deliveryLocation) {
        if (deliveryLocation != null) {
          return Text(
            deliveryLocation.address,
            style: const TextStyle(fontSize: 14, color: Colors.white),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          );
        }
        return const Text(
          'Location unavailable',
          style: TextStyle(fontSize: 14, color: Colors.white),
        );
      },
      loading:
          () => const Text(
            'Fetching location...',
            style: TextStyle(fontSize: 14, color: Colors.white70),
          ),
      error:
          (error, st) => Text(
            (ref.read(editableDeliveryAddressProvider).error?.toString() ??
                    'Location Error')
                .split(':')
                .first,
            style: const TextStyle(fontSize: 14, color: Colors.redAccent),
          ),
    );
  }
}

class SearchBarWidget extends ConsumerWidget {
  const SearchBarWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      height: 52,
      decoration: BoxDecoration(
        color: const Color(0xFF3E3E3E),
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Center(
        child: TextField(
          style: const TextStyle(color: Colors.white),
          textAlignVertical: TextAlignVertical.center,
          decoration: InputDecoration(
            hintText: 'Search coffee',
            hintStyle: TextStyle(color: Colors.white.withOpacity(0.6)),
            prefixIcon: Icon(
              Icons.search,
              color: Colors.white.withOpacity(0.6),
            ),
            border: InputBorder.none,
            contentPadding: EdgeInsets.zero,
            isDense: true,
          ),
          onChanged: (query) {
            ref.read(drinkListProvider.notifier).setSearchQuery(query);
          },
        ),
      ),
    );
  }
}

class FilterButton extends ConsumerWidget {
  final String text;
  final DrinkFilter filter;

  const FilterButton({super.key, required this.text, required this.filter});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watch the selected filter state
    final selectedFilter = ref.watch(selectedDrinkFilterProvider);
    final isSelected = selectedFilter == filter;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4.0),
      child: ChoiceChip(
        label: Text(text),
        selected: isSelected,
        selectedColor: const Color(0xFFC67C4E),
        backgroundColor: Colors.grey[200],
        labelStyle: TextStyle(
          color: isSelected ? Colors.white : Colors.black87,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
        onSelected: (selected) {
          if (selected) {
            ref.read(selectedDrinkFilterProvider.notifier).setFilter(filter);
          }
        },
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: BorderSide.none,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      ),
    );
  }
}

class ShuffleBanner extends ConsumerStatefulWidget {
  const ShuffleBanner({super.key});

  @override
  ConsumerState<ShuffleBanner> createState() => _ShuffleBannerState();
}

class _ShuffleBannerState extends ConsumerState<ShuffleBanner> {
  Timer? _timer;
  int _currentIndex = 0;
  List<Drink> _shuffledDrinks = [];

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      final drinksState = ref.read(drinkListProvider);
      drinksState.whenData((drinks) {
        if (drinks.isNotEmpty) {
          _shuffledDrinks = drinks;
          _currentIndex = Random().nextInt(_shuffledDrinks.length);
          print(
            'ShuffleBanner: Initialized shuffled list with ${drinks.length} items. Starting at index $_currentIndex.',
          );
          _startPeriodicShuffleTimer();
        }
      });
    });
  }

  void _startPeriodicShuffleTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 5), (timer) {
      final drinksState = ref.read(drinkListProvider);
      drinksState.whenData((drinks) {
        if (drinks.isNotEmpty && mounted) {
          setState(() {
            _shuffledDrinks = drinks;
            _currentIndex = Random().nextInt(_shuffledDrinks.length);
            print(
              'ShuffleBanner: Shuffling to item ${_currentIndex + 1}/${_shuffledDrinks.length}.',
            );
          });
        } else if (drinks.isEmpty) {
          print('ShuffleBanner: Drink list is empty, stopping timer.');
          _timer?.cancel();
          _timer = null;
        }
      });
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    print('ShuffleBanner: Timer disposed.');
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final drinksState = ref.watch(drinkListProvider);

    return drinksState.when(
      data: (drinks) {
        if (drinks.isNotEmpty &&
            (_shuffledDrinks.isEmpty || !listEquals(_shuffledDrinks, drinks))) {
          print(
            'ShuffleBanner: Drink list updated (filtering/search). Reinitializing shuffle.',
          );
          _shuffledDrinks = drinks;
          _currentIndex = Random().nextInt(_shuffledDrinks.length);
          if (_timer == null || !_timer!.isActive) {
            _startPeriodicShuffleTimer();
            print('ShuffleBanner: Drink list now has data, restarting timer.');
          }
        } else if (drinks.isEmpty && _shuffledDrinks.isNotEmpty) {
          print(
            'ShuffleBanner: Drink list became empty (no results), clearing shuffle.',
          );
          _shuffledDrinks = [];
          _timer?.cancel();
          _timer = null;
        }

        if (_shuffledDrinks.isEmpty) {
          return Container(
            height: 160,
            margin: EdgeInsets.zero,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(16),
            ),
            child: Center(
              child: Text(
                ref.read(drinkListProvider.notifier).searchQuery.isNotEmpty
                    ? 'No offers found for "${ref.read(drinkListProvider.notifier).searchQuery}"'
                    : 'No offers available',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey[600]),
              ),
            ),
          );
        }

        final currentDrink = _shuffledDrinks[_currentIndex];

        return Container(
          height: 160,
          margin: EdgeInsets.zero,
          decoration: BoxDecoration(
            color: Colors.brown[100],
            borderRadius: BorderRadius.circular(16),
            image: DecorationImage(
              image: NetworkImage(currentDrink.imageUrl),
              fit: BoxFit.cover,
              colorFilter: ColorFilter.mode(
                Colors.black.withOpacity(0.3),
                BlendMode.darken,
              ),
            ),
          ),
          child: Stack(
            children: [
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  color: Colors.transparent,
                  gradient: const LinearGradient(
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    colors: [
                      Colors.black87,
                      Colors.black54,
                      Colors.transparent,
                    ],
                    stops: [0.0, 0.3, 0.7],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.redAccent,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: const Text(
                        'Promo',
                        style: TextStyle(color: Colors.white, fontSize: 12),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      currentDrink.title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      currentDrink.description.split('.').first +
                          (currentDrink.description.contains('.') ? '.' : ''),
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
      loading:
          () => Container(
            height: 160,
            margin: const EdgeInsets.symmetric(vertical: 16.0),
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Center(child: CircularProgressIndicator()),
          ),
      error:
          (error, stackTrace) => Container(
            height: 160,
            margin: const EdgeInsets.symmetric(vertical: 16.0),
            decoration: BoxDecoration(
              color: Colors.red[100],
              borderRadius: BorderRadius.circular(16),
            ),
            child: Center(
              child: Text(
                'Error loading offers: ${error.toString().split(':').first}',
              ),
            ),
          ),
    );
  }

  bool listEquals<T>(List<T>? a, List<T>? b) {
    if (a == null) return b == null;
    if (b == null || a.length != b.length) return false;
    if (identical(a, b)) return true;
    for (int index = 0; index < a.length; index++) {
      if (a[index] != b[index]) return false;
    }
    return true;
  }
}

class DrinkItemWidget extends ConsumerWidget {
  final Drink drink;

  const DrinkItemWidget({super.key, required this.drink});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currencyFormat = NumberFormat.currency(locale: 'en_US', symbol: '\$');

    final isFavorite = ref.watch(
      favoriteDrinksProvider.select(
        (favorites) => favorites.any((item) => item.id == drink.id),
      ),
    );

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => DetailScreen(drink: drink)),
        );
      },
      child: Container(
        margin: const EdgeInsets.all(8.0), // Add margin here
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              spreadRadius: 2,
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(12),
                  ),
                  child: Image.network(
                    drink.imageUrl,
                    height: 100,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder:
                        (context, error, stackTrace) => Container(
                          height: 120,
                          color: Colors.grey[300],
                          child: const Center(
                            child: Icon(
                              Icons.broken_image,
                              size: 50,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                  ),
                ),
                Positioned(
                  top: 8,
                  right: 8,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(20),
                    onTap: () {
                      ref
                          .read(favoriteDrinksProvider.notifier)
                          .toggleFavorite(drink);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            isFavorite
                                ? '${drink.title} removed from favorites'
                                : '${drink.title} added to favorites',
                          ),
                          duration: const Duration(seconds: 1),
                        ),
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.3),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        isFavorite ? Icons.favorite : Icons.favorite_border,
                        color: isFavorite ? Colors.redAccent : Colors.white,
                        size: 20,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    drink.title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Colors.black87,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        currencyFormat.format(drink.price ?? 0.0),
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: Color(0xFFC67C4E),
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          ref.read(cartItemsProvider.notifier).addItem(drink);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('${drink.title} added to cart!'),
                              duration: const Duration(seconds: 1),
                            ),
                          );
                        },
                        borderRadius: BorderRadius.circular(8),
                        child: Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: const Color(0xFFC67C4E),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(
                            Icons.add,
                            color: Colors.white,
                            size: 20,
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
      ),
    );
  }
}

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  int _selectedIndex = 0;
  bool _locationEnabled = false;

  final double _darkHeaderHeight = 200.0;
  final double _bannerHeight = 160.0;
  final double _bannerOverlap =
      60.0; 
  final double _bannerTopPosition = 200.0 - 80.0; 

  @override
  void initState() {
    super.initState();
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.light,
      ),
    );
    _checkLocationPermission();
  }

  Future<void> _checkLocationPermission() async {
    final hasPermission = await LocationService.checkAndRequestPermission();

    if (!hasPermission && mounted) {
      final result = await showLocationPermissionDialog(context);
      if (result) {
        await _checkLocationPermission();
        return;
      }
    }

    if (mounted) {
      setState(() {
        _locationEnabled = hasPermission;
      });
    }
  }

  @override
  void dispose() {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.white,
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.dark,
      ),
    );
    super.dispose();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    switch (index) {
      case 0:
        break;
      case 1:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const FavoriteScreen()),
        );
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) setState(() => _selectedIndex = 0);
        });
        break;
      case 2:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const CartScreen()),
        );
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) setState(() => _selectedIndex = 0);
        });
        break;
      case 3:
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Notifications Page Placeholder')),
        );
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) setState(() => _selectedIndex = 0);
        });
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final totalItemCount = ref.watch(cartTotalItemCountProvider);

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        toolbarHeight: 0,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Column(
            children: [
              Container(
                height: _darkHeaderHeight,
                color: const Color(0xFF2F2D2C),
                padding: EdgeInsets.only(
                  top: MediaQuery.of(context).padding.top,
                  left: 16.0,
                  right: 16.0,
                  bottom: 24.0, 
                ),
                child: Column(
                  mainAxisAlignment:
                      MainAxisAlignment.start, 
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Location',
                          style: TextStyle(fontSize: 12, color: Colors.white54),
                        ),
                        LocationWidget(),
                      ],
                    ),
                    const SizedBox(height: 16), 
                    Row(
                      children: [
                        const Expanded(child: SearchBarWidget()),
                        const SizedBox(width: 8),
                        InkWell(
                          borderRadius: BorderRadius.circular(10),
                          onTap: () {
                            showModalBottomSheet(
                              context: context,
                              builder: (context) => const FilterOptionsModal(),
                              backgroundColor: Colors.white,
                              shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.vertical(
                                  top: Radius.circular(16.0),
                                ),
                              ),
                            );
                          },
                          child: Container(
                            width: 52,
                            height: 52,
                            decoration: BoxDecoration(
                              color: const Color(0xFFC67C4E),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Center(
                              child: Icon(
                                Icons.filter_list,
                                color: Colors.white,
                                size: 24,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Expanded(
                child: CustomScrollView(
                  controller: ScrollController(),
                  slivers: [
                    SliverToBoxAdapter(
                      child: SizedBox(
                        height: _bannerHeight / 2 + 20,
                      ), 
                    ),
                    SliverToBoxAdapter(
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            FilterButton(
                              text: 'All Coffee',
                              filter: DrinkFilter.all,
                            ),
                            FilterButton(
                              text: 'Hot Drinks',
                              filter: DrinkFilter.hot,
                            ),
                            FilterButton(
                              text: 'Cold Drinks',
                              filter: DrinkFilter.cold,
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SliverPadding(
                      padding: EdgeInsets.symmetric(vertical: 8.0),
                    ),
                    Consumer(
                      builder: (context, ref, child) {
                        final drinkListState = ref.watch(drinkListProvider);
                        return drinkListState.when(
                          data: (drinks) {
                            if (drinks.isEmpty) {
                              bool isSearchEmpty =
                                  ref
                                      .read(drinkListProvider.notifier)
                                      .searchQuery
                                      .isNotEmpty;
                              bool hasLoadError =
                                  ref.read(drinkListProvider).hasError;
                              return SliverToBoxAdapter(
                                child: Center(
                                  child: Padding(
                                    padding: const EdgeInsets.only(top: 32.0),
                                    child: Text(
                                      hasLoadError
                                          ? 'Failed to load drinks.'
                                          : isSearchEmpty
                                          ? 'No drinks found for "${ref.read(drinkListProvider.notifier).searchQuery}"'
                                          : 'No drinks match the selected filter.',
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.grey[600],
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ),
                              );
                            }
                            return SliverGrid(
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2,
                                    crossAxisSpacing: 12,
                                    mainAxisSpacing: 12,
                                    childAspectRatio: 0.85,
                                  ),
                              delegate: SliverChildBuilderDelegate((
                                context,
                                index,
                              ) {
                                final drink = drinks[index];
                                return DrinkItemWidget(drink: drink);
                              }, childCount: drinks.length),
                            );
                          },
                          loading:
                              () => const SliverFillRemaining(
                                hasScrollBody: false,
                                child: Center(
                                  child: CircularProgressIndicator(),
                                ),
                              ),
                          error:
                              (error, stackTrace) => SliverFillRemaining(
                                hasScrollBody: false,
                                child: Center(
                                  child: Text(
                                    'Error loading offers: ${error.toString().split(':').first}',
                                  ),
                                ),
                              ),
                        );
                      },
                    ),
                    const SliverPadding(padding: EdgeInsets.only(bottom: 24.0)),
                  ],
                ),
              ),
            ],
          ),
          Positioned(
            top: _darkHeaderHeight - 60, 
            left: 16.0,
            right: 16.0,
            height: _bannerHeight,
            child: const ShuffleBanner(),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          const BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          const BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'Favorites',
          ),
          BottomNavigationBarItem(
            icon: BadgeIcon(icon: Icons.shopping_bag, count: totalItemCount),
            label: 'Cart',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.notifications),
            label: 'Notifications',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: const Color(0xFFC67C4E),
        unselectedItemColor: Colors.grey,
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
      ),
    );
  }
}
