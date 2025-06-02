import 'package:flutter/material.dart';

class OnboardingTab1 extends StatelessWidget {
  const OnboardingTab1({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text('닉네임을 입력해 주세요.', style: TextStyle(fontSize: 20)),
        SizedBox(height: 20),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: TextFormField(
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey, width: 1),
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
