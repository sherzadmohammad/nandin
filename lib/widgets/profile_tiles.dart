import 'package:flutter/material.dart';


class CustomProfileTiles extends StatelessWidget {
  const CustomProfileTiles({super.key, required this.icon, required this.title, this.isToggle, required this.onTap,});
  final IconData icon;
  final String title;
  final bool? isToggle;
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) {
    Icon trailing= const Icon(Icons.arrow_forward_ios_outlined,size: 16.0,);
    if(isToggle==false){trailing=const Icon(Icons.toggle_off,size: 40.0,color: Color(0xFF9EA8B3));}
    else if(isToggle==true){trailing=const Icon(Icons.toggle_on,size: 40.0,color: Colors.lightBlue,);}
    return InkWell(
      onTap: onTap,
      child: SizedBox(
        height: 44.0,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon,size: 22,color: const Color(0xFF262526),),
            const SizedBox(width: 8.0,),
            Text(title,
            style: const TextStyle(fontSize: 14,fontWeight: FontWeight.w400,
                color: Color(0xFF1A1A1A)),
            ),
            const Spacer(),
            trailing
          ],
        )
      ),
    );
  }
}
