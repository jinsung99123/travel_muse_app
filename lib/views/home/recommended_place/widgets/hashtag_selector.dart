import 'package:flutter/material.dart';
import 'package:travel_muse_app/constants/app_colors.dart';

final hashtags = [
  '#전체',
  '#카페',
  '#가볼만한 곳',
  '#힐링',
  '#유적지',
  '#쇼핑',
  '#가족과 함께',
];

class HashtagSelector extends StatelessWidget {
  const HashtagSelector({
    super.key,
    required this.selectedTag,
    required this.onTagTap,
  });
  final String? selectedTag;
  final void Function(String?) onTagTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children:
              hashtags.map((tag) {
                final isSelected = selectedTag == tag;
                return GestureDetector(
                  onTap: () => onTagTap(isSelected ? null : tag),
                  child: Container(
                    margin: const EdgeInsets.only(right: 8),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color:
                          isSelected ? AppColors.primary[300] : AppColors.white,
                      border: Border.all(color: const Color(0xFF48CDFD)),
                      borderRadius: BorderRadius.circular(100),
                    ),
                    child: Text(
                      tag,
                      style: TextStyle(
                        color:
                            isSelected
                                ? AppColors.white
                                : AppColors.primary[300],
                        fontSize: 14,
                      ),
                    ),
                  ),
                );
              }).toList(),
        ),
      ),
    );
  }
}
