import 'package:flutter/material.dart';

class SnsLoginBar extends StatelessWidget {
  const SnsLoginBar({
    required this.sns,
    required this.backgroundColor,
    required this.textColor,
    required this.loginFunction,
    super.key,
  });

  final String sns;
  final Color backgroundColor;
  final Color textColor;
  final Future<void> Function() loginFunction;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        await loginFunction();
      },
      child: Container(
        height: 50,
        width: double.infinity,
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Center(
          child: Text(
            'Sign in with $sns',
            style: TextStyle(
              fontSize: 18,
              color: textColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
