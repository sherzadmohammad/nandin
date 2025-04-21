import 'package:flutter/material.dart';
import 'package:nanden/models/models.dart';
import 'package:nanden/widgets/category_grid_item.dart';
import '../../models/content_data.dart';
import '../../models/meal_data.dart';
class MainBodyScreen extends StatefulWidget {
  const MainBodyScreen({super.key, required this.availableMeals});
  final List<Meal> availableMeals;
  @override
  State<MainBodyScreen> createState() => _MainBodyScreenState();
}
class _MainBodyScreenState extends State<MainBodyScreen> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  @override
  void initState() {
    super.initState();
    _animationController=AnimationController(
      vsync: this,
      duration:const Duration(milliseconds:400),
      lowerBound:0.0,
      upperBound:1.0,
    );
    _animationController.forward();
  }
void selectCategory(BuildContext context,Category category){
  
}
  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(animation:_animationController,
        child:GridView(
            padding: const EdgeInsets.all(8.0),
            gridDelegate:const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount:2,
                childAspectRatio:2/3,
                crossAxisSpacing: 20,
                mainAxisSpacing:20
            ),
            children:models.map((category) =>
                CategoryItem(category: category,
                    onSelected:(){selectCategory(context,category);}
                )
            ).toList()
        ),
        builder:(context,child)=>SlideTransition(
            position: _animationController.drive(
                Tween(
                    begin: const Offset(0.0, 0.3),
                    end: const Offset(0.0, 0.0)
                )
            ),
          child:child,
        )
    );
  }
}
