import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nanden/screens/auth/login_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart'; // Add Supabase package
import '../../providers/user_provider.dart'; // Assuming this remains the same
import 'onboarding.dart'; // Assuming this remains the same
import '../home_pages/tabs.dart'; // Assuming this remains the same

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  bool _hasNavigated = false;

  @override
  void initState() {
    super.initState();
    _initSplashScreen();
  }

  Future<void> _initSplashScreen() async {
    if (_hasNavigated) return;

    // Wait for 3 seconds (splash screen delay)
    await Future.delayed(const Duration(seconds: 3));

    // Check authentication status using Supabase
    final session = Supabase.instance.client.auth.currentSession;

    if (session != null) {
      // User is authenticated
      ref.read(userProvider.notifier).fetchUserDetails(); // Fetch user details
      if (mounted) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const TabsScreen()),
              (route) => false,
        );
      }
    } else {
      // User is not authenticated, check if onboarding is completed
    final prefs = await SharedPreferences.getInstance();
    final hasCompletedOnboarding = prefs.getBool('hasCompletedOnboarding') ?? false;

    if (mounted) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) =>
              hasCompletedOnboarding ? const LoginScreen() : const OnBoarding(),
        ),
        (route) => false,
      );
    }
    }
    _hasNavigated = true;
  }

  @override
  void dispose() {
    _hasNavigated = false; // Reset the flag if the widget is disposed
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Color(0XFFDCC1FF),
      body: SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: Center(
          child: Text(
            'NANDEN',
            style: TextStyle(
              fontWeight: FontWeight.w900,
              fontSize: 34,
              color: Colors.black,
            ),
          ),
        ),
      ),
    );
  }
}