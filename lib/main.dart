import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nanden/screens/tabs.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final darkTheme = ThemeData(
  useMaterial3: true,
  colorScheme: ColorScheme.fromSeed(
    brightness: Brightness.dark,
    seedColor: const Color.fromARGB(155, 131, 39, 0),
  ),
);

final lightTheme = ThemeData(
  useMaterial3: true,
  colorScheme: ColorScheme.fromSeed(
    brightness: Brightness.light,
    seedColor: const Color.fromARGB(255, 131, 39, 0),
  ),
);
const supabaseUrl ='https://chaszkfcxuirksawyrrx.supabase.co';
const supabaseKey= 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImNoYXN6a2ZjeHVpcmtzYXd5cnJ4Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3Mzc4MDQwNDcsImV4cCI6MjA1MzM4MDA0N30.gstA5viU7Ms6VsS-AjYjx3D08EAz5pD7tFHh2ZkV8_4';
Future<void> main() async{
  await Supabase.initialize(
    url: supabaseUrl,
    anonKey: supabaseKey,
    storageOptions: const StorageClientOptions(
      retryAttempts: 10,
    ),
  );
  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: ThemeMode.system,
      home: const TabsScreen(),
    );
  }
}
