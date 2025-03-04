import 'package:flutter/material.dart';
import 'package:nanden/models/content_data.dart';
class CategoryItem extends StatelessWidget {
  const CategoryItem({super.key,required this.category, required this.onSelected});
  final Category category;
  final void Function() onSelected;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap:onSelected,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding:const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius:BorderRadius.circular(15),
          image:category.imageUrl !=null?
          DecorationImage(image: NetworkImage(category.imageUrl!),
          fit: BoxFit.cover
          ):null,
          gradient: LinearGradient(
            colors: [
              category.color.withAlpha((0.4 * 255).toInt()),
              category.color.withAlpha((0.9 * 255).toInt()),
            ],
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter
          )
        ),
        child: Text(category.title,style:Theme.of(context).textTheme.titleLarge!.copyWith(
            color: Colors.blueGrey,
          fontWeight: FontWeight.bold
        )
        ),

      ),
    );
  }
}
