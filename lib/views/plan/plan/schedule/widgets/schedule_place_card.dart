import 'package:drag_and_drop_lists/drag_and_drop_lists.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
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

    final double cardMinH = showHandle ? 80 : 100;
    final double vPadding = showHandle ? 8 : 16;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeInOut,
      margin: const EdgeInsets.symmetric(vertical: 6),
      child: Container(
        decoration:
            showHandle
                ? BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      AppColors.secondary[300]!,
                      AppColors.secondary[400]!,
                    ],
                    stops: [0.5, 0.5],
                  ),
                  borderRadius: BorderRadius.circular(10),
                )
                : BoxDecoration(
                  border: Border.all(color: AppColors.grey[300]!),
                  borderRadius: BorderRadius.circular(10),
                ),
        padding: showHandle ? const EdgeInsets.all(1.5) : EdgeInsets.zero,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeInOut,
          constraints: BoxConstraints(minHeight: cardMinH),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(8.5),
            boxShadow: [
              BoxShadow(
                color: const Color.fromRGBO(0, 0, 0, 0.05),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          padding: EdgeInsets.symmetric(horizontal: 12, vertical: vPadding),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // 썸네일
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.network(
                  (place['image'] != null && place['image']!.isNotEmpty)
                      ? place['image']!
                      : 'https://via.placeholder.com/80', // 기본 이미지
                  width: 75,
                  height: 75,
                  fit: BoxFit.cover,
                  errorBuilder:
                      (context, error, stackTrace) => Image.asset(
                        'assets/images/default_image.jpg',
                        width: 75,
                        height: 75,
                        fit: BoxFit.cover,
                      ),
                ),
              ),
              const SizedBox(width: 12),

              // 텍스트 정보
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
                    if (place['address'] != null &&
                        place['address']!.isNotEmpty) ...[
                      const SizedBox(height: 4),
                      Text(
                        place['address']!,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.bodySmall!.copyWith(
                          color: AppColors.black,
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          fontFamily: 'Pretendard',
                        ),
                      ),
                    ],
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

              if (showHandle)
                DragHandle(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 8),
                    child: SvgPicture.asset(
                      'assets/icons/menu.svg',
                      width: 24,
                      height: 24,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
