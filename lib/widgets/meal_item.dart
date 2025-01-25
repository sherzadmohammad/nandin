import 'package:flutter/material.dart';
import 'package:nanden/data/meal_data.dart';
import 'package:nanden/widgets/meal_item_trait.dart';
import 'package:transparent_image/transparent_image.dart';
class MealItem extends StatelessWidget{
   const MealItem({super.key,required this.meal, required this.onSelect});
   final Meal meal;
   final void Function(Meal meal) onSelect;
   String get complexityText{
     return meal.complexity.name[0].toUpperCase()+meal.complexity.name.substring(1);
   }
   String get affordabilityText{
     return meal.affordability.name[0].toUpperCase()+meal.affordability.name.substring(1);
   }
  @override
  Widget build(BuildContext context) {
    return Card(
      margin:const EdgeInsets.all(6),
      clipBehavior:Clip.hardEdge,
      elevation:2,
      shape:RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child:InkWell(
        onTap:(){onSelect(meal);},
        child:Stack(
          children:[
            FadeInImage(placeholder: MemoryImage(kTransparentImage),
                image: NetworkImage(meal.imageUrl),
                fit:BoxFit.cover,
                height:200,
              width: double.infinity,
            ),
            Positioned(
                right: 0,
                left: 0,
                bottom: 0,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 6),
                  color:Colors.black54,
                  child: Column(
                    children:[
                      Text(
                          meal.title,
                          maxLines:2,
                          textAlign: TextAlign.center,
                          softWrap: true,
                          overflow: TextOverflow.ellipsis,
                          style:const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color:Colors.white
                          )
                      ),
                      const SizedBox(height:12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                         children:[
                           MealItemTrait(icon: Icons.schedule, title: '${meal.duration} min'),
                           const SizedBox(width:9),
                           MealItemTrait(icon: Icons.work, title: complexityText),
                           const SizedBox(width:9),
                           MealItemTrait(icon: Icons.attach_money, title: affordabilityText),
                         ]
                     ),
                    ]
                  ),
            )
            )
          ]
        )
      )
    );
  }
}