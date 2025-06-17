import 'package:flutter/material.dart';

class AppbarButton extends StatelessWidget {
  const AppbarButton({
    super.key,
    required this.widget,
    required this.onPressed,
  });
  final Widget widget;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onPressed();
      },
      child: Container(
        width: 60,
        height: 60,
        color: Colors.transparent,
        child: Center(child: widget),
      ),
    );
  }
}
