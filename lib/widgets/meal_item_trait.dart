import 'package:flutter/material.dart';
class MealItemTrait extends StatelessWidget {
  const MealItemTrait({super.key, required this.icon, required this.title});
  final IconData icon;
  final String title;
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon,color: Colors.white),
        const SizedBox(width: 6),
        Text(
          title.toString(),
          style:const TextStyle(
              color: Colors.white,
          )
        )
      ],
    );
  }
}

