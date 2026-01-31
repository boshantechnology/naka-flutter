import 'package:flutter/material.dart';
import 'package:naka/screens/JobHomeScreen.dart';
import 'package:naka/screens/NotificationScreen.dart';
import 'package:naka/screens/PostJobPage.dart';
import 'package:naka/screens/ProfileSetupScreen.dart';
import 'package:naka/screens/ProfileScreen.dart';
import 'package:naka/utils/app_strings.dart'; // Import the AppStrings class

class JobBottomNavigationWrapper extends StatefulWidget {
  final int initialIndex;
  
  const JobBottomNavigationWrapper({super.key, this.initialIndex = 0});

  @override
  State<JobBottomNavigationWrapper> createState() => _JobBottomNavigationWrapperState();
}

class _JobBottomNavigationWrapperState extends State<JobBottomNavigationWrapper> {
  late int _selectedIndex;
  bool _isReady = false;

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.initialIndex;
    // Ensure first frame is rendered before marking as ready
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        _isReady = true;
      });
    });
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Widget _buildScreen(int index) {
    switch (index) {
      case 0:
        return JobHomeScreen();
      case 1:
        return ProfileSetupScreen();
      case 2:
        return PostJobPage();
      case 3:
        return NotificationScreen();
      case 4:
        return ProfileScreen();
      default:
        return JobHomeScreen();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: _isReady ? _buildScreen(_selectedIndex) : const SizedBox.expand(
          child: Center(child: CircularProgressIndicator()),
        ),
      ),
      bottomNavigationBar: SafeArea(
        top: false,
        child: JobBottomNavigation(
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
        ),
      ),
    );
  }
}

class JobBottomNavigation extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const JobBottomNavigation({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      selectedItemColor: const Color(0xFF0D141C),
      unselectedItemColor: const Color(0xFF49739C),
      type: BottomNavigationBarType.fixed,
      backgroundColor: Colors.white,
      elevation: 8,
      showUnselectedLabels: true,
      items: [
        BottomNavigationBarItem(icon: const Icon(Icons.home), label: AppStrings.home),
        BottomNavigationBarItem(icon: const Icon(Icons.search), label: AppStrings.search),
        BottomNavigationBarItem(icon: const Icon(Icons.add_box_outlined), label: AppStrings.postJob),
        BottomNavigationBarItem(icon: const Icon(Icons.notification_add), label: AppStrings.notifications),
        BottomNavigationBarItem(icon: const Icon(Icons.person), label: AppStrings.profile),
      ],
      onTap: onTap,
    );
  }
}