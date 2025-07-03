import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:travel_muse_app/constants/app_colors.dart';
import 'package:travel_muse_app/utills/debouncer.dart';

class SearchBar extends StatefulWidget {
  const SearchBar({
    super.key,
    required this.controller,
    required this.onSearch,
    required this.onQueryChanged,
  });

  final TextEditingController controller;
  final VoidCallback onSearch;
  final ValueChanged<String> onQueryChanged;

  @override
  State<SearchBar> createState() => _SearchBarState();
}

class _SearchBarState extends State<SearchBar> {
  late final Debouncer _debouncer;

  @override
  void initState() {
    super.initState();
    _debouncer = Debouncer(const Duration(milliseconds: 300));
  }

  @override
  void dispose() {
    _debouncer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.grey[50],
        borderRadius: BorderRadius.circular(28),
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: widget.onSearch,
            behavior: HitTestBehavior.opaque,
            child: SvgPicture.asset(
              'assets/icons/search.svg',
              width: 28,
              height: 28,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: TextField(
              controller: widget.controller,
              onChanged: (q) => _debouncer.run(() {
                final trimmed = q.trim();
                if (trimmed.length < 2) return; 
                widget.onQueryChanged(trimmed);
              }),
              onSubmitted: (q) => widget.onQueryChanged(q.trim()), 
              style: const TextStyle(
                fontSize: 16,
                fontFamily: 'Pretendard',
                fontWeight: FontWeight.w400,
              ),
              decoration: InputDecoration(
                isCollapsed: true,
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
