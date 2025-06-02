import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:travel_muse_app/views/preference/preference_test_page.dart';

class NextButton extends StatelessWidget {

  const NextButton({super.key, required this.onPressed});
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: CupertinoButton(
        color: kSecondaryColor,
        borderRadius: BorderRadius.circular(12),
        onPressed: onPressed,
        child: const Text('다음', style: TextStyle(color: Colors.white)),
      ),
    );
  }
}
