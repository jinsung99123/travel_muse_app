import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:travel_muse_app/constants/app_colors.dart';
import 'package:travel_muse_app/providers/resent_search_provider.dart';

class RecentSearchSection extends ConsumerWidget {
  const RecentSearchSection({
    super.key,
    required this.onSelect, 
  });

  final void Function(String word) onSelect;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final recent = ref.watch(recentSearchProvider);

    if (recent.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        //최근 검색어 + 전체 삭제
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              const Text(
                '최근 검색어',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'Pretendard',
                ),
              ),
              const Spacer(),
              TextButton(
                style: TextButton.styleFrom(
                  padding: EdgeInsets.zero,
                  minimumSize: const Size(32, 28),
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                onPressed: () =>
                    ref.read(recentSearchProvider.notifier).clear(),
                child: Text(
                  '전체 삭제',
                  style: TextStyle(
                    fontSize: 14,
                    color: AppColors.primary[600],
                    fontFamily: 'Pretendard',
                  ),
                ),
              ),
            ],
          ),
        ),

        // 칩 리스트
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Wrap(
              spacing: 8,
              runSpacing: 8,
              children: recent
                  .map(
                    (word) => InputChip(
                      label: Text(
                        word,
                        style: TextStyle(
                          color: AppColors.grey[400],
                          fontSize: 14,
                          fontFamily: 'Pretendard',
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 8),
                      backgroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(100),
                        side: BorderSide(
                          color: AppColors.grey[100]!,
                          width: 1,
                        ),
                      ),
                      deleteIcon: Icon(Icons.close,
                          size: 16, color: AppColors.grey[100]),
                      onPressed: () => onSelect(word),
                      onDeleted: () =>
                          ref.read(recentSearchProvider.notifier).remove(word),
                    ),
                  )
                  .toList(),
            ),
          ),
        ),
      ],
    );
  }
}
