import 'package:flutter/material.dart';
import 'package:naka/config/app_colors.dart';
import 'package:naka/providers/AppearanceProvider.dart';
import 'package:provider/provider.dart';

class ContractorDetailsPage extends StatelessWidget {
  final Map<String, dynamic> contractor;

  const ContractorDetailsPage({super.key, required this.contractor});

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
              'Contractor Details',
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
                  /// Company Logo & Contractor Name
                  Column(
                    children: [
                      CircleAvatar(
                        radius: 36,
                        backgroundColor: Colors.grey,
                        backgroundImage: NetworkImage(
                          contractor['logo'] ?? 'https://randomuser.me/api/portraits/women/32.jpg',
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        contractor['name'] ?? 'Unknown Contractor',
                        style: appearance.getTitleStyle().copyWith(
                          color: appearance.primaryColor,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        contractor['industry'] ?? 'Construction',
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
                            '${contractor['rating'] ?? '4.8'} (${contractor['reviews'] ?? '340'} reviews)',
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

                  /// Action Buttons (Call, Email, Collaborate)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildActionButton(Icons.phone, 'Call', () {
                        // Add call functionality
                      }, appearance),
                      _buildActionButton(Icons.email, 'Email', () {
                        // Add email functionality
                      }, appearance),
                      ElevatedButton(
                        onPressed: () {
                          // Add collaborate functionality
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: appearance.primaryColor,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 10,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: Text(
                          'Collaborate',
                          style: appearance.getBodyStyle().copyWith(
                            color: Colors.white,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  /// Office Location Map Placeholder
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

                  /// Contractor Details & Portfolio Tab
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
                        'Portfolio',
                        style: appearance.getBodyStyle().copyWith(
                          color: appearance.brightness == Brightness.dark
                              ? Colors.grey[400]
                              : Colors.grey,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  /// Contractor Details Section
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.location_on, size: 18, color: appearance.primaryColor),
                          const SizedBox(width: 6),
                          Expanded(
                            child: Text(
                              contractor['location'] ?? 'Mumbai, India',
                              style: appearance.getBodyStyle().copyWith(
                                color: appearance.brightness == Brightness.dark
                                    ? Colors.white
                                    : Colors.black87,
                              ),
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
                            '₹${contractor['budgetPerProject'] ?? '50,000'} avg/project',
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
                            '${contractor['yearsInBusiness'] ?? '8'} years in business',
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
                            '${contractor['projectsCompleted'] ?? '156'} projects completed',
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
                          Icon(Icons.people, size: 18, color: appearance.primaryColor),
                          const SizedBox(width: 6),
                          Text(
                            '${contractor['teamSize'] ?? '25'} team members',
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

                  /// Services Section
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Services Offered',
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
                    children: (contractor['services'] as List<String>? ?? ['Building Construction', 'Renovation', 'Project Management']).map((service) {
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
                          service,
                          style: appearance.getSmallStyle().copyWith(
                            color: appearance.primaryColor,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      );
                    }).toList(),
                  ),

                  const SizedBox(height: 24),

                  /// About Contractor
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'About Company',
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
                    contractor['about'] ?? 'Professional construction and contracting company with expertise in residential and commercial projects. '
                        'Committed to delivering quality work on time and within budget.',
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
