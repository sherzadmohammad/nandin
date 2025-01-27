import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/meal_data.dart';

class FavoriteNotifier extends StateNotifier<List<Meal>>{
  FavoriteNotifier():super([]);

bool toggleMealFavoriteState(Meal meal){
  final isFavorite=state.contains(meal);
  if(isFavorite){//if meal is found:lets remove it.
    state=state.where((m) => meal.id!=m.id).toList();
    return false;
  }else{//if meal not found:lets add it.
    state=[...state,meal];
    return true;
  }
}
}

final favoriteMealsProvider=
StateNotifierProvider<FavoriteNotifier,List<Meal>>((ref){

          return FavoriteNotifier();
}
);