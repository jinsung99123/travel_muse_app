import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:travel_muse_app/viewmodels/home/place_detail_view_model.dart';

/// 장소 상세정보를 가져오는 ViewModel Provider
final placeDetailViewModelProvider =
    StateNotifierProvider.autoDispose<PlaceDetailViewModel, AsyncValue<Map<String, dynamic>?>>(
  (ref) => PlaceDetailViewModel(ref),
);
