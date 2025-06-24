import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:travel_muse_app/constants/app_colors.dart';
import 'package:travel_muse_app/models/home/home_place.dart';
import 'package:travel_muse_app/views/home/recommended_place/recommended_place_detail_page.dart';

class PlaceCard extends StatelessWidget {
  const PlaceCard({
    required this.placeData,
    this.isSelected = false,
    this.onTap,
    super.key,
    required this.isSelectMode,
  });

  final Map<String, dynamic> placeData;
  final bool isSelected;
  final VoidCallback? onTap;
  final bool isSelectMode;

  @override
  Widget build(BuildContext context) {
    final name = placeData['title'] ?? '이름 없음';
    final address = placeData['subtitle'] ?? '주소 없음';
    final imageUrl = placeData['image'] ?? '';

    return GestureDetector(
      onTap:
          onTap ??
          () {
            ///isSelectMode일 때만 내부에서 push 처리
            if (isSelectMode) {
              final homePlace = HomePlace.fromMap(placeData);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => RecommendedPlaceDetailPage(place: homePlace),
                ),
              );
            }
          },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isSelected ? AppColors.primary[400]! : AppColors.grey[300]!,
            width: 1,
          ),
        ),
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            // 썸네일
            ClipRRect(
              borderRadius: BorderRadius.circular(14),
              child:
                  imageUrl.isNotEmpty
                      ? Image.network(
                        imageUrl,
                        width: 90,
                        height: 90,
                        fit: BoxFit.cover,
                      )
                      : Container(
                        width: 90,
                        height: 90,
                        color: AppColors.grey[100],
                        child: const Icon(Icons.image_not_supported),
                      ),
            ),
            const SizedBox(width: 16),

            // 텍스트들
            Expanded(
              child: SizedBox(
                height: 90,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      address,
                      style: const TextStyle(
                        fontSize: 14,
                        color: AppColors.black,
                        height: 1.3,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ),

            // 체크 아이콘
            if (isSelected)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: SvgPicture.asset(
                  'assets/icons/check-circle.svg',
                  width: 28,
                  height: 28,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
