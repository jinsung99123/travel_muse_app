import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:travel_muse_app/providers/calendar_location_provider.dart';

class InfoBanner extends ConsumerWidget {
  const InfoBanner({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final planState = ref.watch(calendarLocationViewModelProvider);
    final viewModel = ref.read(calendarLocationViewModelProvider.notifier);

    final start = planState.startDate;
    final end = planState.endDate;
    final region = planState.region;

    /// 여행까지 남은 날짜 계산
    String calculateRemainingDays(DateTime startDate) {
      final now = DateTime.now();
      final nowDate = DateTime(now.year, now.month, now.day);
      final startDateOnly = DateTime(
        startDate.year,
        startDate.month,
        startDate.day,
      );

      final diff = startDateOnly.difference(nowDate).inDays;

      if (diff > 0) {
        return '$diff일 남았어요!';
      } else if (diff == 0) {
        return '오늘부터 여행이에요!';
      } else {
        return '여행 중이에요!';
      }
    }

    String formatDate(DateTime date) {
      final formatter = DateFormat('M.d (E)', 'ko');
      return formatter.format(date);
    }

    String getMainRegion(String region) {
      return region.split(' ').first;
    }

    /// 여행 종료 여부 확인
    bool isTripFinished(DateTime endDate) {
      final now = DateTime.now();
      final today = DateTime(now.year, now.month, now.day);
      final tripEnd = DateTime(endDate.year, endDate.month, endDate.day);
      return tripEnd.isBefore(today);
    }

    /// 여행 정보가 없거나 지난 여행만 있을 경우
    if (start == null || end == null || region == null || isTripFinished(end)) {
      return const Padding(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Align(
          alignment: Alignment.centerLeft,
          child: Text(
            '예정된 여행이 없습니다.',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w700,
              color: Color(0xFF26272A),
              height: 1.5,
            ),
          ),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              '사용자님,\n${calculateRemainingDays(start) == '여행 중이에요!' || calculateRemainingDays(start) == '오늘부터 여행이에요!' ? '${getMainRegion(region)} ${calculateRemainingDays(start)}' : '${getMainRegion(region)} 여행까지 ${calculateRemainingDays(start)}'}',
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w700,
                color: Color(0xFF26272A),
                height: 1.5,
              ),
            ),
          ),
          const SizedBox(height: 4),
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              '${end.difference(start).inDays + 1}박 ${end.difference(start).inDays + 2}일 | ${formatDate(start)} - ${formatDate(end)}',
              style: const TextStyle(
                fontSize: 14,
                color: Color(0xFF7C878C),
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              // TODO: 상세보기 이동 로직 연결
            },
            style: TextButton.styleFrom(padding: EdgeInsets.zero),
            child: const Text(
              '자세히 보기',
              style: TextStyle(fontSize: 14, color: Color(0xFF98A0A4)),
            ),
          ),
        ],
      ),
    );
  }
}
