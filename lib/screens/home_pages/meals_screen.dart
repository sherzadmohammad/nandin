import 'package:flutter/material.dart';
import 'package:nanden/widgets/meal_item.dart';
import '../../models/meal_data.dart';
import 'meal_details_screen.dart';
class MealsScreen extends StatelessWidget {
  const MealsScreen({super.key, this.title, required this.meals});
    final String? title;
    final List<Meal> meals;
    void gotoDetailScreen(BuildContext context,Meal meal){
      Navigator.of(context).push(
          MaterialPageRoute(
              builder: (ctx)=>
                  MealDetailsScreen(
                      meal: meal,
                  )
          )
      );
    }
  @override
  Widget build(BuildContext context) {
    Widget content= Center(child: Text('no category found',
      style:Theme.of(context).textTheme.bodyLarge!
          .copyWith(color:Theme.of(context).colorScheme.onSurface),
    )
    );
    if(meals.isNotEmpty){
     content= ListView.builder(
          itemCount: meals.length,
          itemBuilder: ( ctx , index )=>
              MealItem(meal: meals[index],
                  onSelect: (meal){
                    gotoDetailScreen(context, meal) ;
                  }
              )
      );
    }
    if(title==null){
      return content;
    }
    return Scaffold(
      appBar:AppBar(
        title:Text(title!)
      ),
      body:content
    );
  }
}
