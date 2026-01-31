import 'package:flutter/material.dart';
import 'package:naka/config/app_colors.dart';

class IntroScreen extends StatelessWidget {
  const IntroScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, String>> introItems = [
      {
        'imageUrl':
            'https://lh3.googleusercontent.com/aida-public/AB6AXuAmqA0aaB0k1XhdMkzXZjmGxDzBXud2rFpCHQBHu1qwxRyb1H77Zsl9d-mGBRRdkOoF0RpZmtzaN23EMbqibkAioH5V5t4yiDjif0oi6X78hTFnI8wtev6Vo08ZM2BfmA6Au4THC12enkT3MNgoXkjcxvafZdyvFA4uL8GWzcxrCKsFtmgypNPRxumQ1nl7d5ysbDqvyaAcpQs6Xj10lbN58UjW5C9QBiWMTVwBYE3EyW9SOqWovwzS0_XADsvUprWQkDRcEQdfgVg',
        'title': 'Find your dream job',
        'subtitle':
            'Explore thousands of job opportunities and take the next step in your career.',
      },
      {
        'imageUrl':
            'https://lh3.googleusercontent.com/aida-public/AB6AXuAmqA0aaB0k1XhdMkzXZjmGxDzBXud2rFpCHQBHu1qwxRyb1H77Zsl9d-mGBRRdkOoF0RpZmtzaN23EMbqibkAioH5V5t4yiDjif0oi6X78hTFnI8wtev6Vo08ZM2BfmA6Au4THC12enkT3MNgoXkjcxvafZdyvFA4uL8GWzcxrCKsFtmgypNPRxumQ1nl7d5ysbDqvyaAcpQs6Xj10lbN58UjW5C9QBiWMTVwBYE3EyW9SOqWovwzS0_XADsvUprWQkDRcEQdfgVg',
        'title': 'Work with top companies',
        'subtitle': 'Collaborate with industry leaders and grow your skills.',
      },
      {
        'imageUrl':
            'https://lh3.googleusercontent.com/aida-public/AB6AXuAmqA0aaB0k1XhdMkzXZjmGxDzBXud2rFpCHQBHu1qwxRyb1H77Zsl9d-mGBRRdkOoF0RpZmtzaN23EMbqibkAioH5V5t4yiDjif0oi6X78hTFnI8wtev6Vo08ZM2BfmA6Au4THC12enkT3MNgoXkjcxvafZdyvFA4uL8GWzcxrCKsFtmgypNPRxumQ1nl7d5ysbDqvyaAcpQs6Xj10lbN58UjW5C9QBiWMTVwBYE3EyW9SOqWovwzS0_XADsvUprWQkDRcEQdfgVg',
        'title': 'Flexible work options',
        'subtitle':
            'Choose remote, hybrid, or in-office roles that suit your lifestyle.',
      },
      {
        'imageUrl':
            'https://lh3.googleusercontent.com/aida-public/AB6AXuAmqA0aaB0k1XhdMkzXZjmGxDzBXud2rFpCHQBHu1qwxRyb1H77Zsl9d-mGBRRdkOoF0RpZmtzaN23EMbqibkAioH5V5t4yiDjif0oi6X78hTFnI8wtev6Vo08ZM2BfmA6Au4THC12enkT3MNgoXkjcxvafZdyvFA4uL8GWzcxrCKsFtmgypNPRxumQ1nl7d5ysbDqvyaAcpQs6Xj10lbN58UjW5C9QBiWMTVwBYE3EyW9SOqWovwzS0_XADsvUprWQkDRcEQdfgVg',
        'title': 'Upskill and grow',
        'subtitle':
            'Access resources to enhance your career and achieve your goals.',
      },
    ];

    return Scaffold(
      backgroundColor: AppColors.bgLight,
      body: PageView.builder(
        itemCount: introItems.length,
        itemBuilder: (context, index) {
          final item = introItems[index];
          return Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Top Section
              Column(
                children: [
                  const SizedBox(
                    height: 32,
                  ), // Add spacing to move the image lower
                  Container(
                    margin: const EdgeInsets.all(16.0),
                    height: 200,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      image: DecorationImage(
                        image: NetworkImage(item['imageUrl']!),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Title Section
                  Text(
                    item['title']!,
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
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Text(
                      item['subtitle']!,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 16,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
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
                          color: dotIndex == index
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
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: ElevatedButton(
                  onPressed: () {
                    // Navigate to login screen using named route
                    Navigator.pushNamedAndRemoveUntil(
                      context,
                      '/login',
                      (route) => false,
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30), // Rounded button
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: const Text(
                    'Next',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppColors.white,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
            ],
          );
        },
      ),
    );
  }
}
