
import 'package:coffee_shop_app/src/features/cart/presentation/cart_notifier.dart'; 
import 'package:coffee_shop_app/src/features/drink/domain/entities/drink.dart';
import 'package:coffee_shop_app/src/features/drink/presentation/favorite_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart'; 
import 'package:coffee_shop_app/src/features/cart/presentation/screens/cart_screen.dart'; 

class DetailScreen extends ConsumerWidget {
  final Drink drink;

  const DetailScreen({super.key, required this.drink});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currencyFormat = NumberFormat.currency(locale: 'en_US', symbol: '\$');

    final favoriteDrinks = ref.watch(favoriteDrinksProvider);
    final isFavorite = favoriteDrinks.any((item) => item.id == drink.id);

    final imageHeight = MediaQuery.of(context).size.height * 0.4;

    return Scaffold(
      extendBodyBehindAppBar: false, 

      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: Colors.black87,
        title: const Text('Detail'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black87),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          IconButton(
            icon: Icon(
              isFavorite ? Icons.favorite : Icons.favorite_border,
              color: isFavorite ? Colors.redAccent : Colors.grey,
              size: 30,
            ),
            onPressed: () {
              ref.read(favoriteDrinksProvider.notifier).toggleFavorite(drink);
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
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Column(
        crossAxisAlignment:
            CrossAxisAlignment.stretch, 
        children: [
          Container(
            height: imageHeight,
            child: Stack(
              children: [
                Positioned.fill(
                  child: Image.network(
                    drink.imageUrl,
                    fit: BoxFit.cover,
                    errorBuilder:
                        (context, error, stackTrace) => Container(
                          color: Colors.grey[300],
                          child: const Center(
                            child: Icon(
                              Icons.broken_image,
                              size: 50,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return Container(
                        color: Colors.grey[200],
                        child: Center(
                          child: CircularProgressIndicator(
                            value:
                                loadingProgress.expectedTotalBytes != null
                                    ? loadingProgress.cumulativeBytesLoaded /
                                        loadingProgress.expectedTotalBytes!
                                    : null,
                          ),
                        ),
                      );
                    },
                  ),
                ),
                Positioned.fill(
                  child: Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [Colors.transparent, Colors.black87],
                        stops: [0.7, 1.0],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(
                16.0,
              ), 
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start, 
                children: [
                  Text(
                    drink.title,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(
                    height: 8,
                  ), 
                  Text(
                    'Ingredients:',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[800],
                    ),
                  ),
                  const SizedBox(height: 8),
                  if (drink.ingredients is List)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children:
                          (drink.ingredients as List)
                              .map(
                                (ingredient) => Padding(
                                  padding: const EdgeInsets.only(bottom: 4.0),
                                  child: Text(
                                    '• ${ingredient.toString()}',
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.grey[700],
                                    ),
                                  ),
                                ),
                              )
                              .toList(),
                    )
                  else if (drink.ingredients is String &&
                      (drink.ingredients as String).isNotEmpty)
                    Text(
                      drink.ingredients.toString(),
                      style: TextStyle(fontSize: 16, color: Colors.grey[700]),
                    )
                  else
                    Text(
                      'No ingredients listed.',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey[700],
                        fontStyle: FontStyle.italic,
                      ),
                    ),


               
                  const SizedBox(
                    height: 24,
                  ), 
                ],
              ),
            ),
          ),

          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 35.0,
            ), 
            decoration: BoxDecoration(
              color: Colors.white, 
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  spreadRadius: 1,
                  blurRadius: 5,
                  offset: const Offset(0, -3), 
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment:
                  MainAxisAlignment.spaceBetween, 
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Price',
                      style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                    ), 
                    Text(
                      currencyFormat.format(
                        drink.price ?? 0.0,
                      ), 
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFFC67C4E),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  width: 150, 
                  child: ElevatedButton(
                    onPressed: () {
                      ref.read(cartItemsProvider.notifier).addItem(drink);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const CartScreen(),
                        ),
                      );
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('${drink.title} added to cart!'),
                          duration: const Duration(seconds: 1),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      backgroundColor: const Color(
                        0xFFC67C4E,
                      ), 
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'Buy Now', 
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
   
    );
  }
}
