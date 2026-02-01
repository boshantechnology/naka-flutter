import 'package:flutter/material.dart';
import 'package:naka/screens/EntryPoint.dart';
import 'package:naka/screens/IntroScreen.dart';
import 'package:naka/screens/JobBottomNavigation.dart';
import 'package:naka/screens/LoginScreen.dart';
import 'package:naka/screens/ProfileSetupScreen.dart';
import 'package:naka/config/app_colors.dart';
import 'package:naka/providers/AppearanceProvider.dart';
import 'package:provider/provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const JobSearchApp());
}


class JobSearchApp extends StatelessWidget {
  const JobSearchApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) {
        final provider = AppearanceProvider();
        provider.setContext(context);
        return provider;
      },
      child: Consumer<AppearanceProvider>(
        builder: (context, appearance, _) {
          appearance.setContext(context); // Update context on rebuild
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Job Search',
            theme: ThemeData(
              fontFamily: 'Inter',
              scaffoldBackgroundColor: appearance.brightness == Brightness.dark 
                  ? const Color(0xFF1E1E1E)
                  : AppColors.bgLight,
              primaryColor: appearance.primaryColor,
              useMaterial3: true,
              brightness: appearance.brightness,
              appBarTheme: AppBarTheme(
                backgroundColor: appearance.primaryColor,
                foregroundColor: Colors.white,
              ),
            ),
            home: const EntryPoint(),
            routes: {
              '/intro': (context) => IntroScreen(),
              '/login': (context) => LoginScreen(),
              '/profile': (context) => ProfileSetupScreen(),
              '/home': (context) => const JobBottomNavigationWrapper(),
            },
          );
        },
      ),
    );
  }
}
