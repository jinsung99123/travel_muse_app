import 'package:flutter/material.dart';

class PostActionButtons extends StatelessWidget {
  const PostActionButtons({
    super.key,
    required this.onPickImages,
    required this.onSubmit,
    required this.isWritable,
    required this.isLoading,
  });

  final VoidCallback onPickImages;
  final VoidCallback onSubmit;
  final bool isWritable;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      color: Colors.white,
      child: Row(
        children: [
          // 사진 추가 버튼
          GestureDetector(
            onTap: onPickImages,
            child: Container(
              width: 56,
              height: 56,
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                border: Border.all(color: const Color(0xFF98A0A4)),
                borderRadius: BorderRadius.circular(10),
                color: Colors.white,
              ),
              child: const Icon(
                Icons.image_outlined,
                size: 24,
                color: Color(0xFF98A0A4),
              ),
            ),
          ),

          const SizedBox(width: 12),

          // 완료 버튼
          Expanded(
            child: ElevatedButton(
              onPressed: isWritable && !isLoading ? onSubmit : null,
              style: ElevatedButton.styleFrom(
                backgroundColor:
                    isWritable && !isLoading
                        ? const Color(0xFF49CDFE)
                        : const Color(0xFFE9EBEB),
                minimumSize: const Size.fromHeight(56),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child:
                  isLoading
                      ? const SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                      : const Text(
                        '완료',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                          fontFamily: 'Pretendard',
                          height: 1.5,
                        ),
                      ),
            ),
          ),
        ],
      ),
    );
  }
}
