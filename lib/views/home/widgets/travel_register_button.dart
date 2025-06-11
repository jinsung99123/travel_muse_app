import 'package:flutter/material.dart';
import 'package:travel_muse_app/core/widgets/svg_icon.dart';
import 'package:travel_muse_app/views/plan/schedule/schedule_page.dart';

class TravelRegisterButton extends StatelessWidget {
  const TravelRegisterButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // 일정 변경 카드
        Expanded(
          child: Container(
            height: 101,
            margin: const EdgeInsets.only(right: 8),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: const Color(0xFFB3B9BC)),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Stack(
              children: [
                const Align(
                  alignment: Alignment.topRight,
                  child: Text(
                    '여행 일정\n변경',
                    textAlign: TextAlign.right,
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF4C5356),
                      height: 1.1,
                    ),
                  ),
                ),
                Positioned(
                  left: 0,
                  bottom: 0,
                  child: SvgIcon.edit(width: 36, height: 36),
                ),
              ],
            ),
          ),
        ),

        Expanded(
          child: GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const SchedulePage( userId: 'test-user', planId: 'test')),
              );
            },
            child: Container(
              height: 101,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF48CDFD),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Stack(
                children: [
                  const Align(
                    alignment: Alignment.topRight,
                    child: Text(
                      '여행 일정\n등록',
                      textAlign: TextAlign.right,
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                        height: 1.1,
                      ),
                    ),
                  ),
                  Positioned(
                    left: 0,
                    bottom: 0,
                    child: SvgIcon.register(width: 36, height: 36),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
