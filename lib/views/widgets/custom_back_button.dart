import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CustomBackButton extends StatelessWidget {
  const CustomBackButton({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.of(context).maybePop(),

      child: Container(
        padding: EdgeInsets.only(top: 4),
        width: 44,
        height: 44,
        color: Colors.amber,
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
