import 'dart:async';
import 'package:flutter/material.dart';
import 'package:naka/screens/UserListScreen.dart';
import 'package:naka/widgets/JobCard.dart';
import 'package:naka/screens/SettingsScreen.dart';
import 'package:naka/screens/JobDetailsPage.dart';

class JobHomeScreen extends StatefulWidget {
  const JobHomeScreen({super.key});

  @override
  State<JobHomeScreen> createState() => _JobHomeScreenState();
}

class _JobHomeScreenState extends State<JobHomeScreen> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  final PageController _pageController = PageController();
  final TextEditingController _searchController = TextEditingController();
  int _currentPage = 0;
  late Timer _timer;
  String? _selectedCategory; // Track selected category
  String _searchQuery = ''; // Track search query

  final List<String> bannerImages = [
    'https://i.postimg.cc/zDLDCwp7/image2.jpg',
    'https://i.postimg.cc/3RRVHBWc/image1.png',
    'https://picsum.photos/200',
  ];

  @override
  void initState() {
    super.initState();
    _startAutoScroll();
  }

  void _startAutoScroll() {
    _timer = Timer.periodic(const Duration(seconds: 3), (Timer timer) {
      if (_currentPage < bannerImages.length - 1) {
        _currentPage++;
      } else {
        _currentPage = 0;
      }
      _pageController.animateToPage(
        _currentPage,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    _pageController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      drawer: Drawer(child: SettingsScreen()),
      body: Column(
        children: [
          // FIXED Search Bar
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
            child: Row(
              children: [
                GestureDetector(
                  onTap: () {
                    scaffoldKey.currentState?.openDrawer();
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: const Color(0xFF0D141C), width: 2),
                    ),
                    child: const CircleAvatar(
                      radius: 18,
                      backgroundColor: Color(0xFFFBE3C7),
                      backgroundImage: NetworkImage('https://i.postimg.cc/zDLDCwp7/image2.jpg'),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    onChanged: (value) {
                      setState(() {
                        _searchQuery = value.toLowerCase();
                      });
                    },
                    decoration: InputDecoration(
                      hintText: 'Search for jobs',
                      prefixIcon: const Icon(Icons.search, color: Color(0xFF0D141C)),
                      filled: true,
                      fillColor: const Color(0xFFE7EDF4),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                IconButton(
                  icon: Stack(
                    children: [
                      const Icon(Icons.chat, color: Color(0xFF0D141C), size: 30),
                      Positioned(
                        right: 0,
                        top: -5,
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: const BoxDecoration(
                            color: Colors.red,
                            shape: BoxShape.circle,
                          ),
                          child: const Text(
                            '3',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const UserListScreen()),
                    );
                  },
                ),
              ],
            ),
          ),

          // Expandable content
          Expanded(
            child: CustomScrollView(
              slivers: [
                // Collapsible Carousel Banner
                SliverAppBar(
                  expandedHeight: 140,
                  floating: true,
                  snap: true,
                  pinned: false,
                  backgroundColor: Colors.white,
                  elevation: 0,
                  automaticallyImplyLeading: false,
                  flexibleSpace: FlexibleSpaceBar(
                    background: PageView.builder(
                      controller: _pageController,
                      itemCount: bannerImages.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: JobCard(imageUrl: bannerImages[index]),
                        );
                      },
                    ),
                  ),
                ),

                // FIXED Categories
                SliverPersistentHeader(
                  pinned: true,
                  delegate: _CategoryHeaderDelegate(
                    onCategorySelected: (category) {
                      setState(() {
                        _selectedCategory = category;
                      });
                    },
                    selectedCategory: _selectedCategory,
                  ),
                ),

                // Scrollable Job Listings
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final filteredJobs = _jobListings.where((job) {
                        // Filter by search query
                        final title = job['title']!.toLowerCase();
                        final company = job['company']!.toLowerCase();
                        final location = job['location']!.toLowerCase();
                        
                        final matchesSearch = _searchQuery.isEmpty ||
                            title.contains(_searchQuery) ||
                            company.contains(_searchQuery) ||
                            location.contains(_searchQuery);
                        
                        // Filter by selected category
                        bool matchesCategory = true;
                        if (_selectedCategory != null) {
                          final category = _selectedCategory!.toLowerCase();
                          // Match common keywords
                          if (category == 'video' && !title.contains('video')) matchesCategory = false;
                          if (category == 'design' && !(title.contains('design') || title.contains('graphic') || title.contains('ui') || title.contains('ux'))) matchesCategory = false;
                          if (category == 'tech' && !(title.contains('developer') || title.contains('engineer') || title.contains('devops') || title.contains('system'))) matchesCategory = false;
                          if (category == 'market' && !(title.contains('marketing') || title.contains('specialist') || title.contains('analyst'))) matchesCategory = false;
                          if (category == 'finance' && !(title.contains('finance') || title.contains('accountant') || title.contains('analyst'))) matchesCategory = false;
                        }
                        
                        return matchesSearch && matchesCategory;
                      }).toList();

                      if (filteredJobs.isEmpty) {
                        return const Padding(
                          padding: EdgeInsets.all(16.0),
                          child: Text(
                            'No jobs found',
                            style: TextStyle(color: Colors.grey),
                          ),
                        );
                      }

                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 6.0),
                        child: _buildJobCard(
                          filteredJobs[index]['title']!,
                          filteredJobs[index]['company']!,
                          filteredJobs[index]['location']!,
                          filteredJobs[index]['type']!,
                          filteredJobs[index]['salary']!,
                        ),
                      );
                    },
                    childCount: _jobListings.where((job) {
                      // Filter by search query
                      final title = job['title']!.toLowerCase();
                      final company = job['company']!.toLowerCase();
                      final location = job['location']!.toLowerCase();
                      
                      final matchesSearch = _searchQuery.isEmpty ||
                          title.contains(_searchQuery) ||
                          company.contains(_searchQuery) ||
                          location.contains(_searchQuery);
                      
                      // Filter by selected category
                      bool matchesCategory = true;
                      if (_selectedCategory != null) {
                        final category = _selectedCategory!.toLowerCase();
                        // Match common keywords
                        if (category == 'video' && !title.contains('video')) matchesCategory = false;
                        if (category == 'design' && !(title.contains('design') || title.contains('graphic') || title.contains('ui') || title.contains('ux'))) matchesCategory = false;
                        if (category == 'tech' && !(title.contains('developer') || title.contains('engineer') || title.contains('devops') || title.contains('system'))) matchesCategory = false;
                        if (category == 'market' && !(title.contains('marketing') || title.contains('specialist') || title.contains('analyst'))) matchesCategory = false;
                        if (category == 'finance' && !(title.contains('finance') || title.contains('accountant') || title.contains('analyst'))) matchesCategory = false;
                      }
                      
                      return matchesSearch && matchesCategory;
                    }).length,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: SizedBox.shrink(),
    );
  }

  final List<Map<String, String>> _jobListings = [
    // VIDEO CATEGORY
    {'title': 'Senior Video Editor', 'company': 'CreativeStudio', 'location': 'New York, NY', 'type': 'Remote', 'salary': '\$70,000 - \$90,000'},
    {'title': 'Video Production Specialist', 'company': 'MediaCorp', 'location': 'Los Angeles, CA', 'type': 'On-site', 'salary': '\$65,000 - \$80,000'},
    {'title': 'Video Content Creator', 'company': 'FilmWorks', 'location': 'Toronto, ON', 'type': 'On-site', 'salary': '\$55,000 - \$75,000'},
    {'title': 'Video Animator', 'company': 'AnimationPro', 'location': 'Vancouver, BC', 'type': 'Hybrid', 'salary': '\$60,000 - \$80,000'},
    {'title': 'Video Editing Technician', 'company': 'MediaHub', 'location': 'Austin, TX', 'type': 'Remote', 'salary': '\$45,000 - \$65,000'},
    
    // DESIGN CATEGORY
    {'title': 'Graphic Designer', 'company': 'DesignHub', 'location': 'San Francisco, CA', 'type': 'Remote', 'salary': '\$55,000 - \$75,000'},
    {'title': 'UI/UX Designer', 'company': 'TechInnovate', 'location': 'Seattle, WA', 'type': 'Hybrid', 'salary': '\$60,000 - \$85,000'},
    {'title': 'Graphic Design Specialist', 'company': 'CreativeWorks', 'location': 'Brooklyn, NY', 'type': 'Remote', 'salary': '\$50,000 - \$70,000'},
    {'title': 'User Interface Designer', 'company': 'AppDesign', 'location': 'Berlin, Germany', 'type': 'Hybrid', 'salary': '\$65,000 - \$90,000'},
    {'title': 'Motion Graphics Designer', 'company': 'StudioX', 'location': 'Vancouver, BC', 'type': 'Hybrid', 'salary': '\$60,000 - \$80,000'},
    {'title': 'UX Research Designer', 'company': 'DesignLab', 'location': 'Chicago, IL', 'type': 'Remote', 'salary': '\$55,000 - \$80,000'},
    
    // TECH CATEGORY
    {'title': 'Web Developer', 'company': 'CodeWorks', 'location': 'Austin, TX', 'type': 'Remote', 'salary': '\$70,000 - \$95,000'},
    {'title': 'Backend Developer', 'company': 'ServerSide', 'location': 'Amsterdam, Netherlands', 'type': 'Remote', 'salary': '\$75,000 - \$105,000'},
    {'title': 'Frontend Developer', 'company': 'WebStudio', 'location': 'London, UK', 'type': 'Hybrid', 'salary': '\$70,000 - \$95,000'},
    {'title': 'Full Stack Developer', 'company': 'WebMasters', 'location': 'San Diego, CA', 'type': 'Hybrid', 'salary': '\$75,000 - \$105,000'},
    {'title': 'Software Engineer', 'company': 'TechCorp', 'location': 'Mountain View, CA', 'type': 'Remote', 'salary': '\$90,000 - \$130,000'},
    {'title': 'DevOps Engineer', 'company': 'CloudSystems', 'location': 'Denver, CO', 'type': 'Remote', 'salary': '\$75,000 - \$100,000'},
    {'title': 'QA Automation Tester', 'company': 'TestPro', 'location': 'Portland, OR', 'type': 'Remote', 'salary': '\$55,000 - \$75,000'},
    {'title': 'System Administrator', 'company': 'ITSolutions', 'location': 'Phoenix, AZ', 'type': 'Remote', 'salary': '\$55,000 - \$75,000'},
    {'title': 'Machine Learning Engineer', 'company': 'AI Innovations', 'location': 'Palo Alto, CA', 'type': 'On-site', 'salary': '\$100,000 - \$150,000'},
    {'title': 'Cloud Architect', 'company': 'CloudFirst', 'location': 'Singapore', 'type': 'Remote', 'salary': '\$95,000 - \$135,000'},
    {'title': 'Senior Software Developer', 'company': 'InnovateTech', 'location': 'Boston, MA', 'type': 'Hybrid', 'salary': '\$95,000 - \$125,000'},
    
    // MARKETING CATEGORY
    {'title': 'Marketing Specialist', 'company': 'BrandBoost', 'location': 'Dallas, TX', 'type': 'Hybrid', 'salary': '\$50,000 - \$70,000'},
    {'title': 'Marketing Manager', 'company': 'GlobalBrand', 'location': 'Paris, France', 'type': 'Hybrid', 'salary': '\$70,000 - \$100,000'},
    {'title': 'Social Media Specialist', 'company': 'DigitalMark', 'location': 'Los Angeles, CA', 'type': 'Remote', 'salary': '\$45,000 - \$65,000'},
    {'title': 'SEO Specialist', 'company': 'SearchGenius', 'location': 'Austin, TX', 'type': 'Remote', 'salary': '\$55,000 - \$75,000'},
    {'title': 'Brand Strategist', 'company': 'BrandLab', 'location': 'San Francisco, CA', 'type': 'On-site', 'salary': '\$70,000 - \$95,000'},
    {'title': 'Digital Marketing Analyst', 'company': 'MarketPro', 'location': 'New York, NY', 'type': 'Hybrid', 'salary': '\$55,000 - \$75,000'},
    {'title': 'Content Specialist', 'company': 'MediaPlus', 'location': 'Atlanta, GA', 'type': 'Remote', 'salary': '\$45,000 - \$65,000'},
    
    // FINANCE CATEGORY
    {'title': 'Finance Manager', 'company': 'Wealth&Co', 'location': 'Hong Kong', 'type': 'On-site', 'salary': '\$85,000 - \$120,000'},
    {'title': 'Accountant', 'company': 'NumbersFirst', 'location': 'Boston, MA', 'type': 'Hybrid', 'salary': '\$55,000 - \$75,000'},
    {'title': 'Financial Analyst', 'company': 'FinanceHub', 'location': 'New York, NY', 'type': 'On-site', 'salary': '\$65,000 - \$90,000'},
    {'title': 'Compliance Analyst', 'company': 'FinanceSecure', 'location': 'New York, NY', 'type': 'On-site', 'salary': '\$60,000 - \$80,000'},
    {'title': 'Finance Director', 'company': 'CapitalGroup', 'location': 'Toronto, ON', 'type': 'On-site', 'salary': '\$95,000 - \$130,000'},
    {'title': 'Investment Analyst', 'company': 'WealtTrack', 'location': 'Chicago, IL', 'type': 'Hybrid', 'salary': '\$70,000 - \$100,000'},
    
    // OTHER ROLES
    {'title': 'Product Manager', 'company': 'InnovateCo', 'location': 'Boston, MA', 'type': 'On-site', 'salary': '\$80,000 - \$110,000'},
    {'title': 'Data Scientist', 'company': 'DataDriven', 'location': 'Chicago, IL', 'type': 'Hybrid', 'salary': '\$85,000 - \$120,000'},
    {'title': 'Project Manager', 'company': 'BuildRight', 'location': 'Miami, FL', 'type': 'On-site', 'salary': '\$70,000 - \$95,000'},
    {'title': 'Business Analyst', 'company': 'ConsultPro', 'location': 'Washington, DC', 'type': 'On-site', 'salary': '\$65,000 - \$85,000'},
  ];

  Widget _buildJobCard(String title, String company, String location, String type, String salary) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => JobDetailsPage(
              job: {
                'title': title,
                'company': company,
                'location': location,
                'jobType': type,
                'salary': salary,
              },
            ),
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
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
            // Top row with company info and bookmark
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Company Avatar
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.purple.withOpacity(0.2),
                  ),
                  child: const Icon(Icons.business, color: Colors.purple, size: 30),
                ),
                const SizedBox(width: 12),
                // Company Info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF0D141C),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        company,
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
                // Bookmark icon
                Icon(
                  Icons.bookmark_outline,
                  color: Colors.grey[400],
                  size: 24,
                ),
              ],
            ),
            const SizedBox(height: 12),
            
            // Location and Type
            Row(
              children: [
                const Icon(Icons.location_on, size: 16, color: Colors.grey),
                const SizedBox(width: 4),
                Text(
                  location,
                  style: const TextStyle(fontSize: 13, color: Colors.grey),
                ),
                const SizedBox(width: 12),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: const Color(0xFF00A699).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    type,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Color(0xFF00A699),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            
            // Salary
            Text(
              'Salary: $salary',
              style: const TextStyle(
                fontSize: 14,
                color: Color(0xFF00A699),
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 16),
            
            // Action Buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // Chat Button
                Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: const Color(0xFF00A699).withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.chat_outlined,
                        color: Color(0xFF00A699),
                        size: 20,
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'Chat',
                      style: TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                  ],
                ),
                
                // Call Button
                Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: const Color(0xFF00A699).withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.call_outlined,
                        color: Color(0xFF00A699),
                        size: 20,
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'call',
                      style: TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                  ],
                ),
                
                // Apply Button
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF00A699),
                    padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    'Apply',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _CategoryHeaderDelegate extends SliverPersistentHeaderDelegate {
  final Function(String?) onCategorySelected;
  final String? selectedCategory;

  _CategoryHeaderDelegate({required this.onCategorySelected, this.selectedCategory});

  final List<Map<String, dynamic>> categories = [
    {
      'name': 'Video',
      'icon': Icons.videocam,
      'color': Colors.teal,
    },
    {
      'name': 'Design',
      'icon': Icons.brush,
      'color': Colors.orange,
    },
    {
      'name': 'Tech',
      'icon': Icons.computer,
      'color': Colors.blue,
    },
    {
      'name': 'Market',
      'icon': Icons.trending_up,
      'color': Colors.green,
    },
    {
      'name': 'Finance',
      'icon': Icons.attach_money,
      'color': Colors.purple,
    },
  ];

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 8),
      height: 68,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: () => onCategorySelected(null),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: selectedCategory == null
                          ? const Color(0xFF00A699).withOpacity(0.2)
                          : Colors.grey.withOpacity(0.1),
                    ),
                    child: Icon(
                      Icons.refresh,
                      color: selectedCategory == null
                          ? const Color(0xFF00A699)
                          : Colors.grey,
                      size: 22,
                    ),
                  ),
                  const SizedBox(height: 2),
                  const SizedBox(
                    width: 52,
                    child: Text(
                      'All',
                      style: TextStyle(fontSize: 9, color: Colors.grey),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            ...categories.map((category) {
              final isSelected = selectedCategory == category['name'];
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: GestureDetector(
                  onTap: () => onCategorySelected(category['name']),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: isSelected
                              ? (category['color'] as Color).withOpacity(0.2)
                              : Colors.grey.withOpacity(0.1),
                        ),
                        child: Icon(
                          category['icon'],
                          color: isSelected
                              ? category['color']
                              : Colors.grey,
                          size: 22,
                        ),
                      ),
                      const SizedBox(height: 2),
                      SizedBox(
                        width: 52,
                        child: Text(
                          category['name'],
                          style: TextStyle(
                            fontSize: 9,
                            color: isSelected ? category['color'] : Colors.grey,
                            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  @override
  double get maxExtent => 68;

  @override
  double get minExtent => 68;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return true;
  }
}
