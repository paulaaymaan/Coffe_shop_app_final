
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:coffee_shop_app/src/features/drink/presentation/drink_list_notifier.dart';

class FilterOptionsModal extends ConsumerWidget {
  const FilterOptionsModal({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedFilter = ref.watch(selectedDrinkFilterProvider);

    return Container(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Filter Drinks By:',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          ListTile(
            title: const Text('Hot Drinks'),
            leading: selectedFilter == DrinkFilter.hot ? const Icon(Icons.check) : null,
            onTap: () {
              ref.read(selectedDrinkFilterProvider.notifier).setFilter(DrinkFilter.hot);
              Navigator.pop(context);
            },
          ),
          const Divider(),
          ListTile(
            title: const Text('Cold Drinks'),
            leading: selectedFilter == DrinkFilter.cold ? const Icon(Icons.check) : null,
            onTap: () {
              ref.read(selectedDrinkFilterProvider.notifier).setFilter(DrinkFilter.cold);
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}