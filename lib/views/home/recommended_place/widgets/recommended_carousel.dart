import 'package:flutter/material.dart';
import 'package:travel_muse_app/constants/app_colors.dart';
import 'package:travel_muse_app/models/home/home_place.dart';
import 'package:travel_muse_app/views/home/recommended_place/recommended_place_detail_page.dart';

class RecommendedCarousel extends StatelessWidget {
  const RecommendedCarousel({
    super.key,
    required this.places,
    this.rounded = false,
  });
  final List<HomePlace> places;
  final bool rounded;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 170,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: places.length,
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        itemBuilder: (_, idx) {
          final p = places[idx];
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => RecommendedPlaceDetailPage(place: p),
                ),
              );
            },
            child: SizedBox(
              width: 118,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  rounded
                      ? ClipOval(
                        child: Container(
                          width: 118,
                          height: 118,
                          color: AppColors.grey[100],
                          child: Image.network(
                            p.thumbnail,
                            width: 118,
                            height: 118,
                            fit: BoxFit.cover,
                            errorBuilder:
                                (_, __, ___) => const Icon(Icons.image),
                          ),
                        ),
                      )
                      : ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Container(
                          width: 118,
                          height: 139,
                          color: AppColors.grey[100],
                          child: Image.network(
                            p.thumbnail,
                            width: 118,
                            height: 139,
                            fit: BoxFit.cover,
                            errorBuilder:
                                (_, __, ___) => const Icon(Icons.image),
                          ),
                        ),
                      ),
                  const SizedBox(height: 4),
                  Text(
                    p.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: AppColors.black,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
