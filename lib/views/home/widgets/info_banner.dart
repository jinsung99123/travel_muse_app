import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:travel_muse_app/providers/calendar_location_provider.dart';

class InfoBanner extends ConsumerWidget {
  const InfoBanner({super.key, required this.userId});
  final String userId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncPlan = ref.watch(nearestPlanProvider(userId));

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: asyncPlan.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => const Text('🚫 여행 정보를 불러올 수 없습니다.'),
        data: (plan) {
          if (plan == null) {
            return const Text('예정된 여행이 없습니다.');
          }

          final now = DateTime.now();
          final daysLeft = plan.startDate.difference(now).inDays;
          final formattedStart = DateFormat(
            'M.d (E)',
            'ko_KR',
          ).format(plan.startDate);
          final formattedEnd = DateFormat(
            'M.d (E)',
            'ko_KR',
          ).format(plan.endDate);
          final duration = plan.endDate.difference(plan.startDate).inDays + 1;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '사용자님,\n${plan.title.isNotEmpty ? plan.title : plan.region} 여행까지 ${daysLeft}일 남았어요!',
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF26272A),
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                '${duration - 1}박 $duration일 | $formattedStart - $formattedEnd',
                style: const TextStyle(
                  fontSize: 14,
                  color: Color(0xFF7C878C),
                  fontWeight: FontWeight.w400,
                ),
              ),
              TextButton(
                onPressed: () {
                  // TODO: 여행 상세보기 페이지로 이동
                },
                style: TextButton.styleFrom(padding: EdgeInsets.zero),
                child: const Text(
                  '자세히 보기',
                  style: TextStyle(fontSize: 14, color: Color(0xFF98A0A4)),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
