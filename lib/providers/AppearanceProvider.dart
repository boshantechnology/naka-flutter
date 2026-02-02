import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppearanceProvider extends ChangeNotifier with WidgetsBindingObserver {
  String _selectedTheme = 'System'; // Light, Dark, System
  String _selectedFontSize = 'Medium'; // Small, Medium, Large
  Color _primaryColor = const Color(0xFF17A2B8); // Professional Teal (Original brand color)
  late SharedPreferences _prefs;
  bool _isInitialized = false;

  // Keys for SharedPreferences
  static const String _themeKey = 'selected_theme';
  static const String _fontSizeKey = 'selected_font_size';
  static const String _colorKey = 'primary_color';

  // Initialize SharedPreferences and load saved settings
  Future<void> initialize() async {
    if (_isInitialized) return;
    
    _prefs = await SharedPreferences.getInstance();
    
    // Load saved theme
    _selectedTheme = _prefs.getString(_themeKey) ?? 'Light';
    
    // Load saved font size
    _selectedFontSize = _prefs.getString(_fontSizeKey) ?? 'Medium';
    
    // Load saved color
    final colorValue = _prefs.getInt(_colorKey);
    if (colorValue != null) {
      _primaryColor = Color(colorValue);
    }
    
    _isInitialized = true;
    
    // Start listening for system brightness changes
    WidgetsBinding.instance.addObserver(this);
    
    notifyListeners();
  }

  @override
  void didChangePlatformBrightness() {
    // Called when system brightness changes
    // Always notify listeners when System theme is selected
    notifyListeners();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
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

  // Theme brightness - get current system brightness from WidgetsBinding
  Brightness get brightness {
    switch (_selectedTheme) {
      case 'Dark':
        return Brightness.dark;
      case 'System':
        // Get system brightness directly from WidgetsBinding
        final brightness = WidgetsBinding.instance.window.platformBrightness;
        return brightness;
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

  // Setters with persistence
  void setTheme(String theme) {
    _selectedTheme = theme;
    _prefs.setString(_themeKey, theme);
    notifyListeners();
  }

  void setFontSize(String size) {
    _selectedFontSize = size;
    _prefs.setString(_fontSizeKey, size);
    notifyListeners();
  }

  void setPrimaryColor(Color color) {
    _primaryColor = color;
    _prefs.setInt(_colorKey, color.value);
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
