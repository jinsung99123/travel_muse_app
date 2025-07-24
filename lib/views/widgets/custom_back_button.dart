import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:travel_muse_app/core/bottom_nav_bar_provider.dart';

class CustomBackButton extends ConsumerWidget {
  const CustomBackButton({super.key, this.goHome});

  final bool? goHome;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GestureDetector(
      onTap: () {
        if (goHome == true) {
          ref.read(bottomNavBarProvider.notifier).state = 0;
          Navigator.of(context).popUntil((route) => route.isFirst);
        } else {
          Navigator.of(context).maybePop();
        }
      },

      child: Container(
        padding: EdgeInsets.only(top: 4),
        width: 44,
        height: 44,
        color: Colors.transparent,
        child: SvgPicture.asset(
          'assets/icons/chevron-left.svg',
          width: 24,
          height: 24,
          fit: BoxFit.scaleDown,
        ),
      ),
    );
  }
}
