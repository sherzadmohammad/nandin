import 'package:flutter/material.dart';

 TextTheme myTextThem=const TextTheme(
   displayLarge:  TextStyle(fontSize:28, fontWeight: FontWeight.w700 ,color: Colors.black87),
   displayMedium: TextStyle(fontSize:26, fontWeight: FontWeight.w600 ,color: Colors.black87),
   displaySmall:  TextStyle(fontSize:24, fontWeight: FontWeight.bold ,color: Colors.black87),

   headlineLarge: TextStyle(fontSize:20, fontWeight: FontWeight.w600 ,color: Colors.black87),
   headlineMedium:TextStyle(fontSize:18, fontWeight: FontWeight.w600 ,color: Colors.black87),
   headlineSmall: TextStyle(fontSize:16, fontWeight: FontWeight.w500 ,color: Colors.black87),

   titleLarge:    TextStyle(fontSize:14, fontWeight: FontWeight.w600 ,color: Colors.black87),
   titleMedium:   TextStyle(fontSize:14, fontWeight: FontWeight.w500 ,color: Colors.black87),
   titleSmall:    TextStyle(fontSize:13, fontWeight: FontWeight.w600 ,color: Colors.black87),

   bodyLarge:     TextStyle(fontSize:12, fontWeight: FontWeight.w600 ,color: Colors.black87),
   bodyMedium:    TextStyle(fontSize:12, fontWeight: FontWeight.w500 ,color: Colors.black87),
   bodySmall:     TextStyle(fontSize:12, fontWeight: FontWeight.w400 ,color: Colors.black87),

   labelLarge:    TextStyle(fontSize:11, fontWeight: FontWeight.w600 ,color: Colors.black87),
   labelMedium:   TextStyle(fontSize:11, fontWeight: FontWeight.w500 ,color: Colors.black87),
   labelSmall:    TextStyle(fontSize:10, fontWeight: FontWeight.w400 ,color: Colors.black87),
 );
 class ExtraTextTheme{
   static const TextStyle headlineSmallProminent=TextStyle(fontSize:16, fontWeight: FontWeight.w600 ,color: Colors.black87);
   static const TextStyle bodyLargeProminent=TextStyle(fontSize:14, fontWeight: FontWeight.w400 ,color: Colors.black87);

 }