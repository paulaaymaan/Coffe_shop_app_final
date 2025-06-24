
import 'package:coffee_shop_app/src/features/drink/presentation/favorite_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart'; 

class FavoriteScreen extends ConsumerWidget {
  const FavoriteScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final favoriteDrinks = ref.watch(favoriteDrinksProvider);
    final currencyFormat = NumberFormat.currency(locale: 'en_US', symbol: '\$');

    print('FavoriteScreen built. Favorite list size: ${favoriteDrinks.length}');

    return Scaffold(
      appBar: AppBar(
        title: const Text('Favorite Drinks'),
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: Colors.black87,
      ),
      body:
          favoriteDrinks.isEmpty
              ? Center(
                child: Text(
                  'No favorite drinks yet!',
                  style: TextStyle(fontSize: 18, color: Colors.grey[600]),
                ),
              )
              : ListView.builder(
                itemCount:
                    favoriteDrinks
                        .length, 
                itemBuilder: (context, index) {
                  final drink =
                      favoriteDrinks[index]; 
                  return Dismissible(
                    key: ValueKey(
                      drink.id,
                    ), 
                    direction:
                        DismissDirection.endToStart, 
                    background: Container(
                      color: Colors.red,
                      alignment: Alignment.centerRight,
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: const Icon(Icons.delete, color: Colors.white),
                    ),
                    onDismissed: (direction) {
                      ref
                          .read(favoriteDrinksProvider.notifier)
                          .toggleFavorite(drink);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            '${drink.title} removed from favorites',
                          ),
                        ),
                      );
                    },
                    child: Card(
                      margin: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      elevation: 2,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.network(
                                drink.imageUrl,
                                width: 80, 
                                height: 80,
                                fit: BoxFit.cover,
                                errorBuilder:
                                    (context, error, stackTrace) => Container(
                                      width: 80,
                                      height: 80,
                                      color: Colors.grey[300],
                                      child: const Icon(
                                        Icons.broken_image,
                                        color: Colors.grey,
                                      ),
                                    ),
                              ),
                            ),
                            const SizedBox(
                              width: 16,
                            ), 
                            Expanded(
                              child: Column(
                                crossAxisAlignment:
                                    CrossAxisAlignment
                                        .start, 
                                children: [
                                  Text(
                                    drink.title,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                    ),
                                    maxLines: 1,
                                    overflow:
                                        TextOverflow
                                            .ellipsis, 
                                  ),
                                  const SizedBox(
                                    height: 4,
                                  ), 
                                  Text(
                                    currencyFormat.format(
                                      drink.price ?? 0.0,
                                    ), 
                                    style: const TextStyle(
                                      fontSize: 16,
                                      color: Color(
                                        0xFFC67C4E,
                                      ), 
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            IconButton(
                              icon: const Icon(
                                Icons.favorite,
                                color: Colors.redAccent,
                              ),
                              onPressed: () {
                                ref
                                    .read(favoriteDrinksProvider.notifier)
                                    .toggleFavorite(drink);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      '${drink.title} removed from favorites',
                                    ),
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
    );
  }
}
