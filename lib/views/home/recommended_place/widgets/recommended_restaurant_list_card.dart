import 'package:flutter/material.dart';
import 'package:travel_muse_app/views/home/recommended_place/recommended_restaurant_detail_page.dart';

class RecommendedRestaurantListCard extends StatelessWidget {
  const RecommendedRestaurantListCard({
    super.key,
    required this.name,
    required this.image,
    required this.description,
    required this.isActive,
  });
  final String name;
  final String image;
  final String description;
  final bool isActive;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap:
          isActive
              ? () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const RecommendedRestaurantDetailPage(),
                  ),
                );
              }
              : null,
      child: Card(
        elevation: 2,
        margin: const EdgeInsets.only(bottom: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.horizontal(
                left: Radius.circular(12),
              ),
              child:
                  image.isNotEmpty
                      ? Image.asset(
                        image,
                        width: 100,
                        height: 100,
                        fit: BoxFit.cover,
                      )
                      : Container(
                        width: 100,
                        height: 100,
                        color: Colors.grey[300],
                        child: const Icon(Icons.image_not_supported),
                      ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 12,
                  horizontal: 8,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      description,
                      style: const TextStyle(fontSize: 13, color: Colors.grey),
                    ),
                  ],
                ),
              ),
            ),
            const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
          ],
        ),
      ),
    );
  }
}
