import 'package:flutter/cupertino.dart';
import 'package:travel_muse_app/constants/app_colors.dart';

class NextButton extends StatelessWidget {
  const NextButton({super.key, required this.onPressed, required this.enabled});
  final VoidCallback onPressed;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 18, 16, 17),
      child: SizedBox(
        width: double.infinity,
        height: 56,
        child: CupertinoButton(
          padding: EdgeInsets.zero,
          borderRadius: BorderRadius.circular(10),
          color: enabled ? AppColors.primary[400] : AppColors.grey[100],
          onPressed: enabled ? onPressed : null,
          child: Text(
            '다음',
            style: TextStyle(
              /// ignore: deprecated_member_use
              color: AppColors.white.withOpacity(enabled ? 1.0 : 0.6),
              fontSize: 18,
              fontWeight: FontWeight.w600,
              fontFamily: 'Pretendard',
            ),
          ),
        ),
      ),
    );
  }
}
