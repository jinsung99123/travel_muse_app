import 'package:flutter/material.dart';

class ScrollBarIndicator extends StatelessWidget {
  const ScrollBarIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 375,
      height: 34,
      alignment: Alignment.bottomCenter,
      child: Transform.rotate(
        angle: 3.14,
        child: Container(
          width: 144,
          height: 5,
          decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.circular(100),
          ),
        ),
      ),
    );
  }
}
