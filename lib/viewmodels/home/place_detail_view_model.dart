import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:travel_muse_app/services/plan/google_palce_detail_service.dart';

class PlaceDetailViewModel
    extends StateNotifier<AsyncValue<Map<String, dynamic>?>> {
  PlaceDetailViewModel(this._ref) : super(const AsyncLoading());

  // ignore: unused_field
  final Ref _ref;
  final _service = GooglePlaceDetailService();

  Future<void> fetchDetail(
    String name,
    String address,
    double lat,
    double lng,
  ) async {
    state = const AsyncLoading();
    try {
      final result = await _service.getDetailByNameAndLatLng(
        name,
        address,
        lat,
        lng,
      );
      if (mounted) {
        state = AsyncValue.data(result);
      }
    } catch (e, st) {
      if (mounted) {
        state = AsyncValue.error(e, st);
      }
    }
  }

  /// 상태 초기화 (로딩 상태로 전환)
  void reset() {
    state = const AsyncLoading();
  }
}
