import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:naka/screens/EntryPoint.dart';
import 'package:naka/screens/IntroScreen.dart';
import 'package:naka/screens/JobBottomNavigation.dart';
import 'package:naka/screens/LoginScreen.dart';
import 'package:naka/screens/ProfileSetupScreen.dart';
import 'package:naka/config/app_colors.dart';
import 'package:naka/providers/AppearanceProvider.dart';
import 'package:naka/providers/LocaleProvider.dart';
import 'package:naka/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const JobSearchApp());
}


class JobSearchApp extends StatefulWidget {
  const JobSearchApp({super.key});

  @override
  State<JobSearchApp> createState() => _JobSearchAppState();
}

class _JobSearchAppState extends State<JobSearchApp> {
  late AppearanceProvider _appearanceProvider;
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    _appearanceProvider = AppearanceProvider();
    await _appearanceProvider.initialize();
    setState(() {
      _isInitialized = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!_isInitialized) {
      return MaterialApp(
        home: Scaffold(
          body: Center(
            child: CircularProgressIndicator(),
          ),
        ),
      );
    }

    return ChangeNotifierProvider(
      create: (context) {
        return _appearanceProvider;
      },
      child: ChangeNotifierProvider(
        create: (context) => LocaleProvider(),
        child: Consumer<AppearanceProvider>(
          builder: (context, appearance, _) {
            return Consumer<LocaleProvider>(
              builder: (context, localeProvider, _) {
                return MaterialApp(
                  debugShowCheckedModeBanner: false,
                  title: 'Job Search',
                  locale: localeProvider.locale,
                  supportedLocales: const [
                    Locale('en'),
                    Locale('hi'),
                    Locale('te'),
                    Locale('kn'),
                  ],
                  localizationsDelegates: const [
                    AppLocalizationsDelegate(),
                    GlobalMaterialLocalizations.delegate,
                    GlobalWidgetsLocalizations.delegate,
                    GlobalCupertinoLocalizations.delegate,
                  ],
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
                    '/home': (context) => const _HomeRouteWrapper(),
                  },
                );
              },
            );
          },
        ),
      ),
    );
  }
}

class _HomeRouteWrapper extends StatelessWidget {
  const _HomeRouteWrapper();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String?>(
      future: _getUserRole(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        // Both Worker and Contractor use JobBottomNavigationWrapper
        // JobHomeScreen internally detects role and shows appropriate data
        return const JobBottomNavigationWrapper();
      },
    );
  }

  Future<String?> _getUserRole() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('user_role');
  }
}
