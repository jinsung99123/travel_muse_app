import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class NextButton extends StatelessWidget {
  const NextButton({super.key, required this.onPressed, required this.enabled});
  final VoidCallback onPressed;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 18, 16, 17),
      child: SizedBox(
        width: double.infinity,
        height: 56,
        child: CupertinoButton(
          padding: EdgeInsets.zero,
          borderRadius: BorderRadius.circular(10),
          color: enabled ? const Color(0xFF15BFFD) : const Color(0xFFCED2D3),
          onPressed: enabled ? onPressed : null,
          child: Text(
            '다음',
            style: TextStyle(
              color: Colors.white.withOpacity(enabled ? 1.0 : 0.6),
              fontSize: 18,
              fontWeight: FontWeight.w600,
              fontFamily: 'Pretendard',
            ),
          ),
        ),
      ),
    );
  }
}
