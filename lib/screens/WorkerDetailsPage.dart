import 'package:flutter/material.dart';
import 'package:naka/config/app_colors.dart';
import 'package:naka/providers/AppearanceProvider.dart';
import 'package:provider/provider.dart';

class WorkerDetailsPage extends StatelessWidget {
  final Map<String, dynamic> worker;

  const WorkerDetailsPage({super.key, required this.worker});

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
              'Worker Details',
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
                  /// Profile Picture & Worker Name
                  Column(
                    children: [
                      CircleAvatar(
                        radius: 36,
                        backgroundColor: Colors.grey,
                        backgroundImage: NetworkImage(
                          worker['image'] ?? 'https://randomuser.me/api/portraits/men/32.jpg',
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        worker['name'] ?? 'Unknown Worker',
                        style: appearance.getTitleStyle().copyWith(
                          color: appearance.primaryColor,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        worker['type'] ?? 'Carpenter',
                        style: appearance.getBodyStyle().copyWith(
                          color: appearance.brightness == Brightness.dark
                              ? Colors.grey[400]
                              : Colors.grey,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.star, color: Colors.amber, size: 16),
                          const SizedBox(width: 4),
                          Text(
                            '${worker['rating'] ?? '4.5'} (${worker['reviews'] ?? '120'} reviews)',
                            style: appearance.getSmallStyle().copyWith(
                              color: appearance.brightness == Brightness.dark
                                  ? Colors.grey[300]
                                  : Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  /// Action Buttons (Call, SMS, Hire)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildActionButton(Icons.phone, 'Call', () {
                        // Add call functionality
                      }, appearance),
                      _buildActionButton(Icons.sms, 'Message', () {
                        // Add message functionality
                      }, appearance),
                      ElevatedButton(
                        onPressed: () {
                          // Add hire functionality
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
                          'Hire',
                          style: appearance.getBodyStyle().copyWith(
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  /// Location Map Placeholder
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

                  /// Worker Details & Reviews Tab
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Details',
                        style: appearance.getTitleStyle().copyWith(
                          color: appearance.brightness == Brightness.dark
                              ? Colors.white
                              : Colors.black,
                          fontSize: 16,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                      Text(
                        'Reviews',
                        style: appearance.getBodyStyle().copyWith(
                          color: appearance.brightness == Brightness.dark
                              ? Colors.grey[400]
                              : Colors.grey,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  /// Worker Details Section
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.location_on, size: 18, color: appearance.primaryColor),
                          const SizedBox(width: 6),
                          Text(
                            worker['location'] ?? 'Mumbai, India',
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
                            '₹${worker['hourlyRate'] ?? '500'}/hour',
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
                          Icon(Icons.verified_user, size: 18, color: Colors.green),
                          const SizedBox(width: 6),
                          Text(
                            '${worker['experience'] ?? '5'} years experience',
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
                          Icon(Icons.work, size: 18, color: appearance.primaryColor),
                          const SizedBox(width: 6),
                          Text(
                            '${worker['jobsCompleted'] ?? '45'} jobs completed',
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

                  /// Skills Section
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Skills & Expertise',
                      style: appearance.getTitleStyle().copyWith(
                        color: appearance.brightness == Brightness.dark
                            ? Colors.white
                            : Colors.black,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: (worker['skills'] is List<String> 
                        ? worker['skills'] as List<String>
                        : (worker['skills'] as String?)?.split(',').map((s) => s.trim()).toList() ?? ['Carpentry', 'Repairs', 'Installation']
                    ).map((skill) {
                      return Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: appearance.primaryColor.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          skill,
                          style: appearance.getSmallStyle().copyWith(
                            color: appearance.primaryColor,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      );
                    }).toList(),
                  ),

                  const SizedBox(height: 24),

                  /// About Worker
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'About',
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
                    worker['about'] ?? 'Experienced worker with a proven track record of delivering high-quality work. '
                        'Dedicated to customer satisfaction and attention to detail.',
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
