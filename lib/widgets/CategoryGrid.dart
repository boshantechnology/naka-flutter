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
        padding: EdgeInsets.zero,
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
            margin: const EdgeInsets.symmetric(horizontal: 0.0, vertical: 2.0),
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(2),
              border: Border.all(
                color: Colors.grey[200]!,
                width: 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.08),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title, Company, and Like Button (No Image)
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            Colors.teal.withOpacity(0.4),
                            Colors.teal.withOpacity(0.1),
                          ],
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.teal.withOpacity(0.2),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.work,
                        color: Colors.teal,
                        size: 20,
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
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF0D141C),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            jobs[index]['company'],
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ),
                    InkWell(
                      onTap: () {},
                      borderRadius: BorderRadius.circular(8),
                      splashColor: Colors.red.withOpacity(0.3),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        child: Icon(
                          Icons.favorite_border,
                          color: Colors.red,
                          size: 19,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Icon(Icons.location_on, size: 14, color: Colors.grey[600]),
                    const SizedBox(width: 4),
                    Text(
                      jobs[index]['location'],
                      style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                // Divider
                Divider(
                  color: Colors.grey[200],
                  thickness: 1,
                  height: 1,
                ),
                const SizedBox(height: 12),
                // Social Actions Row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    InkWell(
                      onTap: () {},
                      borderRadius: BorderRadius.circular(8),
                      splashColor: Colors.teal.withOpacity(0.3),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.thumb_up_outlined, size: 18, color: Colors.grey),
                            const SizedBox(width: 3),
                            Text('0', style: TextStyle(fontSize: 9, color: Colors.grey[700])),
                          ],
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () {},
                      borderRadius: BorderRadius.circular(8),
                      splashColor: Colors.teal.withOpacity(0.3),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                        child: Icon(Icons.comment, size: 18, color: Colors.teal),
                      ),
                    ),
                    InkWell(
                      onTap: () {},
                      borderRadius: BorderRadius.circular(8),
                      splashColor: Colors.teal.withOpacity(0.3),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.share_outlined, size: 18, color: Colors.teal),
                            const SizedBox(width: 3),
                            Text('Share', style: TextStyle(fontSize: 9, color: Colors.grey[700])),
                          ],
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () {},
                      borderRadius: BorderRadius.circular(8),
                      splashColor: Colors.teal.withOpacity(0.3),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.chat_bubble_outline, size: 18, color: Colors.teal),
                            const SizedBox(width: 3),
                            Text('Chat', style: TextStyle(fontSize: 9, color: Colors.grey[700])),
                          ],
                        ),
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
}
