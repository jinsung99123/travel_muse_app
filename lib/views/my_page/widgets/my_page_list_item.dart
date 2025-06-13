import 'package:flutter/material.dart';
import 'package:travel_muse_app/constants/app_colors.dart';

class MyPageListItem extends StatelessWidget {
  const MyPageListItem({
    super.key,
    required this.dbList,
    required this.index,
    required this.onTap,
  });

  final List<String> dbList;
  final int index;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // onTap
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        decoration: ShapeDecoration(
          shape: RoundedRectangleBorder(
            side: BorderSide(
              width: 1,
              strokeAlign: BorderSide.strokeAlignOutside,
              color: AppColors.grey[50]!,
            ),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              dbList[index],
              style: TextStyle(
                color: AppColors.black,
                fontSize: 16,
                fontFamily: 'Pretendard',
                fontWeight: FontWeight.w600,
                height: 1.50,
              ),
            ),
            const Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: Colors.black54,
            ),
          ],
        ),
      ),
    );
  }
}
