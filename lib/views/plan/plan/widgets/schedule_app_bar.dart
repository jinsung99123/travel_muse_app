import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:travel_muse_app/constants/app_colors.dart';
import 'package:travel_muse_app/core/widgets/custom_toast.dart';
import 'package:travel_muse_app/providers/plan/schedule/schedule_provider.dart';
import 'package:travel_muse_app/views/plan/location/map_page.dart';
import 'package:travel_muse_app/views/plan/plan/schedule/widgets/schedule_confirm_dialog.dart';

class ScheduleAppBar extends ConsumerWidget implements PreferredSizeWidget {
  const ScheduleAppBar({super.key, required this.planId});

  final String planId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AppBar(
      leading: GestureDetector(
        onTap: () async {
          final shouldPop = await showDialog<bool>(
            context: context,
            builder:
                (context) => const ScheduleConfirmDialog(
                  title: '일정 등록 화면에서 나가시겠습니까?',
                  description: '지금 나가면 일정이 저장되지 않아요',
                ),
          );

          if (shouldPop == true) {
            Navigator.of(context).pop();
          }
        },

        child: Container(
          padding: EdgeInsets.only(top: 4),
          width: 44,
          height: 44,
          color: Colors.transparent,
          child: SvgPicture.asset(
            'assets/icons/chevron-left.svg',
            width: 24,
            height: 24,
            fit: BoxFit.scaleDown,
          ),
        ),
      ),

      title: Text(
        '여행 일정 등록',
        style: TextStyle(
          color: AppColors.grey[800],
          fontSize: 18,
          fontFamily: 'Pretendard',
          fontWeight: FontWeight.w700,
        ),
      ),
      centerTitle: true,
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 16),
          child: GestureDetector(
            child: SvgPicture.asset(
              'assets/icons/map.svg',
              width: 28,
              height: 28,
            ),
            onTap: () async {
              final hasRoute = await ref
                  .read(scheduleViewModelProvider.notifier)
                  .hasRoute(planId);

              if (!hasRoute) {
                if (context.mounted) {
                  CustomToast.show(
                    context: context,
                    message: '일정을 먼저 등록해주세요.',
                    duration: const Duration(seconds: 2),
                  );
                }
                return;
              }

              //여행일수 계산
              final tripDays = await ref
                  .read(scheduleViewModelProvider.notifier)
                  .getTripDays(planId);

              if (tripDays >= 10) {
                if (context.mounted) {
                  CustomToast.show(
                    context: context,
                    message: '10일 이상 일정은 지도로 확인할 수 없어요.',
                    duration: const Duration(seconds: 2),
                  );
                }
                return;
              }
              if (context.mounted) {
                await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => MapPage(planId: planId)),
                );
              }
            },
          ),
        ),
      ],
      backgroundColor: Colors.white,
      foregroundColor: Colors.black,
      elevation: 0.5,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

