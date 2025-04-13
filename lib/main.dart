import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:nanden/screens/auth/login_screen.dart';
import 'package:nanden/screens/auth/register_screen.dart';
import 'package:nanden/screens/auth/splash_screen.dart';
import 'package:nanden/screens/home_pages/tabs.dart';
import 'package:nanden/themes/theme.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:nanden/l10n/l10n.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'providers/localization_controller.dart';


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

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, ref) {
    final locale = ref.watch(localeProvider);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: lightTheme,
      supportedLocales: L10n.all,
      locale: locale,
      localizationsDelegates:const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        ],
      initialRoute: '/',
      routes: {
      '/': (context) => SplashScreen(),
      '/login': (context) => LoginScreen(),
      '/register': (context) => SignUpPage(),
      '/home': (context)=> TabsScreen()
  },

    );
  }
}
