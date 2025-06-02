import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PreviousButton extends StatelessWidget {
  final VoidCallback onPressed;

  const PreviousButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: CupertinoButton(
        color: CupertinoColors.systemGrey,
        borderRadius: BorderRadius.circular(12),
        onPressed: onPressed,
        child: const Text('이전', style: TextStyle(color: Colors.white)),
      ),
    );
  }
}
