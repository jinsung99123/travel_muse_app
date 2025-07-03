import 'package:flutter/material.dart';

class ActionItem extends StatelessWidget {
  const ActionItem({
    super.key,
    required this.label,
    required this.onTap,
    this.textColor,
  });

  final String label;
  final VoidCallback onTap;
  final Color? textColor;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: SizedBox(
        width: double.infinity,
        height: 60,
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              fontFamily: 'pretendard',
              fontSize: 16,
              fontWeight: FontWeight.w400,
              color: textColor ?? Colors.black,
            ),
          ),
        ),
      ),
    );
  }
}
