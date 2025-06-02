import 'package:flutter/material.dart';

class OnboardingTabImage extends StatelessWidget {
  const OnboardingTabImage({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text('프로필 사진을 설정해 주세요.', style: TextStyle(fontSize: 20)),
        SizedBox(height: 20),
        GestureDetector(
          onTap: () {},
          child: Container(
            width: 180,
            height: 180,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(100),
              color: Colors.grey,
            ),
            child: Icon(Icons.image, size: 60),
          ),
        ),
      ],
    );
  }
}
