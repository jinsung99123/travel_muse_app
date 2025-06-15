import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:travel_muse_app/models/plans.dart';
import 'package:travel_muse_app/repositories/calendar_location_repository.dart';
import 'package:travel_muse_app/viewmodels/calendar_location_view_model.dart';

final calendarLocationRepositoryProvider = Provider<CalendarLocationRepository>(
  (ref) => CalendarLocationRepository(),
);

final calendarLocationViewModelProvider =
    StateNotifierProvider<CalendarLocationViewModel, PlanState>((ref) {
      return CalendarLocationViewModel(ref);
    });

final nearestPlanProvider = FutureProvider.family<Plans?, String>((
  ref,
  userId,
) {
  final repository = ref.watch(calendarLocationRepositoryProvider);
  return repository.fetchNearestFuturePlan(userId);
});
