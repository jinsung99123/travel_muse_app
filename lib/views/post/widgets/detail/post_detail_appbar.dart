import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:travel_muse_app/views/widgets/custom_app_bar.dart';

CustomAppBar buildPostDetailAppBar(VoidCallback onMoreTap) {
  return CustomAppBar(
    title: '',
    actions: [
      GestureDetector(
        onTap: onMoreTap,
        child: Padding(
          padding: const EdgeInsets.only(right: 12),
          child: Container(
            width: 44,
            height: 44,
            color: Colors.transparent,
            child: SvgPicture.asset(
              'assets/icons/more-vertical.svg',
              width: 24,
              height: 24,
              fit: BoxFit.scaleDown,
            ),
          ),
        ),
      ),
    ],
  );
}
