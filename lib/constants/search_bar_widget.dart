import 'package:flutter/material.dart';

class SearchBarWidget extends StatelessWidget {
  const SearchBarWidget({
    super.key,
    this.hintText = '검색어를 입력하세요',
    this.onTap,
    this.onChanged,
    this.onSubmitted,
    this.backgroundColor,
  });

  final String hintText;
  final VoidCallback? onTap;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final Color? backgroundColor;
  @override
  Widget build(BuildContext context) {
    final isInputMode = onChanged != null;

    return Container(
      width: 375,
      padding: const EdgeInsets.all(16),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: ShapeDecoration(
          color: backgroundColor ?? const Color(0xFFF5F5F5),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(100),
          ),
        ),
        child: Row(
          children: [
            const Icon(Icons.search, size: 24, color: Color(0xFF7C878C)),
            const SizedBox(width: 8),
            Expanded(
              child:
                  isInputMode
                      ? TextField(
                        onChanged: onChanged,
                        onSubmitted: onSubmitted,
                        decoration: InputDecoration(
                          hintText: hintText,
                          border: InputBorder.none,
                          isDense: true,
                          contentPadding: EdgeInsets.zero,
                          hintStyle: const TextStyle(
                            color: Color(0xFF4D4D4D),
                            fontSize: 16,
                            fontFamily: 'Pretendard',
                            fontWeight: FontWeight.w400,
                            height: 1.5,
                          ),
                        ),
                        style: const TextStyle(
                          fontSize: 16,
                          fontFamily: 'Pretendard',
                          fontWeight: FontWeight.w400,
                        ),
                      )
                      : GestureDetector(
                        onTap: onTap,
                        child: Text(
                          hintText,
                          style: const TextStyle(
                            color: Color(0xFF4D4D4D),
                            fontSize: 16,
                            fontFamily: 'Pretendard',
                            fontWeight: FontWeight.w400,
                            height: 1.5,
                          ),
                        ),
                      ),
            ),
          ],
        ),
      ),
    );
  }
}
