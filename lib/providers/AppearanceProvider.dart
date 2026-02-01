import 'package:flutter/material.dart';

class AppearanceProvider extends ChangeNotifier {
  String _selectedTheme = 'Light'; // Light, Dark, System
  String _selectedFontSize = 'Medium'; // Small, Medium, Large
  Color _primaryColor = const Color(0xFF17A2B8); // Professional Teal (Original brand color)
  BuildContext? _contextForSystem; // Store context for system brightness detection

  // Store context for system theme
  void setContext(BuildContext context) {
    _contextForSystem = context;
  }

  // Getters
  String get selectedTheme => _selectedTheme;
  String get selectedFontSize => _selectedFontSize;
  Color get primaryColor => _primaryColor;

  // Font size mapping
  double get baseFontSize {
    switch (_selectedFontSize) {
      case 'Small':
        return 12.0;
      case 'Large':
        return 18.0;
      case 'Medium':
      default:
        return 14.0;
    }
  }

  // Theme brightness
  Brightness get brightness {
    switch (_selectedTheme) {
      case 'Dark':
        return Brightness.dark;
      case 'System':
        if (_contextForSystem != null) {
          return MediaQuery.of(_contextForSystem!).platformBrightness;
        }
        return Brightness.light; // Fallback to light if context not available
      case 'Light':
      default:
        return Brightness.light;
    }
  }

  // Get brightness with context (for use in widgets)
  Brightness getBrightness(BuildContext context) {
    switch (_selectedTheme) {
      case 'Dark':
        return Brightness.dark;
      case 'System':
        return MediaQuery.of(context).platformBrightness;
      case 'Light':
      default:
        return Brightness.light;
    }
  }

  // Setters
  void setTheme(String theme) {
    _selectedTheme = theme;
    notifyListeners();
  }

  void setFontSize(String size) {
    _selectedFontSize = size;
    notifyListeners();
  }

  void setPrimaryColor(Color color) {
    _primaryColor = color;
    notifyListeners();
  }

  // Get themed text styles
  TextStyle getTitleStyle() {
    return TextStyle(
      fontSize: baseFontSize + 6,
      fontWeight: FontWeight.bold,
      color: brightness == Brightness.dark ? Colors.white : Colors.black,
    );
  }

  TextStyle getBodyStyle() {
    return TextStyle(
      fontSize: baseFontSize,
      color: brightness == Brightness.dark ? Colors.white70 : Colors.black87,
    );
  }

  TextStyle getSmallStyle() {
    return TextStyle(
      fontSize: baseFontSize - 2,
      color: brightness == Brightness.dark ? Colors.grey : Colors.grey[600],
    );
  }
}
