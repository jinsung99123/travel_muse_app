import 'package:flutter/material.dart';
import 'package:travel_muse_app/constants/app_colors.dart';

class SearchBar extends StatelessWidget {
  const SearchBar({
    super.key,
    required this.controller,
    required this.onSearch,
    required this.onSubmitted,
  });

  final TextEditingController controller;
  final VoidCallback onSearch;
  final Function(String) onSubmitted;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8), // 내부 패딩 ↑↓8  ←→16
      decoration: BoxDecoration(
        color: AppColors.grey[50],               // 검색바 배경색
        borderRadius: BorderRadius.circular(28), // 완전 둥근 필 형태
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: onSearch,
            behavior: HitTestBehavior.opaque,
            child: Icon(
              Icons.search,
              size: 24,                           // 24×24 아이콘
              color: AppColors.grey[200],         // 아이콘 색상
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: TextField(
              controller: controller,
              onSubmitted: onSubmitted,
              style: const TextStyle(
                fontSize: 16,
                fontFamily: 'Pretendard',
                fontWeight: FontWeight.w400,
              ),
              decoration:  InputDecoration(
                isCollapsed: true,                // 기본 패딩 제거
                hintText: '검색어를 입력해주세요',
                hintStyle: TextStyle(
                  color: AppColors.grey[400],
                  fontSize: 16,
                  fontFamily: 'Pretendard',
                  fontWeight: FontWeight.w500,
                ),
                border: InputBorder.none,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

