import 'package:flutter/material.dart';
import 'package:travel_muse_app/constants/app_colors.dart';

class CustomToast {
  static void show({
    required BuildContext context,
    required String message,
    Duration duration = const Duration(seconds: 2),
  }) {
    final overlay = Overlay.of(context);
    if (overlay == null) return;

    final overlayEntry = OverlayEntry(
      builder: (_) => _ToastWidget(
        message: message,
      ),
    );

    overlay.insert(overlayEntry);

    Future.delayed(duration, () => overlayEntry.remove());
  }
}

class _ToastWidget extends StatelessWidget {
  const _ToastWidget({required this.message});
  final String message;


  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 100,
      left: 24,
      right: 24,
      child: Material(
        color: Colors.transparent,
        child: Container(
          height: 59,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color:  AppColors.grey[600],
            borderRadius: BorderRadius.circular(40),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  color: AppColors.primary[300], 
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.check,
                  color: AppColors.white,
                  size: 16,
                ),
              ),
              const SizedBox(width: 8),
              Flexible(
                child: Text(
                  message,
                  style: const TextStyle(
                    fontFamily: 'Pretendard',
                    fontSize: 18,
                    fontWeight: FontWeight.w400,
                    color:AppColors.white,
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
