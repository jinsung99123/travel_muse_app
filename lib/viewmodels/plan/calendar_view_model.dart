import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:travel_muse_app/models/plan/calendar_model.dart';

class CalendarViewModel extends StateNotifier<CalendarState> {
  CalendarViewModel() : super(CalendarState(focusedDay: DateTime.now()));

  /// startDay가 없거나, startDay와 endDay가 모두 있는 경우 → 새로운 선택 시작
  /// startDay만 있는 경우 → endDay 설정
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

  /// 특정 날짜가 선택된 날짜인지 여부
  bool isSelected(DateTime day) {
    return day == state.startDay || day == state.endDay;
  }

  /// 특정 날짜가 선택된 날짜 범위(startDay ~ endDay) 사이에 포함되는지 여부
  bool isBetween(DateTime day) {
    return state.startDay != null &&
        state.endDay != null &&
        day.isAfter(state.startDay!) &&
        day.isBefore(state.endDay!);
  }

  /// endDay가 null이면 startDay로 설정
  void ensureEndDay() {
    final start = state.startDay;
    final end = state.endDay;

    if (start != null && end == null) {
      state = state.copyWith(endDay: start);
    }
  }
}
