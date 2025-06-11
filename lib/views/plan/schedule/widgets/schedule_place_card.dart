import 'package:flutter/material.dart';
import 'package:travel_muse_app/constants/app_colors.dart';

class SchedulePlaceCard extends StatelessWidget {
  const SchedulePlaceCard({
    super.key,
    required this.place,
    required this.index,
    required this.showHandle,
  });

  final Map<String, String> place;
  final int index;
  final bool showHandle;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // 편집 모드일 때만 카드 높이/패딩 축소
    final double cardMinH = showHandle ? 80 : 100;
    final double vPadding = showHandle ? 8 : 16;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeInOut,
      constraints: BoxConstraints(minHeight: cardMinH),
      margin: const EdgeInsets.symmetric(vertical: 6),
      decoration: BoxDecoration(
        border: Border.all(
          color:
              showHandle
                  ? const Color(0xFFBFD1FF) // 편집 중 파란 테두리
                  : const Color(0xFFE1E1E1),
        ),
        borderRadius: BorderRadius.circular(10),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: vPadding),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          //썸네일
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.network(
              place['image'] ?? 'https://via.placeholder.com/80',
              width: 75,
              height: 75,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: 12),
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 125),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  place['title'] ?? '',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.bodyMedium!.copyWith(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                    fontFamily: 'Pretendard',
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  place['subtitle'] ?? '',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.bodyMedium!.copyWith(
                    color: AppColors.grey[400],
                    fontWeight: FontWeight.w400,
                    fontSize: 13,
                    fontFamily: 'Pretendard',
                  ),
                ),
              ],
            ),
          ),
          const Spacer(),
          // 드래그 핸들
          if (showHandle)
            Padding(
              padding: const EdgeInsets.only(right: 8),
              child: const Icon(Icons.reorder, color: Color(0xFF9E9E9E)),
            ),
        ],
      ),
    );
  }
}
