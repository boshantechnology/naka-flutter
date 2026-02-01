import 'package:flutter/material.dart';
import 'package:naka/config/app_colors.dart';
import 'package:naka/providers/AppearanceProvider.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
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
              'Profile',
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
                  onTap: () {},
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
}