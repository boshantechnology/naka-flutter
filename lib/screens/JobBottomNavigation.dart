import 'package:flutter/material.dart';
import 'package:naka/gen_l10n/app_localizations.dart';
import 'package:naka/screens/JobHomeScreen.dart';
import 'package:naka/screens/NotificationScreen.dart';
import 'package:naka/screens/PostJobPage.dart';
import 'package:naka/screens/ProfileScreen.dart';
import 'package:naka/providers/AppearanceProvider.dart';
import 'package:provider/provider.dart';

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
        return PostJobPage();
      case 2:
        return NotificationScreen();
      case 3:
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
    final loc = AppLocalizations.of(context) ?? AppLocalizations('en');
    
    return Consumer<AppearanceProvider>(
      builder: (context, appearance, _) {
        return BottomNavigationBar(
          currentIndex: currentIndex,
          selectedItemColor: appearance.primaryColor,
          unselectedItemColor: appearance.brightness == Brightness.dark
              ? Colors.grey[600]
              : const Color(0xFF49739C),
          type: BottomNavigationBarType.fixed,
          backgroundColor: appearance.brightness == Brightness.dark
              ? const Color(0xFF2A2A2A)
              : Colors.white,
          elevation: 8,
          showUnselectedLabels: true,
          items: [
            BottomNavigationBarItem(
              icon: Icon(
                currentIndex == 0 ? Icons.home : Icons.home_outlined,
              ),
              label: loc.home,
            ),
            BottomNavigationBarItem(
              icon: Icon(
                currentIndex == 1 ? Icons.add_box : Icons.add_box_outlined,
              ),
              label: loc.postJob,
            ),
            BottomNavigationBarItem(
              icon: Icon(
                currentIndex == 2 ? Icons.mail : Icons.mail_outline,
              ),
              label: 'Messages',
            ),
            BottomNavigationBarItem(
              icon: Icon(
                currentIndex == 3 ? Icons.person : Icons.person_outline,
              ),
              label: loc.profile,
            ),
          ],
          onTap: onTap,
        );
      },
    );
  }
}