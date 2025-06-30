import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:travel_muse_app/constants/app_colors.dart';
import 'package:travel_muse_app/providers/plan/calendar_provider.dart';
import 'package:travel_muse_app/utills/date_utils.dart';
import 'package:travel_muse_app/views/plan/plan/calendar/widgets/calendar_guide_text.dart';
import 'package:travel_muse_app/views/plan/plan/calendar/widgets/calendar_widget.dart';
import 'package:travel_muse_app/views/plan/plan/location_setting/province_setting_page.dart';
import 'package:travel_muse_app/views/widgets/custom_back_button.dart';

class CalendarPage extends ConsumerWidget {
  const CalendarPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final viewModel = ref.watch(calendarViewModelProvider.notifier);
    final state = ref.watch(calendarViewModelProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('여행 일정 등록'),
        leading: Navigator.canPop(context) ? const CustomBackButton() : null,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const CalendarGuideText(),
              const SizedBox(height: 24),
              Expanded(
                child: ListView.builder(
                  itemCount: 12,
                  itemBuilder: (context, index) {
                    final year =
                        state.focusedDay.year +
                        ((state.focusedDay.month + index - 1) ~/ 12);
                    final month = ((state.focusedDay.month + index - 1) % 12) + 1;

                    final focusedMonth = DateTime(year, month);

                    return Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: CalendarWidget(
                        month: focusedMonth,
                        isSelected: viewModel.isSelected,
                        isBetween: viewModel.isBetween,
                        onDaySelected: viewModel.selectDay,
                      ),
                    );
                  },
                ),
              ),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary[300],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: () {
                    final viewModel = ref.read(calendarViewModelProvider.notifier);
                    final state = ref.read(calendarViewModelProvider);

                    final start = state.startDay;
                    final end = state.endDay;

                    if (start != null) {
                      viewModel.ensureEndDay();

                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ProvinceSettingPage(),
                        ),
                      );
                    } else {
                      ScaffoldMessenger.of(
                        context,
                      ).showSnackBar(const SnackBar(content: Text('여행 날짜를 선택해주세요.')));
                    }
                  },

                  child: Text(
                    getButtonText(state.startDay, state.endDay),
                    style: const TextStyle(fontSize: 16, color: Colors.white),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
