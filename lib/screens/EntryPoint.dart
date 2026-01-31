import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:naka/screens/SplashScreen.dart';

class EntryPoint extends StatefulWidget {
  const EntryPoint({super.key});

  @override
  _EntryPointState createState() => _EntryPointState();
}

class _EntryPointState extends State<EntryPoint> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkFlow();
    });
  }

  Future<void> _checkFlow() async {
    final prefs = await SharedPreferences.getInstance();
    final isFirstTime = prefs.getBool('is_first_time') ?? true;
    final isLoggedIn = prefs.getBool('is_logged_in') ?? false;
    final isProfileDone = prefs.getBool('is_profile_done') ?? false;

    if (isFirstTime) {
      await prefs.setBool('is_first_time', false);
      if (!mounted) return;
      Navigator.pushReplacementNamed(context, '/intro');
    } else if (!isLoggedIn) {
      if (!mounted) return;
      Navigator.pushReplacementNamed(context, '/login');
    } else if (!isProfileDone) {
      if (!mounted) return;
      Navigator.pushReplacementNamed(context, '/profile');
    } else {
      if (!mounted) return;
      Navigator.pushReplacementNamed(context, '/home');
    }
  }

  @override
  Widget build(BuildContext context) {
    return const SplashScreen();
  }
}