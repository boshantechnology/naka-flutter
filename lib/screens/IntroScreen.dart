import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:naka/assets/svg_assets.dart';

class IntroScreen extends StatefulWidget {
  const IntroScreen({super.key});

  @override
  State<IntroScreen> createState() => _IntroScreenState();
}

class _IntroScreenState extends State<IntroScreen> {
  late PageController _pageController;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> introItems = [
      {
        'svg': findWorkerSVG,
        'title': 'Find Skilled Workers',
        'subtitle': 'Browse trusted daily wage workers in your area. Carpenters, Plumbers, Tailors, and more at your fingertips.',
      },
      {
        'svg': postJobSVG,
        'title': 'Post Your Work',
        'subtitle': 'Need help? Post your job easily and get workers within hours. Flexible, affordable, and professional.',
      },
      {
        'svg': connectSVG,
        'title': 'Connect Directly',
        'subtitle': 'Chat, call, and negotiate directly with workers. Build long-term relationships for your recurring needs.',
      },
      {
        'svg': earnSVG,
        'title': 'Fair Wages, Instant Pay',
        'subtitle': 'Workers earn fair daily rates with instant payments. No middlemen, no hidden charges.',
      },
    ];

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          PageView(
            controller: _pageController,
            onPageChanged: (index) {
              setState(() {
                _currentIndex = index;
              });
            },
            children: introItems.map((item) {
              final isFirstPage = introItems.indexOf(item) == 0;
              return SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Top Section
                    Column(
                      children: [
                        const SizedBox(height: 60),
                        // Image - Use real image for first page, SVG for others
                        Container(
                          margin: const EdgeInsets.all(16.0),
                          height: 240,
                          width: double.infinity,
                          child: isFirstPage
                              ? Image.asset(
                                  'lib/assets/images/1.jpg',
                                  fit: BoxFit.contain,
                                )
                              : SvgPicture.string(
                                  item['svg'],
                                  fit: BoxFit.contain,
                                ),
                        ),
                        const SizedBox(height: 40),
                        // Title Section
                        Text(
                          item['title'],
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        const SizedBox(height: 20),
                        // Subtitle Section
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 24.0),
                          child: Text(
                            item['subtitle'],
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 16,
                              color: Color(0xFF5B7C99),
                              height: 1.6,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        const SizedBox(height: 40),
                        // Dots Indicator
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: List.generate(
                            introItems.length,
                            (dotIndex) => Container(
                              height: 10,
                              width: 10,
                              margin: const EdgeInsets.symmetric(horizontal: 6),
                              decoration: BoxDecoration(
                                color: dotIndex == _currentIndex
                                    ? const Color(0xFF00A8CC)
                                    : const Color(0xFFDDDDDD),
                                shape: BoxShape.circle,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 60),
                  ],
                ),
              );
            }).toList(),
          ),
          // Fixed Bottom Section
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Color.fromARGB(25, 0, 0, 0),
                    blurRadius: 8,
                    offset: Offset(0, -2),
                  ),
                ],
              ),
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 24.0),
              child: Column(
                children: [
                  ElevatedButton(
                    onPressed: () {
                      if (_currentIndex == introItems.length - 1) {
                        Navigator.pushNamedAndRemoveUntil(
                          context,
                          '/login',
                          (route) => false,
                        );
                      } else {
                        _pageController.nextPage(
                          duration: const Duration(milliseconds: 400),
                          curve: Curves.easeInOut,
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF00A8CC),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 18),
                      minimumSize: const Size(double.infinity, 56),
                    ),
                    child: Text(
                      _currentIndex == introItems.length - 1 ? 'Get Started' : 'Next',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextButton(
                    onPressed: () {
                      Navigator.pushNamedAndRemoveUntil(
                        context,
                        '/login',
                        (route) => false,
                      );
                    },
                    child: const Text(
                      'Skip',
                      style: TextStyle(
                        fontSize: 16,
                        color: Color(0xFF5B7C99),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
