import 'package:flutter/material.dart';
import 'package:naka/config/app_colors.dart';
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
      backgroundColor: AppColors.bgLight,
      body: PageView.builder(
        controller: _pageController,
        onPageChanged: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        itemCount: introItems.length,
        itemBuilder: (context, index) {
          final item = introItems[index];
          return Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Top Section
              Column(
                children: [
                  const SizedBox(height: 40),
                  // SVG Image
                  Container(
                    margin: const EdgeInsets.all(16.0),
                    height: 200,
                    width: 200,
                    child: SvgPicture.string(
                      item['svg'],
                      fit: BoxFit.contain,
                    ),
                  ),
                  const SizedBox(height: 24),
                  // Title Section
                  Text(
                    item['title'],
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: AppColors.text,
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Subtitle Section
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Text(
                      item['subtitle'],
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 15,
                        color: AppColors.textSecondary,
                        height: 1.5,
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  // Dots Indicator
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      introItems.length,
                      (dotIndex) => Container(
                        height: 8,
                        width: 8,
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        decoration: BoxDecoration(
                          color: dotIndex == _currentIndex
                              ? AppColors.primary
                              : AppColors.bgBorder,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              // Bottom Section
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
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
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        minimumSize: const Size(double.infinity, 56),
                      ),
                      child: Text(
                        index == introItems.length - 1 ? 'Get Started' : 'Next',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: AppColors.white,
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    if (_currentIndex > 0)
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
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
