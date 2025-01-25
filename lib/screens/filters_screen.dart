import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nanden/providers/filters_provider.dart';
class FiltersScreen extends ConsumerWidget {
  const FiltersScreen({super.key});
  @override
  Widget build(BuildContext context,WidgetRef ref) {
    final activeFilters=ref.watch(filtersProvider);
    return Scaffold(
      appBar:AppBar(
        title: const Text('Your Filters'),
        centerTitle: true,
      ),
      body:Column(
        children: [
          SwitchListTile(
            value:activeFilters[Filter.glutenFree]!,
            onChanged: (isCheck){
              ref.read(filtersProvider.notifier).setFilter(Filter.glutenFree, isCheck);
            },
            title: Text('Gluten-free',
              style: Theme.of(context).textTheme.titleLarge!.copyWith(
                  color: Theme.of(context).colorScheme.onSurface
              ),
            ),
            subtitle:Text('Only include Gluten-free Meals',
              style: Theme.of(context).textTheme.titleMedium!.copyWith(
                  color: Theme.of(context).colorScheme.onSurface
              ),
            ),
            activeColor: Colors.lightBlue,
          ),
          SwitchListTile(
            value:activeFilters[Filter.lactoseFree]!,
            onChanged: (isCheck){
              ref.read(filtersProvider.notifier).setFilter(Filter.lactoseFree, isCheck);
            },
            title: Text('Lactose-free',
              style: Theme.of(context).textTheme.titleLarge!.copyWith(
                  color: Theme.of(context).colorScheme.onSurface
              ),
            ),
            subtitle:Text('Only include Lactose-free Meals',
              style: Theme.of(context).textTheme.titleMedium!.copyWith(
                  color: Theme.of(context).colorScheme.onSurface
              ),
            ),
            activeColor: Colors.lightBlue,
          ),SwitchListTile(
            value:activeFilters[Filter.vegan]!,
            onChanged: (isCheck){
              ref.read(filtersProvider.notifier).setFilter(Filter.vegan, isCheck);
            },
            title: Text('Vegan',
              style: Theme.of(context).textTheme.titleLarge!.copyWith(
                  color: Theme.of(context).colorScheme.onSurface
              ),
            ),
            subtitle:Text('Only include Vegan Meals',
              style: Theme.of(context).textTheme.titleMedium!.copyWith(
                  color: Theme.of(context).colorScheme.onSurface
              ),
            ),
            activeColor: Colors.lightBlue,
          ),SwitchListTile(
            value:activeFilters[Filter.vegetarian]!,
            onChanged: (isCheck){
              ref.read(filtersProvider.notifier).setFilter(Filter.vegetarian, isCheck);
            },
            title: Text('Vegetarian',
              style: Theme.of(context).textTheme.titleLarge!.copyWith(
                  color: Theme.of(context).colorScheme.onSurface
              ),
            ),
            subtitle:Text('Only include Vegetarian Meals',
              style: Theme.of(context).textTheme.titleMedium!.copyWith(
                  color: Theme.of(context).colorScheme.onSurface
              ),
            ),
            activeColor: Colors.lightBlue,
          )
        ],
      )
    );
  }
}
