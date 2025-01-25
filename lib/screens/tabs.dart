import 'package:flutter/material.dart';
import '../providers/favorite_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/filters_provider.dart';
import 'filters_screen.dart';
import 'main_body_screen.dart';
import 'meals_screen.dart';
import '../widgets/main_drawer.dart';

class TabsScreen extends ConsumerStatefulWidget {
  const TabsScreen({super.key});
  @override
  ConsumerState<TabsScreen> createState() => _TabsScreenState();
}
class _TabsScreenState extends ConsumerState<TabsScreen> {
  var _selectedScreenIndex=0;
  void _selectScreen(int index){
    setState(() {
      _selectedScreenIndex=index;
    });
  }
  void _setScreen(String identifier)async{
    Navigator.pop(context);
    if(identifier=='Filters'){
      Navigator.of(context).push<Map<Filter,bool>>(
          MaterialPageRoute(builder: (ctx)=> const FiltersScreen()
          )
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final filteredMeals =ref.watch(filteredMealsProvider);
    Widget activeScreen = MainBodyScreen( availableMeals: filteredMeals,);
    String activeScreenTitle='Category';
    final favoriteMeal=ref.watch(favoriteMealsProvider);
    if(_selectedScreenIndex==1){
      activeScreen=MealsScreen(
        title: activeScreenTitle,
        meals: favoriteMeal,
      );
      activeScreenTitle='Favorite';
    }
    return Scaffold(
      appBar: AppBar(
        title: Text(activeScreenTitle),

      ),
      drawer: MainDrawer(onSelectedScreen: _setScreen),
      body: activeScreen,
      bottomNavigationBar: BottomNavigationBar(
        onTap: _selectScreen,
        currentIndex: _selectedScreenIndex,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.set_meal),label:'Category'),
          BottomNavigationBarItem(icon: Icon(Icons.star),label:'Favorite'),
        ],
      ),
    );
  }
}