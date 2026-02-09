import 'package:flutter/material.dart';
import 'package:naka/providers/AppearanceProvider.dart';
import 'package:provider/provider.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AppearanceProvider>(
      builder: (context, appearance, _) {
        return Scaffold(
          backgroundColor: appearance.brightness == Brightness.dark
              ? const Color(0xFF1E1E1E)
              : const Color(0xFFF8F9FA),
          appBar: AppBar(
            backgroundColor: appearance.brightness == Brightness.dark
                ? const Color(0xFF2A2A2A)
                : Colors.white,
            elevation: 0,
            centerTitle: true,
            title: Text(
              'Settings',
              style: TextStyle(
                color: appearance.brightness == Brightness.dark
                    ? Colors.white
                    : Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
            leading: IconButton(
              icon: Icon(
                Icons.arrow_back,
                color: appearance.brightness == Brightness.dark
                    ? Colors.white
                    : Colors.black,
              ),
              onPressed: () => Navigator.pop(context),
            ),
          ),
          body: ListView(
            padding: const EdgeInsets.all(16.0),
            children: [
              _buildHeaderCard(appearance),
              const SizedBox(height: 16),
              _buildSectionTitle('Appearance', appearance),
              const SizedBox(height: 10),
              _buildCard(
                appearance: appearance,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildSectionHeader('Theme', appearance),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _themeButton(context, 'Light', Icons.light_mode, appearance),
                        _themeButton(context, 'Dark', Icons.dark_mode, appearance),
                        _themeButton(context, 'System', Icons.settings_suggest, appearance),
                      ],
                    ),
                    const SizedBox(height: 16),
                    _buildSectionHeader('Font Size', appearance),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _fontSizeButton(context, 'Small', 12, appearance),
                        _fontSizeButton(context, 'Medium', 14, appearance),
                        _fontSizeButton(context, 'Large', 18, appearance),
                      ],
                    ),
                    const SizedBox(height: 16),
                    _buildSectionHeader('Primary Color', appearance),
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
              const SizedBox(height: 20),
              _buildSectionTitle('Account', appearance),
              const SizedBox(height: 10),
              _buildCard(
                appearance: appearance,
                child: Column(
                  children: [
                    _buildSettingTile(
                      title: 'Profile',
                      icon: Icons.account_circle,
                      appearance: appearance,
                      onTap: () {},
                    ),
                    _buildDivider(appearance),
                    _buildSettingTile(
                      title: 'Notifications',
                      icon: Icons.notifications,
                      appearance: appearance,
                      onTap: () {},
                    ),
                    _buildDivider(appearance),
                    _buildSettingTile(
                      title: 'Privacy',
                      icon: Icons.lock_outline,
                      appearance: appearance,
                      onTap: () {},
                    ),
                    _buildDivider(appearance),
                    _buildSettingTile(
                      title: 'Security',
                      icon: Icons.security,
                      appearance: appearance,
                      onTap: () {},
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              _buildSectionTitle('Support', appearance),
              const SizedBox(height: 10),
              _buildCard(
                appearance: appearance,
                child: Column(
                  children: [
                    _buildSettingTile(
                      title: 'Help Center',
                      icon: Icons.help_outline,
                      appearance: appearance,
                      onTap: () {},
                    ),
                    _buildDivider(appearance),
                    _buildSettingTile(
                      title: 'About App',
                      icon: Icons.info_outline,
                      appearance: appearance,
                      onTap: () {},
                    ),
                  ],
                ),
              ),
            ],
          ),
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

  Widget _buildSectionTitle(String title, AppearanceProvider appearance) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 12.5,
        fontWeight: FontWeight.w700,
        letterSpacing: 0.4,
        color: appearance.brightness == Brightness.dark
            ? Colors.grey[300]
            : Colors.grey[600],
      ),
    );
  }

  Widget _buildHeaderCard(AppearanceProvider appearance) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: appearance.brightness == Brightness.dark
            ? const Color(0xFF2A2A2A)
            : Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: appearance.primaryColor.withOpacity(0.15),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              Icons.settings,
              color: appearance.primaryColor,
              size: 22,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Customize your experience',
                  style: TextStyle(
                    fontSize: 14.5,
                    fontWeight: FontWeight.w700,
                    color: appearance.brightness == Brightness.dark
                        ? Colors.white
                        : Colors.black87,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Theme, font size, colors, and account preferences.',
                  style: TextStyle(
                    fontSize: 12,
                    color: appearance.brightness == Brightness.dark
                        ? Colors.grey[400]
                        : Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title, AppearanceProvider appearance) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 13.5,
        fontWeight: FontWeight.w700,
        color: appearance.brightness == Brightness.dark
            ? Colors.white
            : Colors.black87,
      ),
    );
  }

  Widget _buildCard({required AppearanceProvider appearance, required Widget child}) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: appearance.brightness == Brightness.dark
            ? const Color(0xFF2A2A2A)
            : Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: child,
    );
  }

  Widget _buildSettingTile({
    required String title,
    required IconData icon,
    required AppearanceProvider appearance,
    required VoidCallback onTap,
  }) {
    return ListTile(
      dense: true,
      contentPadding: EdgeInsets.zero,
      leading: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: appearance.primaryColor.withOpacity(0.12),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, color: appearance.primaryColor, size: 18),
      ),
      title: Text(
        title,
        style: TextStyle(
          fontSize: 13.5,
          fontWeight: FontWeight.w600,
          color: appearance.brightness == Brightness.dark
              ? Colors.white
              : Colors.black87,
        ),
      ),
      trailing: Icon(
        Icons.chevron_right,
        color: appearance.brightness == Brightness.dark
            ? Colors.grey[500]
            : Colors.grey[500],
        size: 20,
      ),
      onTap: onTap,
    );
  }

  Widget _buildDivider(AppearanceProvider appearance) {
    return Divider(
      height: 16,
      thickness: 1,
      color: appearance.brightness == Brightness.dark
          ? Colors.grey[800]
          : Colors.grey[200],
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