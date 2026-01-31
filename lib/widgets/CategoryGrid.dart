import 'package:flutter/material.dart';
import 'package:naka/screens/JobDetailsPage.dart';

class CategoryGrid extends StatefulWidget {
  const CategoryGrid({super.key});

  @override
  State<CategoryGrid> createState() => _CategoryGridState();
}

class _CategoryGridState extends State<CategoryGrid> {
  String? selectedCategory; // Track which category is selected

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> categories = [
      {
        'name': 'Video Editor',
        'icon': Icons.videocam,
        'jobs': '70 jobs open',
        'iconColor': Colors.teal,
        'bgColor': const Color(0xFFE6F7F5),
        'relatedJobs': [
          {
            'title': 'Senior Video Editor',
            'company': 'CreativeStudio',
            'location': 'New York, NY',
            'salary': '\$70,000 - \$90,000',
            'isRemote': true,
          },
          {
            'title': 'Video Production Specialist',
            'company': 'MediaCorp',
            'location': 'Los Angeles, CA',
            'salary': '\$65,000 - \$80,000',
            'isRemote': false,
          },
          {
            'title': 'Senior Video Editor',
            'company': 'CreativeStudio',
            'location': 'New York, NY',
            'salary': '\$70,000 - \$90,000',
            'isRemote': true,
          },
          {
            'title': 'Video Production Specialist',
            'company': 'MediaCorp',
            'location': 'Los Angeles, CA',
            'salary': '\$65,000 - \$80,000',
            'isRemote': false,
          },
        ],
      },
      {
        'name': 'Design',
        'icon': Icons.design_services,
        'jobs': '46 jobs open',
        'iconColor': Colors.teal,
        'bgColor': const Color(0xFFE6F7F5),
        'relatedJobs': [
          {
            'title': 'UI/UX Designer',
            'company': 'TechInnovate',
            'location': 'San Francisco, CA',
            'salary': '\$85,000 - \$110,000',
            'isRemote': true,
          },
          {
            'title': 'Graphic Designer',
            'company': 'CreativeWorks',
            'location': 'Austin, TX',
            'salary': '\$60,000 - \$75,000',
            'isRemote': false,
          },
          {
            'title': 'UI/UX Designer',
            'company': 'TechInnovate',
            'location': 'San Francisco, CA',
            'salary': '\$85,000 - \$110,000',
            'isRemote': true,
          },
          {
            'title': 'Graphic Designer',
            'company': 'CreativeWorks',
            'location': 'Austin, TX',
            'salary': '\$60,000 - \$75,000',
            'isRemote': false,
          },
        ],
      },
      {
        'name': 'Computer',
        'icon': Icons.computer,
        'jobs': '98 jobs open',
        'iconColor': Colors.teal,
        'bgColor': const Color(0xFFE6F7F5),
        'relatedJobs': [
          {
            'title': 'Software Developer',
            'company': 'TechGiant',
            'location': 'Seattle, WA',
            'salary': '\$90,000 - \$120,000',
            'isRemote': true,
          },
          {
            'title': 'IT Specialist',
            'company': 'DataCorp',
            'location': 'Boston, MA',
            'salary': '\$70,000 - \$85,000',
            'isRemote': false,
          },
          {
            'title': 'UI/UX Designer',
            'company': 'TechInnovate',
            'location': 'San Francisco, CA',
            'salary': '\$85,000 - \$110,000',
            'isRemote': true,
          },
          {
            'title': 'Graphic Designer',
            'company': 'CreativeWorks',
            'location': 'Austin, TX',
            'salary': '\$60,000 - \$75,000',
            'isRemote': false,
          },
        ],
      },
      {
        'name': 'Marketing',
        'icon': Icons.trending_up,
        'jobs': '55 jobs open',
        'iconColor': Colors.teal,
        'bgColor': const Color(0xFFE6F7F5),
        'relatedJobs': [
          {
            'title': 'Digital Marketing Specialist',
            'company': 'AdAgency',
            'location': 'Chicago, IL',
            'salary': '\$50,000 - \$70,000',
            'isRemote': true,
          },
          {
            'title': 'SEO Expert',
            'company': 'WebSolutions',
            'location': 'Austin, TX',
            'salary': '\$60,000 - \$80,000',
            'isRemote': false,
          },
          {
            'title': 'UI/UX Designer',
            'company': 'TechInnovate',
            'location': 'San Francisco, CA',
            'salary': '\$85,000 - \$110,000',
            'isRemote': true,
          },
          {
            'title': 'Graphic Designer',
            'company': 'CreativeWorks',
            'location': 'Austin, TX',
            'salary': '\$60,000 - \$75,000',
            'isRemote': false,
          },
        ],
      },
      {
        'name': 'Finance',
        'icon': Icons.attach_money,
        'jobs': '82 jobs open',
        'iconColor': Colors.teal,
        'bgColor': const Color(0xFFE6F7F5),
        'relatedJobs': [
          {
            'title': 'Financial Analyst',
            'company': 'FinanceCorp',
            'location': 'New York, NY',
            'salary': '\$75,000 - \$95,000',
            'isRemote': false,
          },
          {
            'title': 'Accountant',
            'company': 'AccountingFirm',
            'location': 'Los Angeles, CA',
            'salary': '\$60,000 - \$80,000',
            'isRemote': true,
          },
          {
            'title': 'UI/UX Designer',
            'company': 'TechInnovate',
            'location': 'San Francisco, CA',
            'salary': '\$85,000 - \$110,000',
            'isRemote': true,
          },
          {
            'title': 'Graphic Designer',
            'company': 'CreativeWorks',
            'location': 'Austin, TX',
            'salary': '\$60,000 - \$75,000',
            'isRemote': false,
          },
        ],
      },
      {
        'name': 'Operations',
        'icon': Icons.business_center,
        'jobs': '62 jobs open',
        'iconColor': Colors.teal,
        'bgColor': const Color(0xFFE6F7F5),
        'relatedJobs': [
          {
            'title': 'Operations Manager',
            'company': 'LogisticsCo',
            'location': 'Houston, TX',
            'salary': '\$80,000 - \$100,000',
            'isRemote': false,
          },
          {
            'title': 'Supply Chain Specialist',
            'company': 'RetailCorp',
            'location': 'San Francisco, CA',
            'salary': '\$70,000 - \$90,000',
            'isRemote': true,
          },
        ],
      },
    ];

