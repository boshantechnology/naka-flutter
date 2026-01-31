import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              children: [
                const SizedBox(height: 40),

                // Logo (Circular)
                CircleAvatar(
                  radius: 48,
                  backgroundColor: Color(0xFF4D5DFB),
                  child: Text(
                    'J',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 48,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // App Name
                const Text(
                  'Jobile',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w800,
                    color: Colors.black,
                  ),
                ),

                const SizedBox(height: 4),

                // Tagline
                const Text(
                  'Job Finder iOS App',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.black54,
                  ),
                ),

                const SizedBox(height: 48),

                // Continue as text
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Continue as',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),
                ),
                const SizedBox(height: 8),

                // Subtitle
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Lorem ipsum dolor sit amet, consectetur\nadipiscing elit, sed do eiusmod tempor',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                  ),
                ),

                const SizedBox(height: 32),

                // Job Seekers Card
                Container(
                  padding: const EdgeInsets.all(16),
                  margin: const EdgeInsets.only(bottom: 20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 12,
                        offset: Offset(0, 6),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      CachedNetworkImage(
                        imageUrl:
                            'https://cdn-icons-png.flaticon.com/512/1904/1904425.png',
                        height: 48,
                        width: 48,
                        placeholder: (context, url) =>
                            CircularProgressIndicator(),
                        errorWidget: (context, url, error) =>
                            Icon(Icons.error),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Text(
                              'JOB SEEKERS',
                              style: TextStyle(
                                color: Colors.blueAccent,
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              'Finding a job here never been easier than before',
                              style: TextStyle(
                                fontSize: 13,
                                color: Colors.black87,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                // Company Card
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 12,
                        offset: Offset(0, 6),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      CachedNetworkImage(
                        imageUrl:
                            'https://cdn-icons-png.flaticon.com/512/3135/3135715.png',
                        height: 48,
                        width: 48,
                        placeholder: (context, url) =>
                            CircularProgressIndicator(),
                        errorWidget: (context, url, error) =>
                            Icon(Icons.error),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Text(
                              'COMPANY',
                              style: TextStyle(
                                color: Colors.deepPurple,
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              'Let’s recruit your great candidate faster here',
                              style: TextStyle(
                                fontSize: 13,
                                color: Colors.black87,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
