import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:travel_muse_app/models/home_place.dart';
import 'package:travel_muse_app/models/home_state.dart';
import 'package:travel_muse_app/models/place.dart';
import 'package:travel_muse_app/providers/location_provider.dart';
import 'package:travel_muse_app/services/nearby_place_service.dart';
import 'package:travel_muse_app/services/place_search_service.dart';

class HomeViewModel extends StateNotifier<AsyncValue<HomeState>> {
  HomeViewModel(this._ref, this._svc, this._placeSvc)
    : super(const AsyncLoading()) {
    _init();
  }

  final Ref _ref;
  final NearbyPlaceService _svc;
  final PlaceSearchService _placeSvc;

  //초기 로드
  Future<void> _init() async {
    try {
      final loc = await _ref.read(locationProvider.future);
      await load(loc);
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }

  //썸네일 병렬 로드 + 매핑
  Future<List<HomePlace>> _mapWithThumbs(List<Place> raw) async {
    final thumbs = await Future.wait(
      raw.map((p) => _placeSvc.getThumbnailCached(p.name)),
    );
    return [
      for (int i = 0; i < raw.length; i++)
        raw[i].toHome(
          thumb:
              thumbs[i] ??
              'https://cdn.pixabay.com/photo/2017/06/24/04/37/cloud-2436676_1280.jpg',
        ),
    ];
  }

  //첫 페이지 로드
  Future<void> load(LatLng loc) async {
    state = const AsyncLoading();

    state = await AsyncValue.guard(() async {
      final rawSpots = await _svc.fetchSpots(loc: loc, page: 1);
      final rawFoods = await _svc.fetchFoods(loc: loc, page: 1);

      final spots = await _mapWithThumbs(rawSpots);
      final foods = await _mapWithThumbs(rawFoods);

      return HomeState(spots: spots, foods: foods);
    });
  }

  List<HomePlace> getFilteredSpots(List<HomePlace> spots, String? selectedTag) {
    const tagCategoryMap = {
      '#힐링': ['자연', '산책', '강', '호수', '공원', '숲', '휴양', '계곡', '풍경', '정원', '드라이브', '힐링', '산', '둘레길', '도보여행', '전망대', '산책로', '야경', '피톤치드'],
      '#유적지': ['문화', '유적', '사적', '역사', '고궁', '성', '탑', '박물관', '기념관', '전통', '사찰', '고건축', '유교', '불교', '서원', '문화재', '유물', '전시관'],
      '#쇼핑': ['쇼핑', '백화점', '시장', '상점가', '아울렛', '쇼핑몰', '기념품', '로드샵', '브랜드', '테마거리', '먹자골목', '재래시장', '상권', '프리미엄아울렛'],
      '#가족과 함께': ['키즈', '아이', '어린이', '체험', '놀이공원', '동물원', '가족', '수목원', '전시', '테마파크', '공연', '체험학습', '동물', '아쿠아리움', '키즈카페', '실내놀이터'],
    };

    if (selectedTag == null) return spots;

    final keywords = tagCategoryMap[selectedTag] ?? [];
    return spots.where((p) => keywords.any((kw) => p.category.contains(kw))).toList();
  }
}