    return Column(
      children: [
        // Fixed "Job Categories" Section
        Container(
          color: Colors.white, // Background color for sticky header
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Job Categories',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF0D141C),
                ),
              ),
              GestureDetector(
                onTap: () {
                  setState(() {
                    selectedCategory = null; // Reset selection
                  });
                },
                child: const Text(
                  'Reset Selection',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.teal,
                  ),
                ),
              ),
            ],
          ),
        ),
        // Job Categories Display
        SizedBox(
          height: 100, // Reduced for tighter layout like screenshot
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: categories.length,
            itemBuilder: (context, index) => GestureDetector(
              onTap: () {
                setState(() {
                  selectedCategory = categories[index]['name'];
                });
              },
              child: _buildCategoryItem(
                categories[index],
                isSelected: selectedCategory == categories[index]['name'],
              ),
            ),
          ),
        ),

        // Scrollable Job List
        Expanded(
          child: SingleChildScrollView(
            child: selectedCategory != null
                ? _buildJobsForCategory(
                    categories.firstWhere(
                      (category) => category['name'] == selectedCategory,
                    ),
                  )
                : const Center(
                    child: Text(
                      'Select a category to view jobs',
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                  ),
          ),
        ),
      ],
    );
  }

  // Build individual category item
  Widget _buildCategoryItem(
    Map<String, dynamic> category, {
    bool isSelected = false,
  }) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 12),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: category['bgColor'] ?? Colors.grey[200],
          ),
          child: Icon(
            category['icon'],
            color: category['iconColor'] ?? Colors.teal,
            size: 28,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          category['name'],
          style: TextStyle(
            fontSize: 13,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
            color: isSelected ? Colors.teal : const Color(0xFF6B7280),
          ),
        ),
        if (isSelected)
          Container(
            margin: const EdgeInsets.only(top: 4),
            height: 2,
            width: 24,
            decoration: BoxDecoration(
              color: Colors.teal,
              borderRadius: BorderRadius.circular(1),
            ),
          ),
      ],
    );
  }

Widget _buildJobsForCategory(Map<String, dynamic> category) {
  final List<Map<String, dynamic>> jobs = category['relatedJobs'];

  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const SizedBox(height: 24),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Text(
          '${category['name']} Jobs',
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Color(0xFF0D141C),
          ),
        ),
      ),
      const SizedBox(height: 12),
      ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: jobs.length,
        itemBuilder: (context, index) => GestureDetector(
          onTap: () {
            // Navigate to JobDetailsPage
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => JobDetailsPage(job: jobs[index]),
              ),
            );
          },
          child: Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Job Poster Image
                Row(
                  children: [
                    CircleAvatar(
                      radius: 24,
                      backgroundImage: NetworkImage(
                        jobs[index]['posterImage'] ??
                            'https://via.placeholder.com/150', // Placeholder image
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            jobs[index]['title'],
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF0D141C),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            jobs[index]['company'],
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[700],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Icon(Icons.bookmark_border, color: Colors.grey[600]),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Icon(Icons.location_on, size: 14, color: Colors.grey[600]),
                    const SizedBox(width: 4),
                    Text(
                      jobs[index]['location'],
                      style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                    ),
                    const SizedBox(width: 12),
                    if (jobs[index]['isRemote'])
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.teal.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: const Text(
                          'Remote',
                          style: TextStyle(
                            fontSize: 10,
                            color: Colors.teal,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  'Salary: ${jobs[index]['salary']}',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.teal,
                  ),
                ),
                const SizedBox(height: 16),
                // Action Buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildActionButton(Icons.chat, 'Chat', () {
                      // Add chat functionality
                    }),
                    _buildActionButton(Icons.phone, 'call', () {
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
              ],
            ),
          ),
        ),
      ),
    ],
  );
}

// Helper method to build action buttons
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
