import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:travel_muse_app/repositories/calendar_location_repository.dart';
import 'package:travel_muse_app/viewmodels/calendar_location_view_model.dart';

final calendarLocationRepositoryProvider = Provider<CalendarLocationRepository>(
  (ref) {
    return CalendarLocationRepository();
  },
);

final calendarLocationViewModelProvider =
    StateNotifierProvider<CalendarLocationViewModel, PlanState>((ref) {
      return CalendarLocationViewModel(ref);
    });
