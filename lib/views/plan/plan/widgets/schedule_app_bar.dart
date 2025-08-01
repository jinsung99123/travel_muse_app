import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:travel_muse_app/constants/app_colors.dart';
import 'package:travel_muse_app/core/widgets/custom_toast.dart';
import 'package:travel_muse_app/providers/plan/calendar_location_provider.dart';
import 'package:travel_muse_app/providers/plan/schedule/map_provider.dart';
import 'package:travel_muse_app/providers/plan/schedule/schedule_provider.dart';
import 'package:travel_muse_app/views/plan/location/map_page.dart';
import 'package:travel_muse_app/views/plan/plan/location_setting/district_setting_page.dart';
import 'package:travel_muse_app/views/plan/plan/schedule/widgets/map_confirm_dialog.dart';
import 'package:travel_muse_app/views/plan/plan/schedule/widgets/schedule_confirm_dialog.dart';

class ScheduleAppBar extends ConsumerWidget implements PreferredSizeWidget {
  const ScheduleAppBar({
    super.key,
    required this.planId,
    this.daySchedules,
    this.isMapButtonEnabled = true,
  });

  final String planId;
  final Map<int, List<Map<String, String>>>? daySchedules;
  final bool isMapButtonEnabled;
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
            if (context.mounted) {
              final region =
                  ref.read(calendarLocationViewModelProvider).region ?? '';
              final selectedProvince =
                  region.isNotEmpty ? region.split(' ').first : '';

              await Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder:
                      (_) => DistrictSettingPage(
                        selectedProvince: selectedProvince,
                      ),
                ),
              );
            }
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
        if (isMapButtonEnabled && daySchedules != null)
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

                final isAllPlacesValid = await ref
                    .read(scheduleViewModelProvider.notifier)
                    .hasOnlyValidLatLng(planId);

                if (!isAllPlacesValid) {
                  if (context.mounted) {
                    await showDialog(
                      context: context,
                      builder:
                          (context) => const MapConfirmDialog(
                            title: '지도 확인 불가',
                            description:
                                '위치 정보가 없는 장소가 포함된 일정은\n지도로 확인할 수 없어요.\n일정삭제 후 다시 추가해주시고 24시간 후 다시 시도해주세요.',
                            confirmText: '확인',
                          ),
                    );
                  }
                  return;
                }

                if (context.mounted) {
                  await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder:
                          (_) => MapPage(planId: planId),
                    ),
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
