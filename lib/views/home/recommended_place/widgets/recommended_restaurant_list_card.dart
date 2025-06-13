import 'package:flutter/material.dart';
import 'package:travel_muse_app/models/home_place.dart';
import 'package:travel_muse_app/views/home/recommended_place/recommended_place_detail_page.dart';

class RecommendedRestaurantListCard extends StatelessWidget {
  const RecommendedRestaurantListCard({
    super.key,
    required this.name,
    required this.image,
    required this.description,
    required this.isActive,
    this.place, 
  });

  final String name;
  final String image;
  final String description;
  final bool isActive;
  final HomePlace? place;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isActive && place != null
          ? () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => RecommendedPlaceDetailPage(place: place!),
                ),
              );
            }
          : null,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFFB3E5FC), width: 1),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: image.isNotEmpty
                  ? (image.startsWith('http')
                      ? Image.network(
                          image,
                          width: 72,
                          height: 72,
                          fit: BoxFit.cover,
                        )
                      : Image.asset(
                          image,
                          width: 72,
                          height: 72,
                          fit: BoxFit.cover,
                        ))
                  : Container(
                      width: 72,
                      height: 72,
                      color: Colors.grey[300],
                      child: const Icon(Icons.image_not_supported),
                    ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    style: const TextStyle(fontSize: 14, color: Colors.black87),
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right, color: Colors.grey),
          ],
        ),
      ),
    );
  }
}
