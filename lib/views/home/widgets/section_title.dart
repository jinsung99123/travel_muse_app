import 'package:flutter/material.dart';
import 'package:travel_muse_app/constants/app_colors.dart';

class SectionTitle extends StatelessWidget {
  const SectionTitle({super.key, required this.title, this.onMoreTap});

  final String title;
  final VoidCallback? onMoreTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              title,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: AppColors.black,
              ),
            ),
          ),
          if (onMoreTap != null)
            TextButton(
              onPressed: onMoreTap,
              style: TextButton.styleFrom(
                foregroundColor: AppColors.grey[300],
                padding: EdgeInsets.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                minimumSize: Size(0, 0),
              ),
              child: const Text('더보기 >', style: TextStyle(fontSize: 14)),
            ),
        ],
      ),
    );
  }
}
