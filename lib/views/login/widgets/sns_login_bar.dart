import 'package:flutter/material.dart';
import 'package:travel_muse_app/constants/app_colors.dart';

class SnsLoginBar extends StatelessWidget {
  const SnsLoginBar({
    required this.sns,
    required this.backgroundColor,
    required this.textColor,
    required this.imageWidget,
    required this.loginFunction,
    super.key,
  });

  final String sns;
  final Color backgroundColor;
  final Color textColor;
  final Widget imageWidget;
  final Future<void> Function() loginFunction;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        await loginFunction();
      },
      child: Container(
        height: 56,
        width: double.infinity,
        decoration: ShapeDecoration(
          color: backgroundColor,
          shape: RoundedRectangleBorder(
            side: BorderSide(width: 1, color: AppColors.grey[100]!),
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        child: Row(
          children: [
            Spacer(),
            imageWidget,
            SizedBox(width: 16),
            Text(
              '$sns로 시작하기',
              style: TextStyle(
                color: textColor,
                fontSize: 20,
                fontFamily: 'Pretendard',
                fontWeight: FontWeight.w600,
                height: 1.50,
              ),
            ),
            Spacer(),
          ],
        ),
      ),
    );
  }
}
