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
      } else {
        state = state.copyWith(endDay: selectedDay, focusedDay: newFocusedDay);
      }
    }
  }

  void goToPreviousMonth() {
    final prev = DateTime(state.focusedDay.year, state.focusedDay.month - 1, 1);
    state = state.copyWith(focusedDay: prev);
  }

  void goToNextMonth() {
    final next = DateTime(state.focusedDay.year, state.focusedDay.month + 1, 1);
    state = state.copyWith(focusedDay: next);
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
}
