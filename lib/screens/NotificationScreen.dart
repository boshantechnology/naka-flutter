import 'package:flutter/material.dart';
import 'package:naka/config/app_colors.dart';
import 'package:naka/providers/AppearanceProvider.dart';
import 'package:provider/provider.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AppearanceProvider>(
      builder: (context, appearance, _) {
        final List<Map<String, String>> notifications = [
      {
        'title': 'Photo shared',
        'subtitle': 'Another update from social',
        'time': '7:28 PM',
        'icon': 'notifications',
      },
      {
        'title': 'Document saved',
        'subtitle': 'Keeping informed with each sync',
        'time': '2:05 PM',
        'icon': 'cloud',
      },
      {
        'title': 'Error saving document',
        'subtitle': 'Nevermind. It\'s better now',
        'time': '11:24 AM',
        'icon': 'message',
      },
      {
        'title': 'Error downloading apps',
        'subtitle': 'Keeping informed with each sync',
        'time': '8:30 AM',
        'icon': 'download',
      },
      {
        'title': 'New job posted',
        'subtitle': 'A job matching your skills is now available',
        'time': '6:45 PM',
        'icon': 'work',
      },
      {
        'title': 'Job application update',
        'subtitle': 'Your application for Software Engineer is under review',
        'time': '4:30 PM',
        'icon': 'update',
      },
      {
        'title': 'Interview scheduled',
        'subtitle': 'Your interview for Product Manager is scheduled tomorrow',
        'time': '3:15 PM',
        'icon': 'calendar',
      },
    ];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: appearance.brightness == Brightness.dark
            ? const Color(0xFF2A2A2A)
            : Colors.white,
        elevation: 0,
        centerTitle: true,
        title: Text(
          'Notifications',
          style: TextStyle(
            color: appearance.brightness == Brightness.dark
                ? Colors.white
                : AppColors.black,
            fontWeight: FontWeight.bold,
            fontSize: 18
          ),
        ),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(10.0),
        itemCount: notifications.length,
        itemBuilder: (context, index) {
          final notification = notifications[index];
          return Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: appearance.brightness == Brightness.dark
                  ? const Color(0xFF2A2A2A)
                  : Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(
                  _getIcon(notification['icon']!),
                  color: appearance.primaryColor,
                  size: 28,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        notification['title']!,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                          color: appearance.brightness == Brightness.dark
                              ? Colors.white
                              : AppColors.black,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        notification['subtitle']!,
                        style: TextStyle(
                          color: appearance.brightness == Brightness.dark
                              ? Colors.grey[500]
                              : AppColors.grey,
                          fontSize: 12
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 10),
                Text(
                  notification['time']!,
                  style: TextStyle(
                    color: appearance.brightness == Brightness.dark
                        ? Colors.grey[500]
                        : AppColors.grey,
                    fontSize: 11
                  ),
                ),
              ],
            ),
          );
        },
      ),
      backgroundColor: appearance.brightness == Brightness.dark
          ? const Color(0xFF1E1E1E)
          : AppColors.bgLight,
    );
      },
    );
  }

  IconData _getIcon(String iconName) {
    switch (iconName) {
      case 'notifications':
        return Icons.notifications;
      case 'cloud':
        return Icons.cloud;
      case 'message':
        return Icons.message;
      case 'download':
        return Icons.download;
      case 'work':
        return Icons.work;
      case 'update':
        return Icons.update;
      case 'calendar':
        return Icons.calendar_today;
      default:
        return Icons.notifications;
    }
  }
}