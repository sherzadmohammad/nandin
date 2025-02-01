import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:nanden/screens/auth/splash_screen.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
//import 'package:nanden/l10n/l10n.dart';
final darkTheme = ThemeData(
  useMaterial3: true,
  scaffoldBackgroundColor: const Color.fromARGB(155, 94, 68, 56),
  colorScheme: ColorScheme.fromSeed(
    brightness: Brightness.dark,
    seedColor: const Color.fromARGB(155, 131, 39, 0),
  ),
);

final lightTheme = ThemeData(
  useMaterial3: true,
  scaffoldBackgroundColor: Colors.white,
  colorScheme: ColorScheme.fromSeed(
    brightness: Brightness.dark,
    seedColor: const Color.fromARGB(199, 224, 186, 169),
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
      debugShowCheckedModeBanner: true,
      theme: lightTheme,darkTheme: darkTheme,
      themeMode: ThemeMode.system,
      supportedLocales: const [
        Locale('en'),
        Locale('fa'),
        Locale('ar')
      ],
      locale: const Locale('en'),
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        ],
      home: const SplashScreen(),
    );
  }
}
