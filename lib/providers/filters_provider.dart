import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'meals_provider.dart';
import '../data/models.dart';
enum Filter{
  glutenFree,
  lactoseFree,
  vegan,
  vegetarian
}
final isKuModeProvider = StateProvider<bool>((ref) => isKuMode);

class FiltersNotifier extends StateNotifier<Map<Filter,bool>>{
  FiltersNotifier():super({
    Filter.glutenFree:false,
    Filter.lactoseFree:false,
    Filter.vegan:false,
    Filter.vegetarian:false
  });
  void setFilters(Map<Filter,bool> selectedFilters){
    state=selectedFilters;
  }
  void setFilter(Filter filter,bool isActive){
    state={
      ...state,
      filter:isActive
    };
  }
}
final filtersProvider= StateNotifierProvider<FiltersNotifier,Map<Filter,bool>>(
        (ref) => FiltersNotifier()
);

final filteredMealsProvider=Provider((ref) {
final meals=ref.watch(mealsProvider);
final activeFilters=ref.watch(filtersProvider);
return meals.where(
(meal){
if(activeFilters[Filter.glutenFree]!&&!meal.isGlutenFree){
return false;
}
if(activeFilters[Filter.lactoseFree]!&&!meal.isLactoseFree){
return false;
}
if(activeFilters[Filter.vegan]!&&!meal.isVegan){
return false;
}
if(activeFilters[Filter.vegetarian]!&&!meal.isVegetarian){
return false;
}
return true;
}
).toList();
}
);







