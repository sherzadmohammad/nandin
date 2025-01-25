import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nanden/data/meal_data.dart';
import 'package:nanden/providers/favorite_provider.dart';
import 'package:transparent_image/transparent_image.dart';
class MealDetailsScreen extends ConsumerStatefulWidget {
  const MealDetailsScreen({super.key,required this.meal});
  final Meal meal;
  @override
  ConsumerState<MealDetailsScreen> createState() => _MealDetailsScreenState();
}
class _MealDetailsScreenState extends ConsumerState<MealDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:AppBar(
        title:Text(widget.meal.title),
        actions: [
          IconButton(onPressed:(){
            setState(() {
              widget.meal.color==Colors.white? widget.meal.color=Colors.yellow:widget.meal.color=Colors.white;
            final wasAdded=ref.read(favoriteMealsProvider.notifier).toggleMealFavoriteState(widget.meal);
            ScaffoldMessenger.of(context).clearSnackBars();
            ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(wasAdded? 'Now is Favorite!':'No Longer Favorite!')
                )
            );
            });
            },
              icon: Icon(Icons.star,color:widget.meal.color,))
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            FadeInImage(
              placeholder: MemoryImage(kTransparentImage),
              image: NetworkImage(widget.meal.imageUrl),
              fit:BoxFit.cover,
              height:300,
              width: double.infinity,
            ),
            const SizedBox(height:14),
             Text('Ingredients',style: Theme.of(context).textTheme.titleLarge!.copyWith(
              color:Theme.of(context).colorScheme.primary,
               fontWeight: FontWeight.bold
            ),
            ),
            for(final ingredient in widget.meal.ingredients)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12,vertical: 8),
                child: Text(ingredient,style:
                Theme.of(context).textTheme.bodyLarge!.copyWith(
                  color:Theme.of(context).colorScheme.onSurface
                )
                ),
              ),
            const SizedBox(height:24),
            Text('steps',
            textAlign: TextAlign.center,
            style:Theme.of(context).textTheme.bodyMedium!.copyWith(
              color:Theme.of(context).colorScheme.primary,
                  fontWeight: FontWeight.bold
            ) ,),
          const SizedBox(height:14),
            for(final steps in widget.meal.steps)
              Padding(
                padding: const EdgeInsets.symmetric(vertical:16 ,horizontal: 12),
                child: Text(steps,
                    textAlign: TextAlign.center,
                    style:Theme.of(context).textTheme.bodyMedium!.copyWith(
                        color:Theme.of(context).colorScheme.onSurface
                    )  ,),
              )
          ],
        ),
      ),
    );
  }
}
