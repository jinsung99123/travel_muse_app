import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:travel_muse_app/constants/app_colors.dart';
import 'package:travel_muse_app/providers/plan/schedule/schedule_provider.dart';
import 'package:travel_muse_app/views/plan/location/map_page.dart';

class ScheduleAppBar extends ConsumerWidget implements PreferredSizeWidget {
  const ScheduleAppBar({super.key, required this.planId});

  final String planId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AppBar(
      leading: IconButton(
        icon: const Icon(Icons.chevron_left),
        onPressed: () => Navigator.of(context).pop(),
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
        IconButton(
          icon: const Icon(Icons.map_outlined),
           onPressed: () async {
            // route 존재 여부 체크
            final hasRoute = await ref
                .read(scheduleViewModelProvider.notifier)
                .hasRoute(planId);

            if (!hasRoute) {
              //없으면 스낵바만 띄우고 리턴
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('일정을 먼저 등록해주세요 🗓️')),
                );
              }
              return;
            }
            // 있으면 정상적으로 지도 페이지 push
            if (context.mounted) {
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => MapPage(planId: planId),
                ),
              );
            }
          },
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
