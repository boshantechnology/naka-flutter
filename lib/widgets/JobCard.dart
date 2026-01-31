import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
class JobCard extends StatelessWidget {
  final String imageUrl;
  // final String title;
  // final String company;

  const JobCard({
    super.key,
    required this.imageUrl,
    // required this.title,
    // required this.company,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200,
      margin: const EdgeInsets.only(right: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: CachedNetworkImage(
              imageUrl: imageUrl,
              placeholder: (context, url) => const Center(child: CircularProgressIndicator()),
              errorWidget: (context, url, error) => const Icon(Icons.error),
              fit: BoxFit.cover,
              height: 110,
              width: double.infinity,
            ),
          ),
          const SizedBox(height: 8),
          // Text(
          //   // title,
          //   style: const TextStyle(
          //     fontSize: 16,
          //     fontWeight: FontWeight.w600,
          //     color: Color(0xFF0D141C),
          //   ),
          // ),
          // Text(
          //   // company,
          //   style: const TextStyle(fontSize: 14, color: Color(0xFF49739C)),
          // ),
        ],
      ),
    );
  }
}
