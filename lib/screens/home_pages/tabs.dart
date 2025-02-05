import 'package:flutter/material.dart';
import 'package:nanden/providers/user_provider.dart';
import 'package:nanden/screens/constants/loading_data.dart';
import '../../providers/favorite_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/filters_provider.dart';
import 'filters_screen.dart';
import 'main_body_screen.dart';
import 'meals_screen.dart';
import '../../widgets/main_drawer.dart';

class TabsScreen extends ConsumerStatefulWidget {
  const TabsScreen({super.key});
  @override
  ConsumerState<TabsScreen> createState() => _TabsScreenState();
}
class _TabsScreenState extends ConsumerState<TabsScreen> {
  int _selectedScreenIndex = 0;

  void _selectScreen(int index) {
    setState(() {
      _selectedScreenIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final filteredMeals = ref.watch(filteredMealsProvider);
    Widget activeScreen = MainBodyScreen(availableMeals: filteredMeals);
    String activeScreenTitle = 'Category';

    final favoriteMeal = ref.watch(favoriteMealsProvider);
    final userAsyncValue = ref.watch(userProvider);

    return userAsyncValue.when(
      data: (user) {
        if (_selectedScreenIndex == 1) {
          activeScreen = MealsScreen(
            title: "Favorite",
            meals: favoriteMeal,
          );
          activeScreenTitle = 'Favorite';
        } else {
          activeScreen = MainBodyScreen(availableMeals: filteredMeals);
          activeScreenTitle = 'Category';
        }

        return Scaffold(
          appBar: AppBar(
            title: Text(activeScreenTitle),
          ),
          body: activeScreen,
          bottomNavigationBar: BottomNavigationBar(
            onTap: _selectScreen,
            currentIndex: _selectedScreenIndex,
            items: const [
              BottomNavigationBarItem(icon: Icon(Icons.set_meal), label: 'Category'),
              BottomNavigationBarItem(icon: Icon(Icons.star), label: 'Favorite'),
            ],
          ),
        );
      },
      loading: () => const LoadingData(),
      error: (err, stack) => Center(
        child: Text(
          'Error: $err',
          style:Theme.of(context).textTheme.headlineLarge!.copyWith(color: Colors.black),
          )
        ),
    );
  }
}
