import 'package:flutter/material.dart';
class MainDrawer extends StatelessWidget {
  const MainDrawer({super.key, required this.onSelectedScreen});
  final void Function(String identefier) onSelectedScreen;
  @override
  Widget build(BuildContext context) {
    return  Drawer(
      child: Column(
        children: [
          DrawerHeader(
            padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                gradient: LinearGradient(
                    colors: [
                      Theme.of(context).colorScheme.primaryContainer,
                      Theme.of(context).colorScheme.primaryContainer.withOpacity(0.8)
                    ],
                  begin: Alignment.topLeft,
                  end:Alignment.topRight
                ),
              ),
              child:Row(
                children: [
                  Icon(Icons.fastfood,size: 48,color: Theme.of(context).colorScheme.primary,),
                 const SizedBox(width: 18,),
                  Text('Cooking Up',style: Theme.of(context).textTheme.titleLarge!.copyWith(
                    color: Theme.of(context).colorScheme.primary
                  ),)
                ],
              )
          ),
          ListTile(
            leading: Icon(
                Icons.restaurant,
                color: Theme.of(context).colorScheme.onSurface,
                size:28
            ),
            title: Text('Meals',
              style: Theme.of(context).textTheme.titleSmall!.copyWith(
                  color: Theme.of(context).colorScheme.onSurface,fontSize:24
              ),
            ),
            onTap: (){
              onSelectedScreen('Meals');
              },
          ),
          ListTile(
            leading: Icon(
                Icons.settings,
                color: Theme.of(context).colorScheme.onSurface,
                size:28
            ),
            title: Text('Filters',
              style: Theme.of(context).textTheme.titleSmall!.copyWith(
                  color: Theme.of(context).colorScheme.onSurface,fontSize:24
              ),
            ),
            onTap: (){
              onSelectedScreen('Filters');
              },
          )
        ],
      ),
    );
  }
}
