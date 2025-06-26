import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:travel_muse_app/constants/app_colors.dart';
import 'package:travel_muse_app/providers/plan/calendar_location_provider.dart';
import 'package:travel_muse_app/providers/plan/calendar_provider.dart';
import 'package:travel_muse_app/providers/user/auth_view_model_provider.dart';
import 'package:travel_muse_app/views/plan/plan/schedule/schedule_page.dart';

class SaveButton extends ConsumerWidget {
  const SaveButton({
    super.key,
    required this.selectedIndex,
    required this.districts,
    required this.selectedProvince,
  });
  final int? selectedIndex;
  final List<String> districts;
  final String selectedProvince;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor:
              selectedIndex == null ? Colors.grey : AppColors.primary[300],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        onPressed:
            selectedIndex == null
                ? null
                : () async {
                  await _handleSave(context, ref);
                },
        child: const Text(
          '저장',
          style: TextStyle(fontSize: 16, color: Colors.white),
        ),
      ),
    );
  }

  Future<void> _handleSave(BuildContext context, WidgetRef ref) async {
    final selectedDistrict = districts[selectedIndex!];

    final calendarState = ref.watch(calendarViewModelProvider);
    print(
      'SaveButton _handleSave: startDay=${calendarState.startDay}, endDay=${calendarState.endDay}',
    );
    final locationViewModel = ref.read(
      calendarLocationViewModelProvider.notifier,
    );

    locationViewModel.setRegion('$selectedProvince $selectedDistrict');

    // startDay가 null이면 endDay 값으로 대체, 둘 다 null이면 저장 불가
    final startDay = calendarState.startDay ?? calendarState.endDay;
    final endDay = calendarState.endDay ?? calendarState.startDay;

    if (startDay != null && endDay != null) {
      locationViewModel.setDateRange(startDay, endDay);
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('날짜를 먼저 선택해주세요')));
      return;
    }

    try {
      final userId = ref.read(authViewModelProvider).user?.uid;

      if (userId == null) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('로그인 정보가 없습니다.')));
        return;
      }

      final planId = await locationViewModel.createAndSavePlan();

      if (!context.mounted) return;

      await Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => SchedulePage(userId: userId, planId: planId),
        ),
      );
    } catch (e) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('저장 중 오류가 발생했습니다: $e')));
    }
  }
}
