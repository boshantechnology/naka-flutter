import 'package:flutter/material.dart';
import 'package:naka/providers/AppearanceProvider.dart';
import 'package:provider/provider.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AppearanceProvider>(
      builder: (context, appearance, _) {
        return ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
            Text(
              'Settings',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: appearance.brightness == Brightness.dark ? Colors.white : Colors.black,
              ),
            ),
            const SizedBox(height: 24),
            
            // APPEARANCE SECTION
            Text(
              'Appearance',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 12),
            
            // Theme Selection
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey[300]!),
                borderRadius: BorderRadius.circular(8),
              ),
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Theme',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _themeButton(context, 'Light', Icons.light_mode, appearance),
                      _themeButton(context, 'Dark', Icons.dark_mode, appearance),
                      _themeButton(context, 'System', Icons.settings_suggest, appearance),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            
            // Font Size Selection
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey[300]!),
                borderRadius: BorderRadius.circular(8),
              ),
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Font Size',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _fontSizeButton(context, 'Small', 12, appearance),
                      _fontSizeButton(context, 'Medium', 14, appearance),
                      _fontSizeButton(context, 'Large', 18, appearance),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            
            // Primary Color Selection
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey[300]!),
                borderRadius: BorderRadius.circular(8),
              ),
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Primary Color',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _colorButton(context, 'Default', const Color(0xFF17A2B8), appearance),
                      _colorButton(context, 'Teal', const Color(0xFF00D4AA), appearance),
                      _colorButton(context, 'Blue', const Color(0xFF0084FF), appearance),
                      _colorButton(context, 'Purple', const Color(0xFF9C27B0), appearance),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _colorButton(context, 'Green', const Color(0xFF4CAF50), appearance),
                      _colorButton(context, 'Orange', const Color(0xFFFF9800), appearance),
                      _colorButton(context, 'Pink', const Color(0xFFE91E63), appearance),
                      _colorButton(context, 'Red', const Color(0xFFF44336), appearance),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _colorButton(context, 'Indigo', const Color(0xFF3F51B5), appearance),
                      const SizedBox(width: 48),
                      const SizedBox(width: 48),
                      const SizedBox(width: 48),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            
            // OTHER SECTIONS
            Text(
              'Account',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 12),
            ListTile(
              title: const Text('Profile'),
              trailing: const Icon(Icons.arrow_forward),
              onTap: () {},
            ),
            ListTile(
              title: const Text('Notifications'),
              trailing: const Icon(Icons.arrow_forward),
              onTap: () {},
            ),
            ListTile(
              title: const Text('Privacy'),
              trailing: const Icon(Icons.arrow_forward),
              onTap: () {},
            ),
            ListTile(
              title: const Text('Security'),
              trailing: const Icon(Icons.arrow_forward),
              onTap: () {},
            ),
            const SizedBox(height: 24),
            
            Text(
              'Other',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 12),
            ListTile(
              title: const Text('Help Center'),
              trailing: const Icon(Icons.arrow_forward),
              onTap: () {},
            ),
            ListTile(
              title: const Text('About App'),
              trailing: const Icon(Icons.arrow_forward),
              onTap: () {},
            ),
          ],
        );
      },
    );
  }

  Widget _themeButton(BuildContext context, String theme, IconData icon, AppearanceProvider appearance) {
    final isSelected = appearance.selectedTheme == theme;
    return GestureDetector(
      onTap: () {
        appearance.setTheme(theme);
      },
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isSelected ? appearance.primaryColor.withOpacity(0.2) : Colors.grey[200],
              border: isSelected ? Border.all(color: appearance.primaryColor, width: 2) : null,
            ),
            child: Icon(
              icon,
              color: isSelected ? appearance.primaryColor : Colors.grey,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            theme,
            style: TextStyle(
              fontSize: 12,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              color: isSelected ? appearance.primaryColor : Colors.grey,
            ),
          ),
        ],
      ),
    );
  }

  Widget _fontSizeButton(BuildContext context, String size, double fontSize, AppearanceProvider appearance) {
    final isSelected = appearance.selectedFontSize == size;
    return GestureDetector(
      onTap: () {
        appearance.setFontSize(size);
      },
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: isSelected ? appearance.primaryColor.withOpacity(0.2) : Colors.grey[200],
              border: isSelected ? Border.all(color: appearance.primaryColor, width: 2) : null,
            ),
            child: Text(
              'A',
              style: TextStyle(
                fontSize: fontSize,
                fontWeight: FontWeight.bold,
                color: isSelected ? appearance.primaryColor : Colors.grey,
              ),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            size,
            style: TextStyle(
              fontSize: 12,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              color: isSelected ? appearance.primaryColor : Colors.grey,
            ),
          ),
        ],
      ),
    );
  }

  Widget _colorButton(BuildContext context, String colorName, Color color, AppearanceProvider appearance) {
    final isSelected = appearance.primaryColor == color;
    return GestureDetector(
      onTap: () {
        appearance.setPrimaryColor(color);
      },
      child: Column(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: color,
              border: isSelected ? Border.all(color: Colors.black, width: 3) : null,
            ),
            child: isSelected
                ? const Icon(Icons.check, color: Colors.white)
                : null,
          ),
          const SizedBox(height: 4),
          Text(
            colorName,
            style: TextStyle(
              fontSize: 11,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
}