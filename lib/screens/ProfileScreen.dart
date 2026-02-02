import 'package:flutter/material.dart';
import 'package:naka/config/app_colors.dart';
import 'package:naka/providers/AppearanceProvider.dart';
import 'package:naka/providers/LocaleProvider.dart';
import 'package:naka/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AppearanceProvider>(
      builder: (context, appearance, _) {
        final loc = AppLocalizations.of(context) ?? AppLocalizations('en');
        
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
            leading: IconButton(
              icon: Icon(
                Icons.arrow_back,
                color: appearance.brightness == Brightness.dark
                    ? Colors.white
                    : AppColors.text,
              ),
              onPressed: () {
                // Navigate to home
                Navigator.of(context).pushNamed('/home');
              },
            ),
            title: Text(
              loc.profile,
              style: TextStyle(
                color: appearance.brightness == Brightness.dark
                    ? Colors.white
                    : AppColors.text,
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
            actions: [
              IconButton(
                icon: Icon(
                  Icons.more_vert,
                  color: appearance.brightness == Brightness.dark
                      ? Colors.white
                      : AppColors.text,
                ),
                onPressed: () {},
              ),
            ],
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                _buildProfileHeader(appearance),
                const SizedBox(height: 12),
                _buildOverviewCard(appearance),
                const SizedBox(height: 10),
                _buildMenuCard(
                  title: 'Saved Jobs',
                  icon: Icons.bookmark,
                  color: appearance.primaryColor,
                  onTap: () {},
                  appearance: appearance,
                ),
                const SizedBox(height: 8),
                _buildMenuCard(
                  title: 'Application History',
                  icon: Icons.history,
                  color: appearance.primaryColor,
                  onTap: () {},
                  appearance: appearance,
                ),
                const SizedBox(height: 8),
                _buildMenuCard(
                  title: 'Update Profile',
                  icon: Icons.person,
                  color: const Color(0xFFFFA500),
                  onTap: () {
                    Navigator.pushNamed(context, '/profile');
                  },
                  appearance: appearance,
                ),
                const SizedBox(height: 8),
                _buildMenuCard(
                  title: 'Settings',
                  icon: Icons.settings,
                  color: const Color(0xFF6C757D),
                  onTap: () {
                    _showAppearanceDrawer(context, appearance, loc);
                  },
                  appearance: appearance,
                ),
                const SizedBox(height: 12),
                _buildLogoutButton(appearance),
                const SizedBox(height: 12),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildProfileHeader(AppearanceProvider appearance) {
    return Center(
      child: Column(
        children: [
          Stack(
            alignment: Alignment.bottomRight,
            children: [
              Container(
                width: 90,
                height: 90,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: appearance.primaryColor,
                    width: 3,
                  ),
                  image: const DecorationImage(
                    image: NetworkImage(
                      'https://randomuser.me/api/portraits/men/32.jpg',
                    ),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: appearance.primaryColor,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 4,
                      offset: const Offset(0, 1),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.edit,
                  color: Colors.white,
                  size: 16,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            'Ethan Carter',
            style: appearance.getTitleStyle().copyWith(
              color: appearance.brightness == Brightness.dark
                  ? Colors.white
                  : AppColors.text,
              fontSize: 18,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Software Engineer',
            style: appearance.getSmallStyle().copyWith(
              color: appearance.primaryColor,
              fontWeight: FontWeight.w600,
              fontSize: 13,
            ),
          ),
          const SizedBox(height: 6),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.location_on,
                color: appearance.brightness == Brightness.dark
                    ? Colors.grey[500]
                    : AppColors.grey,
                size: 14,
              ),
              const SizedBox(width: 3),
              Text(
                'San Francisco, CA',
                style: TextStyle(
                  fontSize: 12,
                  color: appearance.brightness == Brightness.dark
                      ? Colors.grey[400]
                      : AppColors.grey,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildOverviewCard(AppearanceProvider appearance) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: appearance.brightness == Brightness.dark
            ? const Color(0xFF2A2A2A)
            : Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 6,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Overview',
            style: appearance.getSmallStyle().copyWith(
              fontSize: 13,
              fontWeight: FontWeight.bold,
              color: appearance.brightness == Brightness.dark
                  ? Colors.white
                  : AppColors.text,
            ),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildStatItem('12', 'Applications', appearance),
              _buildStatItem('5', 'Saved Jobs', appearance),
              _buildStatItem('3', 'Interviews', appearance),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(String value, String label, AppearanceProvider appearance) {
    return Column(
      children: [
        Text(
          value,
          style: appearance.getTitleStyle().copyWith(
            fontSize: 16,
            color: appearance.primaryColor,
          ),
        ),
        const SizedBox(height: 3),
        Text(
          label,
          style: TextStyle(
            fontSize: 11,
            color: appearance.brightness == Brightness.dark
                ? Colors.grey[500]
                : AppColors.grey,
          ),
        ),
      ],
    );
  }

  Widget _buildMenuCard({
    required String title,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
    required AppearanceProvider appearance,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
        color: appearance.brightness == Brightness.dark
            ? const Color(0xFF2A2A2A)
            : Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 4,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: color.withOpacity(0.15),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: color, size: 18),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              title,
              style: appearance.getSmallStyle().copyWith(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: appearance.brightness == Brightness.dark
                    ? Colors.white
                    : AppColors.text,
              ),
            ),
          ),
          Icon(
            Icons.arrow_forward_ios,
            color: (appearance.brightness == Brightness.dark
                ? Colors.grey[600]
                : AppColors.grey)!
            .withOpacity(0.5),
            size: 14,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLogoutButton(AppearanceProvider appearance) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.red.shade300, width: 1.2),
        borderRadius: BorderRadius.circular(10),
        color: appearance.brightness == Brightness.dark
            ? const Color(0xFF2A2A2A)
            : Colors.white,
      ),
      child: Center(
        child: Text(
          'Logout',
          style: appearance.getSmallStyle().copyWith(
            fontSize: 13,
            fontWeight: FontWeight.bold,
            color: Colors.red,
          ),
        ),
      ),
    );
  }

  void _showAppearanceDrawer(BuildContext context, AppearanceProvider appearance, AppLocalizations loc) {
    showModalBottomSheet(
      context: context,
      backgroundColor: appearance.brightness == Brightness.dark
          ? const Color(0xFF1E1E1E)
          : Colors.white,
      builder: (modalContext) => SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Text(
              'Appearance Settings',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: appearance.brightness == Brightness.dark
                    ? Colors.white
                    : Colors.black,
              ),
            ),
            const SizedBox(height: 20),

            // Theme Selection
            Text(
              'Theme',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: appearance.brightness == Brightness.dark
                    ? Colors.white
                    : Colors.black87,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _themeButton(context, 'Light', Icons.light_mode, appearance),
                _themeButton(context, 'Dark', Icons.dark_mode, appearance),
                _themeButton(context, 'System', Icons.settings_suggest, appearance),
              ],
            ),
            const SizedBox(height: 20),

            // Font Size Selection
            Text(
              'Font Size',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: appearance.brightness == Brightness.dark
                    ? Colors.white
                    : Colors.black87,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _fontSizeButton(context, 'Small', 12, appearance),
                _fontSizeButton(context, 'Medium', 14, appearance),
                _fontSizeButton(context, 'Large', 18, appearance),
              ],
            ),
            const SizedBox(height: 20),

            // Primary Color Selection
            Text(
              'Primary Color',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: appearance.brightness == Brightness.dark
                    ? Colors.white
                    : Colors.black87,
              ),
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
            const SizedBox(height: 30),

            // Language Selection
            Text(
              loc.language,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: appearance.brightness == Brightness.dark
                    ? Colors.white
                    : Colors.black87,
              ),
            ),
            const SizedBox(height: 12),
            Consumer<LocaleProvider>(
              builder: (context, localeProvider, _) {
                return GridView.count(
                  crossAxisCount: 2,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 12,
                  childAspectRatio: 1.5,
                  children: [
                    _languageButton(
                      context,
                      'English',
                      'EN',
                      const Locale('en'),
                      localeProvider,
                      appearance,
                    ),
                    _languageButton(
                      context,
                      'हिंदी',
                      'HI',
                      const Locale('hi'),
                      localeProvider,
                      appearance,
                    ),
                    _languageButton(
                      context,
                      'తెలుగు',
                      'TE',
                      const Locale('te'),
                      localeProvider,
                      appearance,
                    ),
                    _languageButton(
                      context,
                      'ಕನ್ನಡ',
                      'KN',
                      const Locale('kn'),
                      localeProvider,
                      appearance,
                    ),
                  ],
                );
              },
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _languageButton(
    BuildContext context,
    String languageName,
    String code,
    Locale locale,
    LocaleProvider localeProvider,
    AppearanceProvider appearance,
  ) {
    final isSelected = localeProvider.locale.languageCode == locale.languageCode;
    return GestureDetector(
      onTap: () {
        localeProvider.setLocale(locale);
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: isSelected
              ? appearance.primaryColor.withOpacity(0.2)
              : appearance.brightness == Brightness.dark
                  ? const Color(0xFF2A2A2A)
                  : Colors.grey[100],
          border: isSelected
              ? Border.all(color: appearance.primaryColor, width: 2)
              : Border.all(
                  color: appearance.brightness == Brightness.dark
                      ? Colors.grey[800]!
                      : Colors.grey[300]!,
                  width: 1,
                ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              languageName,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: isSelected
                    ? appearance.primaryColor
                    : appearance.brightness == Brightness.dark
                        ? Colors.white
                        : Colors.black87,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 4),
            Text(
              code,
              style: TextStyle(
                fontSize: 12,
                color: isSelected
                    ? appearance.primaryColor
                    : appearance.brightness == Brightness.dark
                        ? Colors.grey[500]
                        : Colors.grey[400],
              ),
            ),
            if (isSelected)
              Icon(
                Icons.check_circle,
                color: appearance.primaryColor,
                size: 16,
              ),
          ],
        ),
      ),
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