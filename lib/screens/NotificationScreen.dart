import 'package:flutter/material.dart';
import 'package:naka/config/app_colors.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
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
        backgroundColor: AppColors.white,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'Notifications',
          style: TextStyle(color: AppColors.black, fontWeight: FontWeight.bold),
        ),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: notifications.length,
        itemBuilder: (context, index) {
          final notification = notifications[index];
          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            elevation: 2,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            child: ListTile(
              leading: Icon(
                _getIcon(notification['icon']!),
                color: AppColors.primary,
                size: 28,
              ),
              title: Text(
                notification['title']!,
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              subtitle: Text(
                notification['subtitle']!,
                style: const TextStyle(color: AppColors.grey, fontSize: 14),
              ),
              trailing: Text(
                notification['time']!,
                style: const TextStyle(color: AppColors.grey, fontSize: 12),
              ),
            ),
          );
        },
      ),      bottomNavigationBar: SizedBox.shrink(),    );
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