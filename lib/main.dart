import 'package:flutter/material.dart';
import 'package:naka/screens/EntryPoint.dart';
import 'package:naka/screens/IntroScreen.dart';
import 'package:naka/screens/JobBottomNavigation.dart';
import 'package:naka/screens/LoginScreen.dart';
import 'package:naka/screens/ProfileSetupScreen.dart';
import 'package:naka/config/app_colors.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const JobSearchApp());
}


class JobSearchApp extends StatelessWidget {
  const JobSearchApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Job Search',
      theme: ThemeData(
        fontFamily: 'Inter',
        scaffoldBackgroundColor: AppColors.bgLight,
        primaryColor: AppColors.primary,
        useMaterial3: true,
      ),
      home: EntryPoint(),
      routes: {
        '/intro': (context) => IntroScreen(),
        '/login': (context) => LoginScreen(),
        '/profile': (context) => ProfileSetupScreen(),
        '/home': (context) => const JobBottomNavigationWrapper(),
      },
    );
  }
}
