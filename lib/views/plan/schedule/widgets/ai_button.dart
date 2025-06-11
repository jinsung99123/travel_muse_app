import 'package:flutter/material.dart';
import 'package:travel_muse_app/views/plan/schedule/widgets/ground_circle_icon.dart';

class AiButton extends StatelessWidget {
  const AiButton({super.key, 
  // required this.onTap
  });
  // final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton.extended(
      onPressed: (){

      },
      backgroundColor: Colors.transparent,   // 그라데이션 넣기 위해 투명
      elevation: 0,
      label: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.white,Color(0xFF49CDFE), Color(0xFF1572FD)],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
          borderRadius: BorderRadius.all(Radius.circular(28)),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const GradientCircleIcon(size: 20),  
            const SizedBox(width: 8),
            const Text(
              'Ai 추천 받기',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w600,
                fontFamily: 'Pretendard',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
