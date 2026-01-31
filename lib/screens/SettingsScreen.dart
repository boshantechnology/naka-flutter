import 'package:flutter/material.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16.0),
      children: [
        const Text(
          'Settings',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        const ListTile(
          title: Text('Profile'),
          trailing: Icon(Icons.arrow_forward),
        ),
        const ListTile(
          title: Text('Notifications'),
          trailing: Icon(Icons.arrow_forward),
        ),
        const ListTile(
          title: Text('Privacy'),
          trailing: Icon(Icons.arrow_forward),
        ),
        const ListTile(
          title: Text('Security'),
          trailing: Icon(Icons.arrow_forward),
        ),
        const Divider(),
        const ListTile(
          title: Text('Language'),
          trailing: Text('English'),
        ),
        const ListTile(
          title: Text('Theme'),
          trailing: Text('System'),
        ),
        const ListTile(
          title: Text('Font Size'),
          trailing: Text('Medium'),
        ),
        const Divider(),
        const ListTile(
          title: Text('Help Center'),
          trailing: Icon(Icons.arrow_forward),
        ),
        const ListTile(
          title: Text('Contact Us'),
          trailing: Icon(Icons.arrow_forward),
        ),
        const ListTile(
          title: Text('Terms of Service'),
          trailing: Icon(Icons.arrow_forward),
        ),
        const ListTile(
          title: Text('Privacy Policy'),
          trailing: Icon(Icons.arrow_forward),
        ),
         const ListTile(
          title: Text('Logout'),
          trailing: Icon(Icons.settings),
        )
      ],
    );
  }
}