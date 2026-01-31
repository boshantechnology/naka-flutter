import 'package:flutter/material.dart';
import 'package:naka/config/app_colors.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool isSettingsExpanded = false;
  bool isSavedJobsExpanded = false;
  bool isHistoryExpanded = false;
  bool isUpdateProfileExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgLight,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'Profile',
          style: TextStyle(color: AppColors.black, fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Profile Image and Info
            _buildProfileHeader(),

            const SizedBox(height: 24),

            // Applications Count Card
            _buildCard(
              title: 'Overview',
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildStatItem('Applications', '12'),
                  _buildStatItem('Saved Jobs', '5'),
                  _buildStatItem('Interviews', '3'),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Saved Jobs Card
            _buildExpandableCard(
              title: 'Saved Jobs',
              icon: Icons.bookmark,
              isExpanded: isSavedJobsExpanded,
              onToggle: () {
                setState(() {
                  isSavedJobsExpanded = !isSavedJobsExpanded;
                });
              },
              child: Column(
                children: [
                  _buildSavedJobItem('UI/UX Designer', 'TechInnovate'),
                  _buildSavedJobItem('Product Manager', 'CreativeWorks'),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Application History Card
            _buildExpandableCard(
              title: 'Application History',
              icon: Icons.history,
              isExpanded: isHistoryExpanded,
              onToggle: () {
                setState(() {
                  isHistoryExpanded = !isHistoryExpanded;
                });
              },
              child: Column(
                children: [
                  _buildApplicationItem('Software Engineer', '2 days ago'),
                  _buildApplicationItem('Product Manager', '1 week ago'),
                  _buildApplicationItem('Data Scientist', '2 weeks ago'),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Update Profile Card
            _buildExpandableCard(
              title: 'Update Profile',
              icon: Icons.edit,
              isExpanded: isUpdateProfileExpanded,
              onToggle: () {
                setState(() {
                  isUpdateProfileExpanded = !isUpdateProfileExpanded;
                });
              },
              child: _buildUpdateProfileButton(context),
            ),

            const SizedBox(height: 16),

            // Settings Card
            _buildExpandableCard(
              title: 'Settings',
              icon: Icons.settings,
              isExpanded: isSettingsExpanded,
              onToggle: () {
                setState(() {
                  isSettingsExpanded = !isSettingsExpanded;
                });
              },
              child: Column(
                children: [
                  _buildSettingsItem(Icons.lock, 'Privacy Settings', () {
                    // Add Privacy Settings functionality
                  }),
                  _buildSettingsItem(Icons.notifications, 'Notification Settings', () {
                    // Add Notification Settings functionality
                  }),
                  _buildSettingsItem(Icons.logout, 'Logout', () {
                    // Add Logout functionality
                  }),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: SizedBox.shrink(),
    );
  }

  Widget _buildProfileHeader() {
    return Column(
      children: [
        Center(
          child: Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.primary, width: 2),
              image: const DecorationImage(
                image: NetworkImage(
                  'https://randomuser.me/api/portraits/women/44.jpg', // Replace with actual profile image URL
                ),
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
        const SizedBox(height: 16),
        const Text(
          'Ethan Carter',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 4),
        const Text(
          'Software Engineer',
          style: TextStyle(fontSize: 16, color: AppColors.primary),
        ),
        const SizedBox(height: 4),
        const Text(
          'San Francisco, CA',
          style: TextStyle(fontSize: 14, color: AppColors.grey),
        ),
      ],
    );
  }

  Widget _buildCard({required String title, required Widget child}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          child,
        ],
      ),
    );
  }

  Widget _buildExpandableCard({
    required String title,
    required IconData icon,
    required bool isExpanded,
    required VoidCallback onToggle,
    required Widget child,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          ListTile(
            leading: Icon(icon, color: AppColors.primary),
            title: Text(
              title,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            trailing: Icon(
              isExpanded ? Icons.expand_less : Icons.expand_more,
              color: AppColors.primary,
            ),
            onTap: onToggle,
          ),
          if (isExpanded)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: child,
            ),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: AppColors.primary,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(fontSize: 14, color: AppColors.grey),
        ),
      ],
    );
  }

  Widget _buildSavedJobItem(String position, String company) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(Icons.bookmark, color: AppColors.primary),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  position,
                  style: const TextStyle(fontWeight: FontWeight.w500),
                ),
                Text(
                  company,
                  style: const TextStyle(color: AppColors.grey, fontSize: 12),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildApplicationItem(String position, String timeAgo) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(Icons.business_center, color: AppColors.primary),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  position,
                  style: const TextStyle(fontWeight: FontWeight.w500),
                ),
                Text(
                  'Applied $timeAgo',
                  style: const TextStyle(color: AppColors.grey, fontSize: 12),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUpdateProfileButton(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: () {
        // Add Update Profile functionality
      },
      icon: const Icon(Icons.edit, color: AppColors.white),
      label: const Text('Update Profile'),
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primary,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }

  Widget _buildSettingsItem(IconData icon, String label, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon, color: AppColors.primary),
      title: Text(label, style: const TextStyle(fontSize: 16)),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: AppColors.grey),
      onTap: onTap,
    );
  }
}