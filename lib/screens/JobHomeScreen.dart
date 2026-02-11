import 'dart:async';
import 'package:flutter/material.dart';
import 'package:naka/screens/UserListScreen.dart';
import 'package:naka/screens/WorkerDetailsPage.dart';
import 'package:naka/screens/JobDetailsPage.dart';
import 'package:naka/screens/ChatScreen.dart';
import 'package:naka/widgets/JobCard.dart';
import 'package:naka/providers/AppearanceProvider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:translator/translator.dart';

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
  String? _userRole; // Track user role (Worker/Contractor)

  final List<String> bannerImages = [
    'https://i.postimg.cc/zDLDCwp7/image2.jpg',
    'https://i.postimg.cc/3RRVHBWc/image1.png',
    'https://picsum.photos/200',
  ];

  @override
  void initState() {
    super.initState();
    _loadUserRole();
    // Delay the auto scroll to ensure PageView is built first
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _startAutoScroll();
    });
  }

  Future<void> _loadUserRole() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _userRole = prefs.getString('user_role') ?? 'Worker';
    });
  }

  void _startAutoScroll() {
    _timer = Timer.periodic(const Duration(seconds: 3), (Timer timer) {
      if (!mounted || !_pageController.hasClients) return;
      
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
    return Consumer<AppearanceProvider>(
      builder: (context, appearance, _) {
        return Scaffold(
          key: scaffoldKey,
          backgroundColor: appearance.brightness == Brightness.dark 
              ? const Color(0xFF1E1E1E)
              : const Color(0xFFDDD9CE),
          appBar: PreferredSize(
            preferredSize: const Size.fromHeight(70),
            child: Container(
              decoration: BoxDecoration(
                color: appearance.brightness == Brightness.dark
                    ? const Color(0xFF1E1E1E)
                    : Colors.white,
                border: Border(
                  bottom: BorderSide(
                    color: appearance.brightness == Brightness.dark
                        ? Colors.grey[800]!
                        : Colors.grey[200]!,
                    width: 0.5,
                  ),
                ),
              ),
              child: SafeArea(
                bottom: false,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 6.0),
                  child: Row(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: appearance.primaryColor.withValues(alpha: 0.3),
                            width: 1.5,
                          ),
                        ),
                        child: const CircleAvatar(
                          radius: 14,
                          backgroundColor: Color(0xFFFBE3C7),
                          child: Icon(Icons.person, color: Colors.brown),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Container(
                          height: 35,
                          decoration: BoxDecoration(
                            color: appearance.brightness == Brightness.dark
                                ? const Color(0xFF1A1A1A)
                                : Colors.white,
                            borderRadius: BorderRadius.circular(28),
                            border: Border.all(
                              color: appearance.brightness == Brightness.dark
                                  ? Colors.grey[500]!
                                  : Colors.grey[300]!,
                              width: 1.2,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.03),
                                blurRadius: 3,
                                offset: const Offset(0, 1),
                              ),
                            ],
                          ),
                          child: Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                child: Icon(
                                  Icons.search,
                                  color: appearance.brightness == Brightness.dark
                                      ? Colors.grey[500]
                                      : Colors.grey[500],
                                  size: 20,
                                ),
                              ),
                              Expanded(
                                child: TextField(
                                  controller: _searchController,
                                  onChanged: (value) {
                                    setState(() {
                                      _searchQuery = value.toLowerCase();
                                    });
                                  },
                                  decoration: InputDecoration(
                                    hintText: 'Search',
                                    hintStyle: TextStyle(
                                      color: appearance.brightness == Brightness.dark
                                          ? Colors.grey[500]
                                          : Colors.grey[500],
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                    ),
                                    border: InputBorder.none,
                                    contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
                                    isDense: false,
                                    suffixIcon: _searchController.text.isNotEmpty
                                        ? GestureDetector(
                                            onTap: () {
                                              _searchController.clear();
                                              setState(() {
                                                _searchQuery = '';
                                              });
                                            },
                                            child: Padding(
                                              padding: const EdgeInsets.only(right: 8),
                                              child: Icon(
                                                Icons.clear,
                                                color: Colors.black,
                                                size: 16,
                                              ),
                                            ),
                                          )
                                        : null,
                                  ),
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: appearance.brightness == Brightness.dark
                                        ? Colors.white
                                        : Colors.black,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      IconButton(
                        icon: Icon(
                          Icons.chat,
                          color: appearance.brightness == Brightness.dark
                              ? Colors.grey[400]
                              : Colors.grey[700],
                          size: 20,
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
              ),
            ),
          ),
          body: Column(
            children: [

              // Expandable content
              Expanded(
                child: CustomScrollView(
                  slivers: [
                    // Collapsible Carousel Banner
                    SliverAppBar(
                      expandedHeight: 90,
                      floating: true,
                      snap: true,
                      pinned: false,
                      backgroundColor: appearance.brightness == Brightness.dark 
                          ? const Color(0xFF1E1E1E)
                          : Colors.white,
                      elevation: 0,
                      automaticallyImplyLeading: false,
                      flexibleSpace: FlexibleSpaceBar(
                        background: PageView.builder(
                          controller: _pageController,
                          itemCount: bannerImages.length,
                          itemBuilder: (context, index) {
                            return JobCard(imageUrl: bannerImages[index]);
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
                        appearance: appearance,
                      ),
                    ),

                    // Scrollable Job Listings
                    SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          // Show different content based on user role
                          if (_userRole == 'Worker') {
                            // WORKER - Show Job Posts
                            final filteredJobs = _contractorJobs.where((job) {
                              final jobTitle = job['title']!.toLowerCase();
                              final location = job['location']!.toLowerCase();
                              
                              final matchesSearch = _searchQuery.isEmpty ||
                                  jobTitle.contains(_searchQuery) ||
                                  location.contains(_searchQuery);
                              
                              return matchesSearch;
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

                            return GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => JobDetailsPage(job: filteredJobs[index]),
                                  ),
                                );
                              },
                              child: _ContractorJobCard(
                                job: filteredJobs[index],
                                appearance: appearance,
                              ),
                            );
                          } else {
                            // CONTRACTOR - Show Worker Cards
                            final filteredWorkers = _jobListings.where((worker) {
                              final workerName = worker['workerName']!.toLowerCase();
                              final workerType = worker['workerType']!.toLowerCase();
                              final skills = worker['skills']!.toLowerCase();
                              
                              final matchesSearch = _searchQuery.isEmpty ||
                                  workerName.contains(_searchQuery) ||
                                  workerType.contains(_searchQuery) ||
                                  skills.contains(_searchQuery);
                              
                              // Filter by selected category
                              bool matchesCategory = true;
                              if (_selectedCategory != null) {
                                matchesCategory = worker['workerType'] == _selectedCategory;
                              }
                              
                              return matchesSearch && matchesCategory;
                            }).toList();

                            if (filteredWorkers.isEmpty) {
                              return const Padding(
                                padding: EdgeInsets.all(16.0),
                                child: Text(
                                  'No workers found',
                                  style: TextStyle(color: Colors.grey),
                                ),
                              );
                            }

                            return Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 0.0, vertical: 0.1),
                              child: _buildWorkerCard(
                                filteredWorkers[index],
                                appearance,
                              ),
                            );
                          }
                        },
                        childCount: _userRole == 'Worker'
                            ? _contractorJobs.where((job) {
                                final jobTitle = job['title']!.toLowerCase();
                                final location = job['location']!.toLowerCase();
                                return _searchQuery.isEmpty ||
                                    jobTitle.contains(_searchQuery) ||
                                    location.contains(_searchQuery);
                              }).length
                            : _jobListings.where((worker) {
                                final workerName = worker['workerName']!.toLowerCase();
                                final workerType = worker['workerType']!.toLowerCase();
                                final skills = worker['skills']!.toLowerCase();
                                
                                final matchesSearch = _searchQuery.isEmpty ||
                                    workerName.contains(_searchQuery) ||
                                    workerType.contains(_searchQuery) ||
                                    skills.contains(_searchQuery);
                                
                                bool matchesCategory = true;
                                if (_selectedCategory != null) {
                                  matchesCategory = worker['workerType'] == _selectedCategory;
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
      },
    );
  }

  final List<Map<String, dynamic>> _jobListings = [
    // CARPENTER
    {'workerName': 'Rajesh Kumar', 'workerType': 'Carpenter', 'dailyRate': 600, 'halfDayRate': 350, 'hourlyRate': 100, 'rating': 4.8, 'reviewCount': 127, 'skills': 'Wood, Furniture, Doors', 'location': 'Andheri West', 'distance': '2 km', 'availability': 'Available Today'},
    {'workerName': 'Vikram Singh', 'workerType': 'Carpenter', 'dailyRate': 550, 'halfDayRate': 320, 'hourlyRate': 90, 'rating': 4.6, 'reviewCount': 95, 'skills': 'Woodwork, Repairs, Cabinets', 'location': 'Bandra', 'distance': '3.5 km', 'availability': 'Free Tomorrow'},
    {'workerName': 'Arjun Patel', 'workerType': 'Carpenter', 'dailyRate': 650, 'halfDayRate': 380, 'hourlyRate': 110, 'rating': 4.9, 'reviewCount': 152, 'skills': 'Custom Furniture, Installation', 'location': 'Dadar', 'distance': '1.5 km', 'availability': 'Available Today'},
    
    // PLUMBER
    {'workerName': 'Rohit Sharma', 'workerType': 'Plumber', 'dailyRate': 500, 'halfDayRate': 300, 'hourlyRate': 80, 'rating': 4.7, 'reviewCount': 110, 'skills': 'Pipe Fitting, Repairs, Installation', 'location': 'Navi Mumbai', 'distance': '5 km', 'availability': 'Available Today'},
    {'workerName': 'Manoj Kumar', 'workerType': 'Plumber', 'dailyRate': 450, 'halfDayRate': 270, 'hourlyRate': 75, 'rating': 4.5, 'reviewCount': 85, 'skills': 'Drainage, Water System, Repairs', 'location': 'Thane', 'distance': '8 km', 'availability': 'Free Tomorrow'},
    {'workerName': 'Sandeep Yadav', 'workerType': 'Plumber', 'dailyRate': 550, 'halfDayRate': 320, 'hourlyRate': 85, 'rating': 4.8, 'reviewCount': 130, 'skills': 'Pipe Work, Leakage, Installation', 'location': 'Powai', 'distance': '4 km', 'availability': 'Available Today'},
    
    // TAILOR
    {'workerName': 'Priya Sharma', 'workerType': 'Tailor', 'dailyRate': 400, 'halfDayRate': 240, 'hourlyRate': 70, 'rating': 4.9, 'reviewCount': 165, 'skills': 'Stitching, Alterations, Designs', 'location': 'Fort', 'distance': '2.8 km', 'availability': 'Available Today'},
    {'workerName': 'Anjali Verma', 'workerType': 'Tailor', 'dailyRate': 350, 'halfDayRate': 210, 'hourlyRate': 60, 'rating': 4.6, 'reviewCount': 98, 'skills': 'Embroidery, Alterations, Stitching', 'location': 'Colaba', 'distance': '6 km', 'availability': 'Free Tomorrow'},
    {'workerName': 'Neha Singh', 'workerType': 'Tailor', 'dailyRate': 450, 'halfDayRate': 270, 'hourlyRate': 75, 'rating': 4.7, 'reviewCount': 120, 'skills': 'Custom Designs, Wedding Clothes', 'location': 'Worli', 'distance': '1.2 km', 'availability': 'Available Today'},
    
    // MASON
    {'workerName': 'Pradeep Singh', 'workerType': 'Mason', 'dailyRate': 700, 'halfDayRate': 420, 'hourlyRate': 120, 'rating': 4.7, 'reviewCount': 142, 'skills': 'Brick Laying, Tiling, Concrete', 'location': 'Mulund', 'distance': '4.5 km', 'availability': 'Available Today'},
    {'workerName': 'Mohit Yadav', 'workerType': 'Mason', 'dailyRate': 650, 'halfDayRate': 390, 'hourlyRate': 110, 'rating': 4.5, 'reviewCount': 98, 'skills': 'Wall Construction, Plastering', 'location': 'Kanjurmarg', 'distance': '6 km', 'availability': 'Free Tomorrow'},
    {'workerName': 'Ramesh Kumar', 'workerType': 'Mason', 'dailyRate': 750, 'halfDayRate': 450, 'hourlyRate': 130, 'rating': 4.8, 'reviewCount': 167, 'skills': 'Tile Work, Flooring, Finishing', 'location': 'Ghatkopar', 'distance': '3.8 km', 'availability': 'Available Today'},
    
    // FACTORY WORKER
    {'workerName': 'Suresh Patel', 'workerType': 'Factory Worker', 'dailyRate': 550, 'halfDayRate': 330, 'hourlyRate': 95, 'rating': 4.4, 'reviewCount': 67, 'skills': 'Assembly, Packing, Quality Check', 'location': 'MIDC', 'distance': '12 km', 'availability': 'Available Today'},
    {'workerName': 'Dinesh Kumar', 'workerType': 'Factory Worker', 'dailyRate': 500, 'halfDayRate': 300, 'hourlyRate': 85, 'rating': 4.5, 'reviewCount': 72, 'skills': 'Machine Operation, Assembly', 'location': 'Wadala', 'distance': '9 km', 'availability': 'Free Tomorrow'},
    {'workerName': 'Harsh Mishra', 'workerType': 'Factory Worker', 'dailyRate': 600, 'halfDayRate': 360, 'hourlyRate': 105, 'rating': 4.6, 'reviewCount': 88, 'skills': 'Quality Control, Packaging', 'location': 'Mahape', 'distance': '15 km', 'availability': 'Available Today'},
    
    // KITCHEN HELPER
    {'workerName': 'Meena Devi', 'workerType': 'Kitchen Helper', 'dailyRate': 350, 'halfDayRate': 210, 'hourlyRate': 60, 'rating': 4.8, 'reviewCount': 145, 'skills': 'Cooking, Cleaning, Food Prep', 'location': 'Mahim', 'distance': '3.2 km', 'availability': 'Available Today'},
    {'workerName': 'Lakshmi Sharma', 'workerType': 'Kitchen Helper', 'dailyRate': 300, 'halfDayRate': 180, 'hourlyRate': 50, 'rating': 4.5, 'reviewCount': 92, 'skills': 'Meal Prep, Kitchen Cleaning', 'location': 'Kala Ghoda', 'distance': '5.5 km', 'availability': 'Free Tomorrow'},
    {'workerName': 'Ritu Verma', 'workerType': 'Kitchen Helper', 'dailyRate': 400, 'halfDayRate': 240, 'hourlyRate': 70, 'rating': 4.7, 'reviewCount': 118, 'skills': 'Cooking, Catering, Food Safety', 'location': 'Borivali', 'distance': '11 km', 'availability': 'Available Today'},
    
    // MESSENGER
    {'workerName': 'Arun Singh', 'workerType': 'Messenger', 'dailyRate': 400, 'halfDayRate': 240, 'hourlyRate': 65, 'rating': 4.6, 'reviewCount': 103, 'skills': 'Delivery, Document Handling', 'location': 'Fort', 'distance': '1 km', 'availability': 'Available Today'},
    {'workerName': 'Akshay Rao', 'workerType': 'Messenger', 'dailyRate': 350, 'halfDayRate': 210, 'hourlyRate': 55, 'rating': 4.4, 'reviewCount': 78, 'skills': 'Quick Delivery, Reliable', 'location': 'CST', 'distance': '2.2 km', 'availability': 'Free Tomorrow'},
    {'workerName': 'Nikhil Desai', 'workerType': 'Messenger', 'dailyRate': 450, 'halfDayRate': 270, 'hourlyRate': 75, 'rating': 4.7, 'reviewCount': 125, 'skills': 'Courier, Document Management', 'location': 'VT', 'distance': '0.8 km', 'availability': 'Available Today'},
  ];

  final List<Map<String, dynamic>> _contractorJobs = [
    // CONTRACTOR JOB POSTS
    {'title': 'Need Carpenter for Kitchen Renovation', 'company': 'Sharma Household', 'location': 'Andheri West', 'salary': '₹5,000 - ₹8,000', 'isRemote': false, 'posterImage': 'https://via.placeholder.com/150', 'imageUrl': 'https://i.postimg.cc/zDLDCwp7/image2.jpg', 'description': 'Looking for experienced carpenter for kitchen cabinet installation and design', 'workersNeeded': 2, 'daysRequired': 5, 'postedDate': '2 days ago'},
    {'title': 'Plumbing Work - New Apartment', 'company': 'Patel Construction', 'location': 'Bandra', 'salary': '₹6,000 - ₹9,000', 'isRemote': false, 'posterImage': 'https://via.placeholder.com/150', 'imageUrl': 'https://i.postimg.cc/3RRVHBWc/image1.png', 'description': 'Complete plumbing setup needed for 2BHK apartment, including water connections and fixtures', 'workersNeeded': 3, 'daysRequired': 4, 'postedDate': '1 day ago'},
    {'title': 'Interior Design - Home Makeover', 'company': 'Design Studio Mumbai', 'location': 'Worli', 'salary': '₹10,000 - ₹15,000', 'isRemote': false, 'posterImage': 'https://via.placeholder.com/150', 'description': 'Modern interior design and renovation for residential space', 'workersNeeded': 5, 'daysRequired': 10, 'postedDate': '3 days ago'},
    {'title': 'Electrical Installation', 'company': 'BuildRight Solutions', 'location': 'Powai', 'salary': '₹7,000 - ₹10,000', 'isRemote': false, 'posterImage': 'https://via.placeholder.com/150', 'description': 'Complete electrical wiring and installation for commercial space', 'workersNeeded': 4, 'daysRequired': 6, 'postedDate': '4 days ago'},
    {'title': 'Tile and Flooring Work', 'company': 'Home Builders Inc', 'location': 'Thane', 'salary': '₹8,000 - ₹12,000', 'isRemote': false, 'posterImage': 'https://via.placeholder.com/150', 'imageUrl': 'https://picsum.photos/400/300?random=1', 'description': 'High-quality tile laying and floor finishing for villa construction', 'workersNeeded': 6, 'daysRequired': 7, 'postedDate': '1 day ago'},
    {'title': 'Painting and Finishing', 'company': 'Quality Painters Ltd', 'location': 'Navi Mumbai', 'salary': '₹4,000 - ₹6,000', 'isRemote': false, 'posterImage': 'https://via.placeholder.com/150', 'description': 'Interior and exterior painting with premium finishes', 'workersNeeded': 3, 'daysRequired': 3, 'postedDate': '5 days ago'},
  ];

  Widget _buildWorkerCard(Map<String, dynamic> worker, AppearanceProvider appearance) {
    return _WorkerCard(
      worker: worker,
      appearance: appearance,
      onTap: () {
        // Navigate to worker details
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => WorkerDetailsPage(worker: worker),
          ),
        );
      },
    );
  }
}

class _ContractorJobCard extends StatefulWidget {
  final Map<String, dynamic> job;
  final AppearanceProvider appearance;

  const _ContractorJobCard({
    required this.job,
    required this.appearance,
  });

  @override
  State<_ContractorJobCard> createState() => _ContractorJobCardState();
}

class _ContractorJobCardState extends State<_ContractorJobCard> {
  bool isFavorite = false;
  int commentCount = 12;
  final TextEditingController _commentController = TextEditingController();
  List<String> comments = ['अच्छा काम है!', 'मुझे यह काम दिलचस्प लगता है'];
  final FlutterTts flutterTts = FlutterTts();
  bool isPlayingAudio = false;
  bool isTranslated = false;
  bool isTranslating = false;
  late Map<String, String> translatedJob;
  final GoogleTranslator translator = GoogleTranslator();

  @override
  void initState() {
    super.initState();
    _checkIfFavorite();
    _initTts();
  }

  Future<void> _initTts() async {
    await flutterTts.setLanguage('en-IN');
    await flutterTts.setSpeechRate(0.85);
  }

  Future<void> _speakJobInfo() async {
    String text = '''
    Job Title: ${widget.job['title']}.
    Posted by: ${widget.job['company']}.
    Location: ${widget.job['location']}.
    Salary: ${widget.job['salary']}.
    Number of workers needed: ${widget.job['workersNeeded']}.
    Duration: ${widget.job['daysRequired']} days.
    Description: ${widget.job['description']}.
    ''';

    setState(() {
      isPlayingAudio = true;
    });

    await flutterTts.speak(text);
    
    flutterTts.setCompletionHandler(() {
      setState(() {
        isPlayingAudio = false;
      });
    });
  }

  Future<void> _stopAudio() async {
    await flutterTts.stop();
    setState(() {
      isPlayingAudio = false;
    });
  }

  Future<void> _toggleTranslation() async {
    if (isTranslated) {
      // Switch back to original
      setState(() {
        isTranslated = false;
      });
    } else {
      // Translate to Hindi
      setState(() {
        isTranslating = true;
      });

      try {
        String title = widget.job['title'] ?? '';
        String company = widget.job['company'] ?? '';
        String location = widget.job['location'] ?? '';
        String description = widget.job['description'] ?? '';

        // Translate to Hindi
        var translatedTitle = await translator.translate(title, from: 'en', to: 'hi');
        var translatedCompany = await translator.translate(company, from: 'en', to: 'hi');
        var translatedLocation = await translator.translate(location, from: 'en', to: 'hi');
        var translatedDescription = await translator.translate(description, from: 'en', to: 'hi');

        setState(() {
          translatedJob = {
            'title': translatedTitle.toString(),
            'company': translatedCompany.toString(),
            'location': translatedLocation.toString(),
            'description': translatedDescription.toString(),
          };
          isTranslated = true;
          isTranslating = false;
        });
      } catch (e) {
        setState(() {
          isTranslating = false;
        });
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Translation error: $e')),
          );
        }
      }
    }
  }

  @override
  void dispose() {
    _commentController.dispose();
    flutterTts.stop();
    super.dispose();
  }

  Future<void> _checkIfFavorite() async {
    final prefs = await SharedPreferences.getInstance();
    final favorites = prefs.getStringList('favorite_jobs') ?? [];
    if (mounted) {
      setState(() {
        isFavorite = favorites.contains(widget.job['title']);
      });
    }
  }

  Future<void> _toggleFavorite() async {
    final prefs = await SharedPreferences.getInstance();
    final favorites = prefs.getStringList('favorite_jobs') ?? [];

    final jobTitle = widget.job['title'] as String;
    bool isAdded = false;

    setState(() {
      if (isFavorite) {
        favorites.remove(jobTitle);
      } else {
        favorites.add(jobTitle);
        isAdded = true;
      }
      isFavorite = !isFavorite;
    });

    await prefs.setStringList('favorite_jobs', favorites);

    if (mounted) {
      _showProfessionalNotification(
        context,
        isAdded ? 'Added to Favorites' : 'Removed from Favorites',
        jobTitle,
        isAdded,
      );
    }
  }

  void _showProfessionalNotification(
    BuildContext context,
    String title,
    String jobTitle,
    bool isAdded,
  ) {
    final overlay = Overlay.of(context);
    late OverlayEntry overlayEntry;

    overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        bottom: 80,
        left: 16,
        right: 16,
        child: Material(
          color: Colors.transparent,
          child: TweenAnimationBuilder<double>(
            tween: Tween(begin: 0.0, end: 1.0),
            duration: const Duration(milliseconds: 400),
            builder: (context, value, child) {
              return Transform.translate(
                offset: Offset(0, 20 * (1 - value)),
                child: Opacity(
                  opacity: value,
                  child: child,
                ),
              );
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: Colors.grey[300]!,
                  width: 1,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Icon(
                    isAdded ? Icons.favorite : Icons.favorite_outline,
                    color: Colors.red,
                    size: 18,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      '$title • $jobTitle',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );

    overlay.insert(overlayEntry);

    Future.delayed(const Duration(seconds: 2), () {
      if (overlayEntry.mounted) {
        overlayEntry.remove();
      }
    });
  }

  void _editComment(int index) {
    _commentController.text = comments[index];
    showModalBottomSheet(
      context: context,
      backgroundColor: widget.appearance.brightness == Brightness.dark
          ? const Color(0xFF2A2A2A)
          : Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      isScrollControlled: true,
      builder: (context) => Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: widget.appearance.brightness == Brightness.dark
                        ? Colors.grey[600]
                        : Colors.grey[300],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Edit Comment',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: widget.appearance.brightness == Brightness.dark
                      ? Colors.white
                      : Colors.black,
                ),
              ),
              const SizedBox(height: 16),
              Container(
                decoration: BoxDecoration(
                  color: widget.appearance.brightness == Brightness.dark
                      ? const Color(0xFF1E1E1E)
                      : Colors.grey[100],
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: widget.appearance.brightness == Brightness.dark
                        ? Colors.grey[700]!
                        : Colors.grey[300]!,
                    width: 1,
                  ),
                ),
                child: TextField(
                  controller: _commentController,
                  maxLines: 3,
                  decoration: InputDecoration(
                    hintText: 'Edit your comment...',
                    hintStyle: TextStyle(
                      color: widget.appearance.brightness == Brightness.dark
                          ? Colors.grey[600]
                          : Colors.grey,
                    ),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.all(12),
                  ),
                  style: TextStyle(
                    color: widget.appearance.brightness == Brightness.dark
                        ? Colors.white
                        : Colors.black,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => Navigator.pop(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey[400],
                      ),
                      child: const Text(
                        'Cancel',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        if (_commentController.text.isNotEmpty) {
                          setState(() {
                            comments[index] = _commentController.text;
                          });
                          _commentController.clear();
                          Navigator.pop(context);
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: widget.appearance.primaryColor,
                      ),
                      child: const Text(
                        'Update',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _deleteComment(int index) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: widget.appearance.brightness == Brightness.dark
            ? const Color(0xFF2A2A2A)
            : Colors.white,
        title: Text(
          'Delete Comment',
          style: TextStyle(
            color: widget.appearance.brightness == Brightness.dark
                ? Colors.white
                : Colors.black,
          ),
        ),
        content: Text(
          'Are you sure you want to delete this comment?',
          style: TextStyle(
            color: widget.appearance.brightness == Brightness.dark
                ? Colors.white70
                : Colors.black87,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'No',
              style: TextStyle(color: widget.appearance.primaryColor),
            ),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                comments.removeAt(index);
                commentCount--;
              });
              Navigator.pop(context);
            },
            child: const Text('Yes', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void _showCommentDialog() {
    showModalBottomSheet(
      context: context,
      backgroundColor: widget.appearance.brightness == Brightness.dark
          ? const Color(0xFF2A2A2A)
          : Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      isScrollControlled: true,
      builder: (context) => Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Handle bar
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: widget.appearance.brightness == Brightness.dark
                          ? Colors.grey[600]
                          : Colors.grey[300],
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'Comments ($commentCount)',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: widget.appearance.brightness == Brightness.dark
                        ? Colors.white
                        : Colors.black,
                  ),
                ),
                const SizedBox(height: 16),
                
                // Comments list - LinkedIn style
                ...comments.asMap().entries.map((entry) {
                  final index = entry.key;
                  final comment = entry.value;
                  final daysAgo = index == 0 ? '2d' : index == 1 ? '1d' : '3d';
                  
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Profile picture
                        Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                widget.appearance.primaryColor.withValues(alpha: 0.6),
                                widget.appearance.primaryColor.withValues(alpha: 0.2),
                              ],
                            ),
                          ),
                          child: Icon(
                            Icons.person,
                            color: widget.appearance.primaryColor,
                            size: 20,
                          ),
                        ),
                        const SizedBox(width: 12),
                        
                        // Comment content
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Username and time with 3-dot menu
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'User ${index + 1}',
                                          style: TextStyle(
                                            fontSize: 13,
                                            fontWeight: FontWeight.w600,
                                            color: widget.appearance.brightness == Brightness.dark
                                                ? Colors.white
                                                : Colors.black,
                                          ),
                                        ),
                                        const SizedBox(height: 2),
                                        Text(
                                          'Job Seeker',
                                          style: TextStyle(
                                            fontSize: 11,
                                            color: widget.appearance.brightness == Brightness.dark
                                                ? Colors.grey[400]
                                                : Colors.grey[600],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Text(
                                        daysAgo,
                                        style: TextStyle(
                                          fontSize: 11,
                                          color: widget.appearance.brightness == Brightness.dark
                                              ? Colors.grey[500]
                                              : Colors.grey[500],
                                        ),
                                      ),
                                      const SizedBox(height: 2),
                                      PopupMenuButton<String>(
                                        itemBuilder: (BuildContext context) => [
                                          PopupMenuItem<String>(
                                            value: 'edit',
                                            child: Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Icon(Icons.edit, size: 16, color: widget.appearance.primaryColor),
                                                const SizedBox(width: 8),
                                                const Text('Edit'),
                                              ],
                                            ),
                                          ),
                                          PopupMenuItem<String>(
                                            value: 'delete',
                                            child: Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Icon(Icons.delete, size: 16, color: Colors.red),
                                                const SizedBox(width: 8),
                                                const Text('Delete', style: TextStyle(color: Colors.red)),
                                              ],
                                            ),
                                          ),
                                        ],
                                        onSelected: (value) {
                                          if (value == 'edit') {
                                            _editComment(index);
                                          } else if (value == 'delete') {
                                            _deleteComment(index);
                                          }
                                        },
                                        icon: Icon(
                                          Icons.more_vert,
                                          size: 16,
                                          color: widget.appearance.brightness == Brightness.dark
                                              ? Colors.grey[500]
                                              : Colors.grey[500],
                                        ),
                                        offset: const Offset(0, 24),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(8),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              
                              // Comment text
                              Text(
                                comment,
                                style: TextStyle(
                                  fontSize: 13,
                                  color: widget.appearance.brightness == Brightness.dark
                                      ? Colors.white70
                                      : Colors.black87,
                                  height: 1.4,
                                ),
                              ),
                              const SizedBox(height: 8),
                              
                              // Like and Reply buttons
                              Row(
                                children: [
                                  Text(
                                    'Like',
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                      color: widget.appearance.brightness == Brightness.dark
                                          ? Colors.grey[400]
                                          : Colors.grey[600],
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  Text(
                                    'Reply',
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                      color: widget.appearance.brightness == Brightness.dark
                                          ? Colors.grey[400]
                                          : Colors.grey[600],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                }),
                const SizedBox(height: 20),
                
                // Divider
                Divider(
                  color: widget.appearance.brightness == Brightness.dark
                      ? Colors.grey[700]
                      : Colors.grey[200],
                ),
                const SizedBox(height: 12),
                
                // Input field - Add comment
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    // User avatar
                    Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            widget.appearance.primaryColor.withValues(alpha: 0.6),
                            widget.appearance.primaryColor.withValues(alpha: 0.2),
                          ],
                        ),
                      ),
                      child: Icon(
                        Icons.person,
                        color: widget.appearance.primaryColor,
                        size: 18,
                      ),
                    ),
                    const SizedBox(width: 10),
                    
                    // Input field
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          color: widget.appearance.brightness == Brightness.dark
                              ? const Color(0xFF1E1E1E)
                              : Colors.grey[100],
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: widget.appearance.brightness == Brightness.dark
                                ? Colors.grey[700]!
                                : Colors.grey[300]!,
                            width: 1,
                          ),
                        ),
                        child: TextField(
                          controller: _commentController,
                          maxLines: 1,
                          decoration: InputDecoration(
                            hintText: 'Write a comment...',
                            hintStyle: TextStyle(
                              color: widget.appearance.brightness == Brightness.dark
                                  ? Colors.grey[600]
                                  : Colors.grey,
                              fontSize: 13,
                            ),
                            border: InputBorder.none,
                            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                          ),
                          style: TextStyle(
                            color: widget.appearance.brightness == Brightness.dark
                                ? Colors.white
                                : Colors.black,
                            fontSize: 13,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    
                    // Post button
                    GestureDetector(
                      onTap: () {
                        if (_commentController.text.isNotEmpty) {
                          setState(() {
                            comments.add(_commentController.text);
                            commentCount++;
                          });
                          _commentController.clear();
                          Navigator.pop(context);
                        }
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                        decoration: BoxDecoration(
                          color: widget.appearance.primaryColor,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Text(
                          'Post',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => JobDetailsPage(job: widget.job),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 0.0, vertical: 2.0),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: widget.appearance.brightness == Brightness.dark
              ? const Color(0xFF2A2A2A)
              : Colors.white,
        borderRadius: BorderRadius.circular(2),
        border: Border.all(
          color: widget.appearance.brightness == Brightness.dark
              ? Colors.grey[800]!
              : Colors.grey[200]!,
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Job Title and Company - TOP POSITION
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
                      widget.appearance.primaryColor.withValues(alpha: 0.4),
                      widget.appearance.primaryColor.withValues(alpha: 0.1),
                    ],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: widget.appearance.primaryColor.withValues(alpha: 0.2),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Icon(
                  Icons.work,
                  color: widget.appearance.primaryColor,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            isTranslated && translatedJob.isNotEmpty
                                ? translatedJob['title'] ?? widget.job['title']
                                : widget.job['title'] as String,
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                              color: widget.appearance.brightness == Brightness.dark
                                  ? Colors.white
                                  : Colors.black87,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(width: 8),
                        GestureDetector(
                          onTap: _toggleFavorite,
                          child: Container(
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              color: isFavorite
                                  ? Colors.red.withValues(alpha: 0.15)
                                  : Colors.grey[200],
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Icon(
                              isFavorite ? Icons.favorite : Icons.favorite_outline,
                              color: isFavorite ? Colors.red : Colors.grey,
                              size: 18,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      isTranslated && translatedJob.isNotEmpty
                          ? translatedJob['company'] ?? widget.job['company']
                          : widget.job['company'] as String,
                      style: TextStyle(
                        fontSize: 13,
                        color: widget.appearance.brightness == Brightness.dark
                            ? Colors.grey[400]
                            : Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Dummy/User Uploaded Image (Optional)
          if (widget.job['imageUrl'] != null && (widget.job['imageUrl'] as String).isNotEmpty)
            Column(
              children: [
                Container(
                  width: double.infinity,
                  height: 150,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: widget.appearance.brightness == Brightness.dark
                        ? Colors.grey[800]
                        : Colors.grey[200],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      widget.job['imageUrl'] as String,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          color: widget.appearance.primaryColor.withValues(alpha: 0.2),
                          child: Icon(
                            Icons.work,
                            size: 64,
                            color: widget.appearance.primaryColor.withValues(alpha: 0.5),
                          ),
                        );
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 12),
              ],
            ),

          // Location and Salary
          Row(
            children: [
              Icon(Icons.location_on, size: 14, color: widget.appearance.primaryColor),
              const SizedBox(width: 4),
              Text(
                widget.job['location'] as String,
                style: TextStyle(
                  fontSize: 12,
                  color: widget.appearance.brightness == Brightness.dark
                      ? Colors.grey[300]
                      : Colors.grey[600],
                ),
              ),
              const SizedBox(width: 12),
              Text(
                '₹',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: widget.appearance.primaryColor,
                ),
              ),
              const SizedBox(width: 4),
              Text(
                widget.job['salary'] as String,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w800,
                  color: widget.appearance.primaryColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),

          // Workers Needed and Days
          Row(
            children: [
              Icon(Icons.people, size: 14, color: widget.appearance.primaryColor),
              const SizedBox(width: 4),
              Text(
                '${widget.job['workersNeeded']} workers needed',
                style: TextStyle(
                  fontSize: 12,
                  color: widget.appearance.brightness == Brightness.dark
                      ? Colors.grey[300]
                      : Colors.grey[600],
                ),
              ),
              const SizedBox(width: 12),
              Icon(Icons.calendar_today, size: 14, color: widget.appearance.primaryColor),
              const SizedBox(width: 4),
              Text(
                '${widget.job['daysRequired']} days',
                style: TextStyle(
                  fontSize: 12,
                  color: widget.appearance.brightness == Brightness.dark
                      ? Colors.grey[300]
                      : Colors.grey[600],
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),

          // Divider
          Divider(
            color: widget.appearance.brightness == Brightness.dark
                ? Colors.grey[700]
                : Colors.grey[200],
            thickness: 1,
            height: 1,
          ),
          const SizedBox(height: 12),

          // Social Actions Row
          AbsorbPointer(
            absorbing: false,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
              // Microphone Button (Listen to Job Info)
              InkWell(
                onTap: isPlayingAudio ? _stopAudio : _speakJobInfo,
                borderRadius: BorderRadius.circular(8),
                splashColor: Colors.purple.withValues(alpha: 0.3),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 8),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        isPlayingAudio ? Icons.stop_circle : Icons.mic,
                        size: 18,
                        color: isPlayingAudio ? Colors.red : Colors.purple,
                      ),
                      const SizedBox(width: 3),
                      Text(
                        isPlayingAudio ? 'Stop' : 'Listen',
                        style: TextStyle(
                          fontSize: 9,
                          color: isPlayingAudio ? Colors.red : Colors.grey[700],
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Translate Button
              InkWell(
                onTap: _toggleTranslation,
                borderRadius: BorderRadius.circular(8),
                splashColor: Colors.green.withValues(alpha: 0.3),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 8),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.translate,
                        color: isTranslated ? Colors.green[700] : Colors.green,
                        size: 19,
                      ),
                      const SizedBox(width: 3),
                      Text(
                        isTranslating ? 'Translating...' : (isTranslated ? 'English' : 'हिंदी'),
                        style: TextStyle(
                          fontSize: 9,
                          color: widget.appearance.brightness == Brightness.dark
                              ? Colors.grey[300]
                              : Colors.grey[700],
                          fontWeight: isTranslated ? FontWeight.bold : FontWeight.normal,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Comment Button
              InkWell(
                onTap: () {
                  _showCommentDialog();
                },
                borderRadius: BorderRadius.circular(8),
                splashColor: widget.appearance.primaryColor.withValues(alpha: 0.3),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.comment,
                        color: widget.appearance.primaryColor,
                        size: 19,
                      ),
                    ],
                  ),
                ),
              ),

              // Share Button
              InkWell(
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('📤 Shared!'),
                      duration: const Duration(seconds: 2),
                    ),
                  );
                },
                borderRadius: BorderRadius.circular(8),
                splashColor: widget.appearance.primaryColor.withValues(alpha: 0.3),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.share_outlined,
                        color: widget.appearance.primaryColor,
                        size: 19,
                      ),
                      const SizedBox(width: 3),
                      Text(
                        'Share',
                        style: TextStyle(
                          fontSize: 9,
                          color: widget.appearance.brightness == Brightness.dark
                              ? Colors.grey[300]
                              : Colors.grey[700],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
            ),
        ],
      ),
      ),
    );
  }
}

class _WorkerCard extends StatefulWidget {
  final Map<String, dynamic> worker;
  final AppearanceProvider appearance;
  final VoidCallback onTap;

  const _WorkerCard({
    required this.worker,
    required this.appearance,
    required this.onTap,
  });

  @override
  State<_WorkerCard> createState() => _WorkerCardState();
}

class _WorkerCardState extends State<_WorkerCard> {
  bool isFavorite = false;
  final FlutterTts flutterTts = FlutterTts();
  bool isPlayingAudio = false;
  int commentCount = 5;
  final TextEditingController _commentController = TextEditingController();
  List<String> comments = ['Great worker!', 'Very professional', 'Highly recommended'];
  
  @override
  void initState() {
    super.initState();
    _checkIfFavorite();
    _initTts();
  }

  Future<void> _initTts() async {
    await flutterTts.setLanguage('en-IN');
    await flutterTts.setSpeechRate(0.85);
  }

  Future<void> _speakWorkerInfo() async {
    String text = '''
    ${widget.worker['workerName']}, ${widget.worker['workerType']}.
    Charges ${widget.worker['dailyRate']} rupees per day, or ${widget.worker['halfDayRate']} rupees for half day.
    Skills: ${widget.worker['skills']}.
    Location: ${widget.worker['location']}.
    Rating: ${widget.worker['rating']} out of 5 stars.
    ''';

    setState(() {
      isPlayingAudio = true;
    });

    await flutterTts.speak(text);
    
    flutterTts.setCompletionHandler(() {
      setState(() {
        isPlayingAudio = false;
      });
    });
  }

  Future<void> _stopAudio() async {
    await flutterTts.stop();
    setState(() {
      isPlayingAudio = false;
    });
  }
  
  @override
  void dispose() {
    _commentController.dispose();
    flutterTts.stop();
    super.dispose();
  }
  
  Future<void> _checkIfFavorite() async {
    final prefs = await SharedPreferences.getInstance();
    final favorites = prefs.getStringList('favorite_workers') ?? [];
    setState(() {
      isFavorite = favorites.contains(widget.worker['workerName']);
    });
  }
  
  Future<void> _toggleFavorite() async {
    final prefs = await SharedPreferences.getInstance();
    final favorites = prefs.getStringList('favorite_workers') ?? [];
    
    final workerName = widget.worker['workerName'] as String;
    bool isAdded = false;
    
    setState(() {
      if (isFavorite) {
        favorites.remove(workerName);
      } else {
        favorites.add(workerName);
        isAdded = true;
      }
      isFavorite = !isFavorite;
    });
    
    await prefs.setStringList('favorite_workers', favorites);
    
    // Show professional notification
    if (mounted) {
      _showProfessionalNotification(
        context,
        isAdded 
            ? 'Added to Favorites'
            : 'Removed from Favorites',
        workerName,
        isAdded,
      );
    }
  }

  void _showProfessionalNotification(
    BuildContext context,
    String title,
    String workerName,
    bool isAdded,
  ) {
    final overlay = Overlay.of(context);
    late OverlayEntry overlayEntry;

    overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        bottom: 80,
        left: 16,
        right: 16,
        child: Material(
          color: Colors.transparent,
          child: TweenAnimationBuilder<double>(
            tween: Tween(begin: 0.0, end: 1.0),
            duration: const Duration(milliseconds: 400),
            builder: (context, value, child) {
              return Transform.translate(
                offset: Offset(0, 20 * (1 - value)),
                child: Opacity(
                  opacity: value,
                  child: child,
                ),
              );
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: isAdded ? Colors.grey[300]! : Colors.grey[300]!,
                  width: 1,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Icon(
                    isAdded ? Icons.favorite : Icons.favorite_outline,
                    color: Colors.red,
                    size: 18,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      '$title • $workerName',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );

    overlay.insert(overlayEntry);

    // Auto-remove after 2 seconds
    Future.delayed(const Duration(seconds: 2), () {
      if (overlayEntry.mounted) {
        overlayEntry.remove();
      }
    });
  }

  void _editComment(int index) {
    _commentController.text = comments[index];
    showModalBottomSheet(
      context: context,
      backgroundColor: widget.appearance.brightness == Brightness.dark
          ? const Color(0xFF2A2A2A)
          : Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      isScrollControlled: true,
      builder: (context) => Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: widget.appearance.brightness == Brightness.dark
                        ? Colors.grey[600]
                        : Colors.grey[300],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Edit Comment',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: widget.appearance.brightness == Brightness.dark
                      ? Colors.white
                      : Colors.black,
                ),
              ),
              const SizedBox(height: 16),
              Container(
                decoration: BoxDecoration(
                  color: widget.appearance.brightness == Brightness.dark
                      ? const Color(0xFF1E1E1E)
                      : Colors.grey[100],
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: widget.appearance.brightness == Brightness.dark
                        ? Colors.grey[700]!
                        : Colors.grey[300]!,
                    width: 1,
                  ),
                ),
                child: TextField(
                  controller: _commentController,
                  maxLines: 3,
                  decoration: InputDecoration(
                    hintText: 'Edit your comment...',
                    hintStyle: TextStyle(
                      color: widget.appearance.brightness == Brightness.dark
                          ? Colors.grey[600]
                          : Colors.grey,
                    ),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.all(12),
                  ),
                  style: TextStyle(
                    color: widget.appearance.brightness == Brightness.dark
                        ? Colors.white
                        : Colors.black,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => Navigator.pop(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey[400],
                      ),
                      child: const Text(
                        'Cancel',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        if (_commentController.text.isNotEmpty) {
                          setState(() {
                            comments[index] = _commentController.text;
                          });
                          _commentController.clear();
                          Navigator.pop(context);
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: widget.appearance.primaryColor,
                      ),
                      child: const Text(
                        'Update',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _deleteComment(int index) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: widget.appearance.brightness == Brightness.dark
            ? const Color(0xFF2A2A2A)
            : Colors.white,
        title: Text(
          'Delete Comment',
          style: TextStyle(
            color: widget.appearance.brightness == Brightness.dark
                ? Colors.white
                : Colors.black,
          ),
        ),
        content: Text(
          'Are you sure you want to delete this comment?',
          style: TextStyle(
            color: widget.appearance.brightness == Brightness.dark
                ? Colors.white70
                : Colors.black87,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'No',
              style: TextStyle(color: widget.appearance.primaryColor),
            ),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                comments.removeAt(index);
                commentCount--;
              });
              Navigator.pop(context);
            },
            child: const Text('Yes', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void _showCommentDialog() {
    showModalBottomSheet(
      context: context,
      backgroundColor: widget.appearance.brightness == Brightness.dark
          ? const Color(0xFF2A2A2A)
          : Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      isScrollControlled: true,
      builder: (context) => Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'Comments ($commentCount)',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: widget.appearance.brightness == Brightness.dark
                        ? Colors.white
                        : Colors.black,
                  ),
                ),
                const SizedBox(height: 16),
                
                // Comments list
                ...comments.asMap().entries.map((entry) {
                  final index = entry.key;
                  final comment = entry.value;
                  
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CircleAvatar(
                          radius: 16,
                          backgroundColor: widget.appearance.primaryColor.withValues(alpha: 0.2),
                          child: Icon(Icons.person, size: 18, color: widget.appearance.primaryColor),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'User ${index + 1}',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: widget.appearance.brightness == Brightness.dark
                                      ? Colors.white
                                      : Colors.black,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                comment,
                                style: TextStyle(
                                  color: widget.appearance.brightness == Brightness.dark
                                      ? Colors.grey[300]
                                      : Colors.grey[700],
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                '${index + 1}d ago',
                                style: TextStyle(
                                  fontSize: 11,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        ),
                        PopupMenuButton<String>(
                          itemBuilder: (BuildContext context) => [
                            PopupMenuItem<String>(
                              value: 'edit',
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(Icons.edit, size: 16, color: widget.appearance.primaryColor),
                                  const SizedBox(width: 8),
                                  const Text('Edit'),
                                ],
                              ),
                            ),
                            PopupMenuItem<String>(
                              value: 'delete',
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(Icons.delete, size: 16, color: Colors.red),
                                  const SizedBox(width: 8),
                                  const Text('Delete', style: TextStyle(color: Colors.red)),
                                ],
                              ),
                            ),
                          ],
                          onSelected: (value) {
                            if (value == 'edit') {
                              _editComment(index);
                            } else if (value == 'delete') {
                              _deleteComment(index);
                            }
                          },
                          icon: Icon(
                            Icons.more_vert,
                            size: 16,
                            color: Colors.grey[500],
                          ),
                        ),
                      ],
                    ),
                  );
                }),
                const SizedBox(height: 16),
                
                // Divider
                Divider(
                  color: widget.appearance.brightness == Brightness.dark
                      ? Colors.grey[700]
                      : Colors.grey[200],
                ),
                const SizedBox(height: 12),
                
                // Input field - Add comment
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          color: widget.appearance.brightness == Brightness.dark
                              ? Colors.grey[800]
                              : Colors.grey[100],
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: widget.appearance.brightness == Brightness.dark
                                ? Colors.grey[700]!
                                : Colors.grey[200]!,
                            width: 1,
                          ),
                        ),
                        child: TextField(
                          controller: _commentController,
                          maxLines: 2,
                          minLines: 1,
                          decoration: InputDecoration(
                            hintText: 'Add a comment...',
                            hintStyle: TextStyle(
                              color: Colors.grey[500],
                            ),
                            border: InputBorder.none,
                            contentPadding: const EdgeInsets.all(12),
                          ),
                          style: TextStyle(
                            color: widget.appearance.brightness == Brightness.dark
                                ? Colors.white
                                : Colors.black,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    GestureDetector(
                      onTap: () {
                        if (_commentController.text.isNotEmpty) {
                          setState(() {
                            comments.add(_commentController.text);
                            commentCount++;
                          });
                          _commentController.clear();
                          Navigator.pop(context);
                        }
                      },
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: widget.appearance.primaryColor,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.send,
                          color: Colors.white,
                          size: 18,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 0.0, vertical: 2.0),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: widget.appearance.brightness == Brightness.dark
              ? const Color(0xFF2A2A2A)
              : Colors.white,
          borderRadius: BorderRadius.circular(2),
          border: Border.all(
            color: widget.appearance.brightness == Brightness.dark
                ? Colors.grey[800]!
                : Colors.grey[200]!,
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.08),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Worker Name, Type, and Like Button
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 55,
                  height: 55,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        widget.appearance.primaryColor.withValues(alpha: 0.4),
                        widget.appearance.primaryColor.withValues(alpha: 0.1),
                      ],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: widget.appearance.primaryColor.withValues(alpha: 0.2),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Icon(
                    Icons.person,
                    color: widget.appearance.primaryColor,
                    size: 28,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.worker['workerName'] as String,
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w700,
                          color: widget.appearance.brightness == Brightness.dark
                              ? Colors.white
                              : Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        widget.worker['workerType'] as String,
                        style: TextStyle(
                          fontSize: 14,
                          color: widget.appearance.primaryColor,
                        ),
                      ),
                    ],
                  ),
                ),
                InkWell(
                  onTap: _toggleFavorite,
                  borderRadius: BorderRadius.circular(8),
                  splashColor: Colors.red.withOpacity(0.3),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    child: Icon(
                      isFavorite ? Icons.favorite : Icons.favorite_border,
                      color: Colors.red,
                      size: 19,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            // Location, Rating and Rates in one compact row
            Row(
              children: [
                Expanded(
                  child: Row(
                    children: [
                      Icon(Icons.location_on, size: 13, color: Colors.grey[600]),
                      const SizedBox(width: 3),
                      Expanded(
                        child: Text(
                          widget.worker['location'] as String,
                          style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Icon(Icons.star, color: Colors.amber, size: 14),
                const SizedBox(width: 2),
                Text(
                  '${widget.worker['rating']}',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: widget.appearance.brightness == Brightness.dark
                        ? Colors.grey[300]
                        : Colors.grey[800],
                  ),
                ),
                const SizedBox(width: 2),
                Text(
                  '(${widget.worker['reviewCount']})',
                  style: TextStyle(
                    fontSize: 11,
                    color: widget.appearance.brightness == Brightness.dark
                        ? Colors.grey[400]
                        : Colors.grey[600],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            
            // Rates on second line
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '₹${widget.worker['dailyRate']}/day',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w800,
                        color: widget.appearance.primaryColor,
                      ),
                    ),
                    Text(
                      '₹${widget.worker['halfDayRate']}/half',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: widget.appearance.brightness == Brightness.dark
                            ? Colors.grey[400]
                            : Colors.grey[700],
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 8),
            
            // Skills and Availability in one row
            Row(
              children: [
                Expanded(
                  child: Text(
                    widget.worker['skills'] as String,
                    style: TextStyle(
                      fontSize: 12,
                      color: widget.appearance.brightness == Brightness.dark
                          ? Colors.grey[400]
                          : Colors.grey[600],
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: Colors.green.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(3),
                  ),
                  child: Text(
                    widget.worker['availability'] as String,
                    style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: Colors.green,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            // Divider
            Divider(
              color: widget.appearance.brightness == Brightness.dark
                  ? Colors.grey[700]
                  : Colors.grey[200],
              thickness: 1,
              height: 1,
            ),
            const SizedBox(height: 12),
            // Social Actions Row
            AbsorbPointer(
              absorbing: false,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  InkWell(
                    onTap: isPlayingAudio ? _stopAudio : _speakWorkerInfo,
                    borderRadius: BorderRadius.circular(8),
                    splashColor: Colors.purple.withValues(alpha: 0.3),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            isPlayingAudio ? Icons.stop_circle : Icons.mic,
                            size: 18,
                            color: isPlayingAudio ? Colors.red : Colors.purple,
                          ),
                          const SizedBox(width: 3),
                          Text(
                            isPlayingAudio ? 'Stop' : 'Listen',
                            style: TextStyle(
                              fontSize: 9,
                              color: isPlayingAudio ? Colors.red : Colors.grey[700],
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Translating worker profile...'),
                          duration: Duration(seconds: 2),
                        ),
                      );
                    },
                    borderRadius: BorderRadius.circular(8),
                    splashColor: Colors.green.withValues(alpha: 0.3),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.translate, size: 18, color: Colors.green),
                          const SizedBox(width: 3),
                          Text(
                            'Translate',
                            style: TextStyle(fontSize: 9, color: Colors.grey[700]),
                          ),
                        ],
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      _showCommentDialog();
                    },
                    borderRadius: BorderRadius.circular(8),
                    splashColor: widget.appearance.primaryColor.withValues(alpha: 0.3),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                      child: Icon(Icons.comment, size: 18, color: widget.appearance.primaryColor),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ChatScreen(
                            userName: widget.worker['name'] ?? 'Worker',
                          ),
                        ),
                      );
                    },
                    borderRadius: BorderRadius.circular(8),
                    splashColor: widget.appearance.primaryColor.withValues(alpha: 0.3),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.phone, size: 18, color: widget.appearance.primaryColor),
                          const SizedBox(width: 3),
                          Text(
                            'Call',
                            style: TextStyle(fontSize: 9, color: Colors.grey[700]),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SwipeableJobCard extends StatefulWidget {
  final String title;
  final String company;
  final String location;
  final String type;
  final String salary;
  final AppearanceProvider appearance;
  final Function(String) onSwipe;
  final VoidCallback onTap;

  const _SwipeableJobCard({
    required this.title,
    required this.company,
    required this.location,
    required this.type,
    required this.salary,
    required this.appearance,
    required this.onSwipe,
    required this.onTap,
  });

  @override
  State<_SwipeableJobCard> createState() => _SwipeableJobCardState();
}

class _SwipeableJobCardState extends State<_SwipeableJobCard> {
  double _dragOffset = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onPanUpdate: (details) {
        setState(() {
          _dragOffset += details.delta.dx;
        });
      },
      onPanEnd: (details) {
        final velocity = details.velocity.pixelsPerSecond.dx;
        final isDraggedEnoughToRemove = _dragOffset.abs() > 10; // 10 pixels threshold
        final isFlicked = velocity.abs() > 200;
        
        if (isDraggedEnoughToRemove || isFlicked) {
          // Swipe detected - trigger category change IMMEDIATELY
          final direction = _dragOffset > 0 ? 'right' : 'left';
          print('Swiped: $direction, offset: $_dragOffset'); // Debug
          widget.onSwipe(direction); // This calls setState in parent
          
          // Snap back after a brief delay
          Future.delayed(const Duration(milliseconds: 150), () {
            if (mounted) {
              setState(() {
                _dragOffset = 0;
              });
            }
          });
        } else {
          // Snap back to original position
          setState(() {
            _dragOffset = 0;
          });
        }
      },
      onTap: widget.onTap,
      child: Transform.translate(
        offset: Offset(_dragOffset, 0),
        child: Opacity(
          opacity: (_dragOffset.abs() < 300) ? 1.0 : 1 - (_dragOffset.abs() / 500),
          child: Container(
            padding: const EdgeInsets.all(16),
            margin: const EdgeInsets.only(bottom: 12),
            decoration: BoxDecoration(
              color: widget.appearance.brightness == Brightness.dark
                  ? const Color(0xFF2A2A2A)
                  : Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: widget.appearance.brightness == Brightness.dark
                    ? Colors.grey[800]!
                    : Colors.grey[200]!,
                width: 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.08),
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
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            widget.appearance.primaryColor.withValues(alpha: 0.3),
                            widget.appearance.primaryColor.withValues(alpha: 0.1),
                          ],
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: widget.appearance.primaryColor.withValues(alpha: 0.2),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Icon(
                        Icons.business,
                        color: widget.appearance.primaryColor,
                        size: 30,
                      ),
                    ),
                    const SizedBox(width: 12),
                    // Company Info
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.title,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: widget.appearance.brightness == Brightness.dark
                                  ? Colors.white
                                  : Colors.black87,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            widget.company,
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                              color: widget.appearance.brightness == Brightness.dark
                                  ? Colors.grey[400]
                                  : Colors.grey[700],
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Bookmark icon
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: widget.appearance.brightness == Brightness.dark
                            ? Colors.grey[800]
                            : Colors.grey[100],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        Icons.bookmark_outline,
                        color: widget.appearance.brightness == Brightness.dark
                            ? Colors.grey[500]
                            : Colors.grey[600],
                        size: 20,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                
                // Location and Type
                Row(
                  children: [
                    Icon(
                      Icons.location_on,
                      size: 16,
                      color: widget.appearance.brightness == Brightness.dark
                          ? Colors.grey[500]
                          : Colors.grey,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      widget.location,
                      style: widget.appearance.getSmallStyle().copyWith(
                        color: widget.appearance.brightness == Brightness.dark
                            ? Colors.grey[400]
                            : Colors.grey,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: widget.appearance.primaryColor.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        widget.type,
                        style: widget.appearance.getSmallStyle().copyWith(
                          color: widget.appearance.primaryColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                
                // Salary
                Text(
                  'Salary: ${widget.salary}',
                  style: widget.appearance.getBodyStyle().copyWith(
                    color: widget.appearance.brightness == Brightness.dark
                        ? Colors.white
                        : Colors.black87,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 16),
                
                // Action Buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    // Call Button
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ChatScreen(
                              userName: widget.company,
                            ),
                          ),
                        );
                      },
                      child: Column(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: widget.appearance.primaryColor.withValues(alpha: 0.1),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.phone,
                              color: widget.appearance.primaryColor,
                              size: 20,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Call',
                            style: widget.appearance.getSmallStyle().copyWith(
                              color: widget.appearance.brightness == Brightness.dark
                                  ? Colors.grey[400]
                                  : Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ),
                    
                    // Apply Button
                    ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: widget.appearance.primaryColor,
                        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Text(
                        'Apply',
                        style: widget.appearance.getBodyStyle().copyWith(
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
        ),
      ),
    );
  }
}

class _CategoryHeaderDelegate extends SliverPersistentHeaderDelegate {
  final Function(String?) onCategorySelected;
  final String? selectedCategory;
  final AppearanceProvider appearance;

  _CategoryHeaderDelegate({
    required this.onCategorySelected, 
    this.selectedCategory,
    required this.appearance,
  });

  final List<Map<String, dynamic>> categories = [
    {
      'name': 'Favorites',
      'icon': Icons.favorite,
      'color': Colors.red,
    },
    {
      'name': 'Carpenter',
      'icon': Icons.construction,
      'color': Colors.orange,
    },
    {
      'name': 'Plumber',
      'icon': Icons.plumbing,
      'color': Colors.blue,
    },
    {
      'name': 'Tailor',
      'icon': Icons.dry_cleaning,
      'color': Colors.purple,
    },
    {
      'name': 'Factory Worker',
      'icon': Icons.factory,
      'color': Colors.grey,
    },
    {
      'name': 'Kitchen Helper',
      'icon': Icons.restaurant,
      'color': Colors.green,
    },
    {
      'name': 'Messenger',
      'icon': Icons.local_shipping,
      'color': Colors.teal,
    },
    {
      'name': 'Mason',
      'icon': Icons.home_repair_service,
      'color': Colors.brown,
    },
  ];

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: appearance.brightness == Brightness.dark
          ? const Color(0xFF2A2A2A)
          : Colors.white,
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
                  Icon(
                    Icons.refresh,
                    color: selectedCategory == null
                        ? appearance.primaryColor
                        : (appearance.brightness == Brightness.dark
                            ? Colors.grey[600]
                            : Colors.grey[400]),
                    size: 32,
                  ),
                  const SizedBox(height: 2),
                  SizedBox(
                    width: 52,
                    child: Text(
                      'All',
                      style: TextStyle(
                        fontSize: 9,
                        color: appearance.brightness == Brightness.dark
                            ? Colors.grey[400]
                            : Colors.grey,
                      ),
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
                      Icon(
                        category['icon'],
                        color: isSelected
                            ? appearance.primaryColor
                            : (appearance.brightness == Brightness.dark
                                ? Colors.grey[600]
                                : Colors.grey[400]),
                        size: 32,
                      ),
                      const SizedBox(height: 2),
                      SizedBox(
                        width: 52,
                        child: Text(
                          category['name'],
                          style: TextStyle(
                            fontSize: 9,
                            color: isSelected
                                ? appearance.primaryColor
                                : (appearance.brightness == Brightness.dark
                                    ? Colors.grey[400]
                                    : Colors.grey),
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
