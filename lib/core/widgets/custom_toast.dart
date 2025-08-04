import 'package:flutter/material.dart';
import 'package:travel_muse_app/constants/app_colors.dart';

class CustomToast {
  static void show({
    required BuildContext context,
    required String message,
    Duration duration = const Duration(seconds: 10),
  }) {
    final overlay = Overlay.of(context);

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
    return Align(
     alignment: Alignment.bottomCenter,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 100),
        child: Material(
          color: Colors.transparent,
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width * 0.9,
            ),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 24,vertical: 16),
              decoration: BoxDecoration(
                color: AppColors.grey[600],
                borderRadius: BorderRadius.circular(40),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 20,
                    height: 20.5,
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
                  const SizedBox(width: 10),
                  Flexible(
                    child: Text(
                      message,
                      style: const TextStyle(
                        fontFamily: 'Pretendard',
                        fontSize: 18,
                        fontWeight: FontWeight.w400,
                        color: AppColors.white,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

