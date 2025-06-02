import 'package:flutter_riverpod/flutter_riverpod.dart';

final calendarViewModelProvider =
    StateNotifierProvider<CalendarViewModel, CalendarState>(
      (ref) => CalendarViewModel(),
    );

class CalendarState {
  CalendarState({required this.focusedDay, this.startDay, this.endDay});
  final DateTime focusedDay;
  final DateTime? startDay;
  final DateTime? endDay;

  CalendarState copyWith({
    DateTime? focusedDay,
    DateTime? startDay,
    DateTime? endDay,
  }) {
    return CalendarState(
      focusedDay: focusedDay ?? this.focusedDay,
      startDay: startDay ?? this.startDay,
      endDay: endDay ?? this.endDay,
    );
  }
}

class CalendarViewModel extends StateNotifier<CalendarState> {
  CalendarViewModel() : super(CalendarState(focusedDay: DateTime.now()));

  // 날짜 선택 처리 (단일 선택 또는 범위 선택)
  void selectDay(DateTime selectedDay, DateTime newFocusedDay) {
    if (state.startDay == null ||
        (state.startDay != null && state.endDay != null)) {
      // 시작 날짜를 새로 지정하고 종료 날짜 초기화
      state = state.copyWith(
        startDay: selectedDay,
        endDay: null,
        focusedDay: newFocusedDay,
      );
    } else if (state.startDay != null && state.endDay == null) {
      // 종료 날짜를 지정하거나, 시작 날짜와 위치 바꿈
      if (selectedDay.isBefore(state.startDay!)) {
        state = state.copyWith(
          startDay: selectedDay,
          endDay: state.startDay,
          focusedDay: newFocusedDay,
        );
      } else {
        state = state.copyWith(endDay: selectedDay, focusedDay: newFocusedDay);
      }
    }
  }

  // 이전 달 보기
  void goToPreviousMonth() {
    final prev = DateTime(state.focusedDay.year, state.focusedDay.month - 1, 1);
    state = state.copyWith(focusedDay: prev);
  }

  // 다음 달 보기
  void goToNextMonth() {
    final next = DateTime(state.focusedDay.year, state.focusedDay.month + 1, 1);
    state = state.copyWith(focusedDay: next);
  }

  // 특정 날짜가 선택된 시작일 또는 종료일인지 체크
  bool isSelected(DateTime day) {
    return day == state.startDay || day == state.endDay;
  }

  // 특정 날짜가 시작일과 종료일 사이에 있는지 체크
  bool isBetween(DateTime day) {
    return state.startDay != null &&
        state.endDay != null &&
        day.isAfter(state.startDay!) &&
        day.isBefore(state.endDay!);
  }
}
