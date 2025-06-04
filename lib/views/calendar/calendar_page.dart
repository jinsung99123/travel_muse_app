import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:travel_muse_app/providers/calendar_provider.dart';
import 'package:travel_muse_app/views/calendar/widgets/calendar_header.dart';
import 'package:travel_muse_app/views/calendar/widgets/calendar_widget.dart';

class CalendarPage extends ConsumerWidget {
  const CalendarPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final viewModel = ref.watch(calendarViewModelProvider.notifier);
    final state = ref.watch(calendarViewModelProvider);

    return Scaffold(
      appBar: CalendarHeader(focusedDay: state.focusedDay),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: CalendarWidget(
          state: state,
          isSelected: viewModel.isSelected,
          isBetween: viewModel.isBetween,
          onDaySelected: viewModel.selectDay,
        ),
      ),
    );
  }
}
