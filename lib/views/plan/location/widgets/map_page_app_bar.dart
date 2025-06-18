import 'package:flutter/material.dart';
import 'package:travel_muse_app/constants/app_colors.dart';

class MapPageAppBar extends StatelessWidget implements PreferredSizeWidget {
  const MapPageAppBar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      leading: IconButton(
        icon: Icon(Icons.chevron_left, color: AppColors.grey[500],
        size: 24,),
        onPressed: () => Navigator.pop(context),
      ),
      centerTitle: false,
      titleSpacing: 0,
      title: Text(
        '지도',
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w700,
          color: AppColors.grey[800],
          fontFamily: 'Pretendard'
        ),
      ),
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(1),
        child: Container(
          height: 1,
          color: Colors.grey.shade300,
        ),
      ),
    );
  }
}
