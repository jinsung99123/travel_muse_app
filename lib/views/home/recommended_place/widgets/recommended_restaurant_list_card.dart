import 'package:flutter/material.dart';
import 'package:travel_muse_app/constants/app_colors.dart';
import 'package:travel_muse_app/models/home/home_place.dart';
import 'package:travel_muse_app/views/home/recommended_place/recommended_place_detail_page.dart';

class RecommendedRestaurantListCard extends StatelessWidget {
  const RecommendedRestaurantListCard({
    super.key,
    required this.name,
    required this.image,
    required this.description,
    required this.catecory,
    required this.isActive,
    this.place,
  });

  final String name;
  final String image;
  final String description;
  final String catecory;
  final bool isActive;
  final HomePlace? place;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap:
          isActive && place != null
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
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child:
                  image.isNotEmpty
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
                        color: AppColors.grey[100],
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
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppColors.black,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description,
                     maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontSize: 14, color: AppColors.grey[700]),
                  ),
                   Text(
                    catecory,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontSize: 14, color: AppColors.grey[400]),
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
