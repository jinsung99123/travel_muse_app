import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:travel_muse_app/models/calendar_model.dart';
import 'package:travel_muse_app/providers/calendar_repository_provider.dart';

class CalendarViewModel extends StateNotifier<CalendarState> {
  CalendarViewModel(this.ref)
    : super(CalendarState(focusedDay: DateTime.now()));
  final Ref ref;

  void selectDay(DateTime selectedDay, DateTime newFocusedDay) {
    if (state.startDay == null ||
        (state.startDay != null && state.endDay != null)) {
      state = state.copyWith(
        startDay: selectedDay,
        endDay: null,
        focusedDay: newFocusedDay,
      );
    } else if (state.startDay != null && state.endDay == null) {
      if (selectedDay.isBefore(state.startDay!)) {
        state = state.copyWith(
          startDay: selectedDay,
          endDay: state.startDay,
          focusedDay: newFocusedDay,
        );
      } else if (selectedDay == state.startDay!) {
        state = state.copyWith(
          startDay: selectedDay,
          endDay: null,
          focusedDay: newFocusedDay,
        );
      } else {
        state = state.copyWith(
          startDay: state.startDay,
          endDay: selectedDay,
          focusedDay: newFocusedDay,
        );
      }
    }
  }

  bool isSelected(DateTime day) {
    return day == state.startDay || day == state.endDay;
  }

  bool isBetween(DateTime day) {
    return state.startDay != null &&
        state.endDay != null &&
        day.isAfter(state.startDay!) &&
        day.isBefore(state.endDay!);
  }

  Future<void> saveTravelPlan(String planId) async {
    final start = state.startDay;
    final end = state.endDay;

    if (start != null && end != null) {
      final repo = ref.read(calendarRepositoryProvider);
      await repo.updatePlanDates(
        planId: planId,
        startDate: start,
        endDate: end,
      );
    } else {
      throw Exception("날짜가 선택되지 않았습니다.");
    }
  }
}
