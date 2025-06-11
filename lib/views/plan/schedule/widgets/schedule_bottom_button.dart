import 'package:flutter/material.dart';

class ScheduleBottomButtons extends StatelessWidget {
  const ScheduleBottomButtons({super.key, 
  // required this.onEditTap
  });

  // final VoidCallback onEditTap;

  static const _blueGrad = LinearGradient(
    colors: [Color(0xFF42A5FF), Color(0xFF67C5FF)],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  );

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
      child: GestureDetector(
        // onTap: onEditTap,
        child: Container(
          height: 48,
          width: double.infinity,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            gradient: _blueGrad,
            borderRadius: BorderRadius.circular(10),
          ),
          child: const Text(
            '일정 수정하기',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w600,
              fontFamily: 'Pretendard',
            ),
          ),
        ),
      ),
    );
  }
}
