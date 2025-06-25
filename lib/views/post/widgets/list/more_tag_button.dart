import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:travel_muse_app/constants/app_colors.dart';

class MoreTagButton extends StatelessWidget {
  const MoreTagButton({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        //
      },
      child: SizedBox(
        width: 44,
        height: 44,
        child: Center(
          child: SvgPicture.asset(
            'assets/icons/chevron-down.svg',
            height: 24,
            width: 24,
            colorFilter: ColorFilter.mode(AppColors.secondary[400]!, BlendMode.srcATop),
          ),
        ),
      ),
    );
  }
}
