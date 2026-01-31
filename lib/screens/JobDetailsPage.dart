import 'package:flutter/material.dart';
import 'package:naka/config/app_colors.dart';

class JobDetailsPage extends StatelessWidget {
  final Map<String, dynamic> job;

  const JobDetailsPage({super.key, required this.job});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: AppColors.white,
        foregroundColor: AppColors.black,
        title: const Text(
          'Job Details',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.black),
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
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF0D141C),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    job['company'],
                    style: const TextStyle(fontSize: 16, color: Colors.grey),
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
                  }),
                  _buildActionButton(Icons.sms, 'SMS', () {
                    // Add SMS functionality
                  }),
                  ElevatedButton(
                    onPressed: () {
                      // Add apply functionality
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.teal,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 10,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text(
                      'Apply',
                      style: TextStyle(fontSize: 14, color: Colors.white),
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
                  color: Colors.blueGrey[100],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Center(
                  child: Text(
                    'Google Map Placeholder',
                    style: TextStyle(fontSize: 16, color: Colors.black54),
                  ),
                ),
              ),

              const SizedBox(height: 24),

              /// Job Details & About Tab (Static UI for now)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  Text(
                    'Job Details',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                  Text(
                    'About',
                    style: TextStyle(fontSize: 16, color: Colors.grey),
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
                      const Icon(Icons.location_on, size: 18, color: Colors.teal),
                      const SizedBox(width: 6),
                      Text(
                        job['location'],
                        style: const TextStyle(fontSize: 14),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(Icons.attach_money, size: 18, color: Colors.teal),
                      const SizedBox(width: 6),
                      Text(
                        job['salary'],
                        style: const TextStyle(fontSize: 14),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  if (job['isRemote'] == true)
                    Row(
                      children: [
                        const Icon(Icons.wifi, size: 18, color: Colors.teal),
                        const SizedBox(width: 6),
                        const Text(
                          'Remote',
                          style: TextStyle(fontSize: 14),
                        ),
                      ],
                    ),
                ],
              ),

              const SizedBox(height: 24),

              /// Work Description
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Work Description',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                'This is a sample job description for demonstration purposes. '
                'Include key responsibilities, required skills, and any other '
                'important info here. You can replace this with actual data later.',
                style: TextStyle(fontSize: 14, color: Colors.black87),
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  /// Helper method to build action buttons
  Widget _buildActionButton(IconData icon, String label, VoidCallback onPressed) {
    return GestureDetector(
      onTap: onPressed,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.teal.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: Colors.teal, size: 20),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              color: Colors.teal,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}