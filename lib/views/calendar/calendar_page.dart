import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:travel_muse_app/providers/calendar_provider.dart';
import 'package:travel_muse_app/views/calendar/widgets/calendar_header.dart';
import 'package:travel_muse_app/views/calendar/widgets/calendar_widget.dart';
import 'package:travel_muse_app/views/plan/location_setting/province_setting_page.dart';

class CalendarPage extends ConsumerWidget {
  const CalendarPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final viewModel = ref.watch(calendarViewModelProvider.notifier);
    final state = ref.watch(calendarViewModelProvider);

    return Scaffold(
      appBar: CalendarHeader(focusedDay: state.focusedDay),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  CalendarWidget(
                    state: state,
                    isSelected: viewModel.isSelected,
                    isBetween: viewModel.isBetween,
                    onDaySelected: viewModel.selectDay,
                  ),
                ],
              ),
              Column(
                children: [
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        padding: EdgeInsets.symmetric(vertical: 0),
                      ),
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
            ],
          ),
        ),
      ),
    );
  }
}
