import 'package:flutter/material.dart';
import 'package:travel_muse_app/constants/app_colors.dart';
import 'package:travel_muse_app/core/widgets/svg_icon.dart';
import 'package:travel_muse_app/views/my_page/plan_list_page.dart';
import 'package:travel_muse_app/views/plan/plan/calendar/calendar_page.dart';

class TravelRegisterButton extends StatelessWidget {
  const TravelRegisterButton({super.key});

  @override
  Widget build(BuildContext context) {
    const double horizontalPadding = 16;
    const double buttonGap = 20;
    const double buttonHeight = 101;

    final double screenWidth = MediaQuery.of(context).size.width;

    final double buttonWidth =
        (screenWidth - (horizontalPadding * 2) - buttonGap) / 2;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: horizontalPadding),
      child: Row(
        children: [
          SizedBox(
            width: buttonWidth,
            height: buttonHeight,
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const PlanListPage()),
                );
              },
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  border: Border.all(color: AppColors.grey[200]!),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Stack(
                  children: [
                    Align(
                      alignment: Alignment.topRight,
                      child: Text(
                        '여행 일정\n변경',
                        textAlign: TextAlign.right,
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w600,
                          color: AppColors.grey[600],
                          height: 1.1,
                        ),
                      ),
                    ),
                    Positioned(
                      left: 0,
                      bottom: 0,
                      child: SvgIcon.edit(width: 48, height: 48),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(width: buttonGap),
          SizedBox(
            width: buttonWidth,
            height: buttonHeight,
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const CalendarPage()),
                );
              },
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.primary[300],
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
                          color: AppColors.white,
                          height: 1.1,
                        ),
                      ),
                    ),
                    Positioned(
                      left: 0,
                      bottom: 0,
                      child: SvgIcon.register(width: 43.5, height: 48),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
