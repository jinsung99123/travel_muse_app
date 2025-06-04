import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:travel_muse_app/models/calendar_model.dart';

class CalendarViewModel extends StateNotifier<CalendarState> {
  CalendarViewModel() : super(CalendarState(focusedDay: DateTime.now()));

  // 날짜를 선택하고 시작일과 종료일 상태를 갱신합니다
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

  // 선택된 날짜인지 여부를 반환
  bool isSelected(DateTime day) {
    return day == state.startDay || day == state.endDay;
  }

  // 선택된 날짜 범위 사이에 있는지 여부를 반환
  bool isBetween(DateTime day) {
    return state.startDay != null &&
        state.endDay != null &&
        day.isAfter(state.startDay!) &&
        day.isBefore(state.endDay!);
  }
}
