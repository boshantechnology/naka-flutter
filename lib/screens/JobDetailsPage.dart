import 'package:flutter/material.dart';
import 'package:naka/config/app_colors.dart';
import 'package:naka/providers/AppearanceProvider.dart';
import 'package:provider/provider.dart';

class JobDetailsPage extends StatelessWidget {
  final Map<String, dynamic> job;

  const JobDetailsPage({super.key, required this.job});

  @override
  Widget build(BuildContext context) {
    return Consumer<AppearanceProvider>(
      builder: (context, appearance, _) {
        return Scaffold(
          backgroundColor: appearance.brightness == Brightness.dark
              ? const Color(0xFF1E1E1E)
              : const Color(0xFFF9FAFB),
          appBar: AppBar(
            elevation: 0,
            backgroundColor: appearance.brightness == Brightness.dark
                ? const Color(0xFF2A2A2A)
                : AppColors.white,
            foregroundColor: appearance.brightness == Brightness.dark
                ? Colors.white
                : AppColors.black,
            title: Text(
              'Job Details',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: appearance.brightness == Brightness.dark
                    ? Colors.white
                    : AppColors.black,
              ),
            ),
            centerTitle: true,
            leading: IconButton(
              icon: Icon(
                Icons.arrow_back,
                color: appearance.brightness == Brightness.dark
                    ? Colors.white
                    : AppColors.black,
              ),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  /// Profile Icon & Job Name
                  Column(
                    children: [
                      const CircleAvatar(
                        radius: 36,
                        backgroundColor: Colors.grey,
                        child: Icon(Icons.work_outline, size: 36, color: Colors.white),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        job['title'],
                        style: appearance.getTitleStyle().copyWith(
                          color: appearance.primaryColor,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        job['company'],
                        style: appearance.getBodyStyle().copyWith(
                          color: appearance.brightness == Brightness.dark
                              ? Colors.grey[400]
                              : Colors.grey,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  /// Action Buttons (Call, SMS, Apply)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildActionButton(Icons.phone, 'Call', () {
                        // Add call functionality
                      }, appearance),
                      _buildActionButton(Icons.sms, 'SMS', () {
                        // Add SMS functionality
                      }, appearance),
                      ElevatedButton(
                        onPressed: () {
                          // Add apply functionality
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: appearance.primaryColor,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 10,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: Text(
                          'Apply',
                          style: appearance.getBodyStyle().copyWith(
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  /// Google Map Placeholder
                  Container(
                    height: 180,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: appearance.brightness == Brightness.dark
                          ? Colors.grey[800]
                          : Colors.blueGrey[100],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Center(
                      child: Text(
                        'Google Map Placeholder',
                        style: TextStyle(
                          fontSize: 16,
                          color: appearance.brightness == Brightness.dark
                              ? Colors.grey[400]
                              : Colors.black54,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  /// Job Details & About Tab (Static UI for now)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Job Details',
                        style: appearance.getTitleStyle().copyWith(
                          color: appearance.brightness == Brightness.dark
                              ? Colors.white
                              : Colors.black,
                          fontSize: 16,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                      Text(
                        'About',
                        style: appearance.getBodyStyle().copyWith(
                          color: appearance.brightness == Brightness.dark
                              ? Colors.grey[400]
                              : Colors.grey,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  /// Job Details Section
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.location_on, size: 18, color: appearance.primaryColor),
                          const SizedBox(width: 6),
                          Text(
                            job['location'],
                            style: appearance.getBodyStyle().copyWith(
                              color: appearance.brightness == Brightness.dark
                                  ? Colors.white
                                  : Colors.black87,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Icon(Icons.attach_money, size: 18, color: appearance.primaryColor),
                          const SizedBox(width: 6),
                          Text(
                            job['salary'],
                            style: appearance.getBodyStyle().copyWith(
                              color: appearance.brightness == Brightness.dark
                                  ? Colors.white
                                  : Colors.black87,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      if (job['isRemote'] == true)
                        Row(
                          children: [
                            Icon(Icons.wifi, size: 18, color: appearance.primaryColor),
                            const SizedBox(width: 6),
                            Text(
                              'Remote',
                              style: appearance.getBodyStyle().copyWith(
                                color: appearance.brightness == Brightness.dark
                                    ? Colors.white
                                    : Colors.black87,
                              ),
                            ),
                          ],
                        ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  /// Work Description
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Work Description',
                      style: appearance.getTitleStyle().copyWith(
                        color: appearance.brightness == Brightness.dark
                            ? Colors.white
                            : Colors.black,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'This is a sample job description for demonstration purposes. '
                    'Include key responsibilities, required skills, and any other '
                    'important info here. You can replace this with actual data later.',
                    style: appearance.getBodyStyle().copyWith(
                      color: appearance.brightness == Brightness.dark
                          ? Colors.grey[300]
                          : Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 30),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  /// Helper method to build action buttons
  Widget _buildActionButton(
    IconData icon,
    String label,
    VoidCallback onPressed,
    AppearanceProvider appearance,
  ) {
    return GestureDetector(
      onTap: onPressed,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: appearance.primaryColor.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: appearance.primaryColor, size: 20),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: appearance.getSmallStyle().copyWith(
              color: appearance.primaryColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}