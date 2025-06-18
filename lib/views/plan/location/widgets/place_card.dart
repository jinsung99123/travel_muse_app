import 'package:flutter/material.dart';
import 'package:travel_muse_app/constants/app_colors.dart';

class PlaceCard extends StatelessWidget {
  const PlaceCard({
    required this.placeData,
    this.isSelected = false,
    this.onTap,
    super.key,
  });

  final Map<String, String> placeData;
  final bool isSelected;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final name = placeData['title'] ?? '이름 없음';
    final address = placeData['subtitle'] ?? '주소 없음';
    final imageUrl = placeData['image'] ?? '';

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isSelected ? AppColors.primary[400]! : AppColors.grey[300]!,
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: isSelected ? 6 : 3,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            // 썸네일
            ClipRRect(
              borderRadius: BorderRadius.circular(14),
              child: imageUrl.isNotEmpty
                  ? Image.network(
                      imageUrl,
                      width: 90,
                      height: 90,
                      fit: BoxFit.cover,
                    )
                  : Container(
                      width: 90,
                      height: 90,
                      color: Colors.grey.shade300,
                      child: const Icon(Icons.image_not_supported),
                    ),
            ),
            const SizedBox(width: 16),

            // 텍스트들
            Expanded(
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
                  const SizedBox(height: 6),
                  Text(
                    address,
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.black54,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),

            // 체크 아이콘
            if (isSelected)
               Padding(
                 padding: const EdgeInsets.all(8.0),
                 child: Icon(
                  Icons.check_circle_outline,
                  color: AppColors.secondary[300],
                  size: 24,
                               ),
               ),
          ],
        ),
      ),
    );
  }
}
