import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:travel_muse_app/providers/calendar_provider.dart';
import 'package:travel_muse_app/views/calendar/widgets/calendar_widget.dart';
import 'package:travel_muse_app/views/plan/location_setting/province_setting_page.dart';

class CalendarPage extends ConsumerWidget {
  const CalendarPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final viewModel = ref.watch(calendarViewModelProvider.notifier);
    final state = ref.watch(calendarViewModelProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          '여행 일정 등록',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        backgroundColor: Colors.white,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  '여행할 날짜를 선택해주세요',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    fontFamily: 'Pretendard',
                  ),
                ),
              ),
              const SizedBox(height: 15),
              Expanded(
                child: ListView.builder(
                  itemCount: 12,
                  itemBuilder: (context, index) {
                    final focusedMonth = DateTime(
                      state.focusedDay.year,
                      state.focusedDay.month + index,
                    );

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
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ProvinceSettingPage(),
                      ),
                    );
                  },
                  child: const Text(
                    '다음',
                    style: TextStyle(fontSize: 16, color: Colors.white),
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
