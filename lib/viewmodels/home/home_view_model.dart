import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:travel_muse_app/models/home/home_place.dart';
import 'package:travel_muse_app/models/home/home_state.dart';
import 'package:travel_muse_app/models/plan/place.dart';
import 'package:travel_muse_app/providers/plan/schedule/location_provider.dart';
import 'package:travel_muse_app/services/plan/nearby_place_service.dart';
import 'package:travel_muse_app/services/plan/place_search_service.dart';

class HomeViewModel extends StateNotifier<AsyncValue<HomeState>> {
  HomeViewModel(this._ref, this._svc, this._placeSvc)
    : super(const AsyncLoading()) {
    _init();
  }

  final Ref _ref;
  final NearbyPlaceService _svc;
  final PlaceSearchService _placeSvc;

  static const LatLng kFallbackLatLng = LatLng(37.5662952, 126.9779451);

  //초기 로드
  Future<void> _init() async {
    try {
      // 위치 권한 GPS 오류가 나면 catch 블록에서 폴백 좌표 사용
      final loc = await _ref.read(locationProvider.future);
      await load(loc);
    } catch (_) {
      // 권한 OFF 실패 시 기본 좌표로 추천 불러오기
      await load(kFallbackLatLng);
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
  Future<void> load(LatLng loc, {String? categoryCode}) async {
    state = const AsyncLoading();

    state = await AsyncValue.guard(() async {
      final rawSpots = await _svc.fetchSpotsByCategory(
        loc: loc,
        categoryCode: categoryCode ?? 'AT4',
        page: 1,
      );
      final rawFoods = await _svc.fetchFoods(loc: loc, page: 1);

      final spots = await _mapWithThumbs(rawSpots);
      final foods = await _mapWithThumbs(rawFoods);

      return HomeState(
        originalSpots: spots, // AT4 원본 저장
        spots: spots,
        foods: foods,
      );
    });
  }

/// 선택된 태그에 따라 장소 리스트를 필터링
  List<HomePlace> getFilteredSpots(List<HomePlace> spots, String? selectedTag) {
    if (selectedTag == null || selectedTag == '#전체') return spots;

    const categoryCodeMap = {'#카페': 'CE7', '#가볼만한 곳': 'CT1'};

    const tagKeywordMap = {
      '#힐링': [
        '자연',
        '산책',
        '강',
        '호수',
        '공원',
        '숲',
        '휴양',
        '계곡',
        '풍경',
        '정원',
        '드라이브',
        '힐링',
        '산',
        '둘레길',
        '도보여행',
        '전망대',
        '산책로',
        '야경',
        '피톤치드',
        '키즈',
        '아이',
        '어린이',
        '체험',
        '놀이공원',
        '동물원',
        '가족',
        '수목원',
        '전시',
        '테마파크',
        '공연',
        '체험학습',
        '동물',
        '아쿠아리움',
        '키즈카페',
        '실내놀이터',
        '쇼핑',
        '백화점',
        '시장',
        '상점가',
        '아울렛',
        '쇼핑몰',
        '기념품',
        '로드샵',
        '브랜드',
        '테마거리',
        '먹자골목',
        '재래시장',
        '상권',
        '프리미엄아울렛',
      ],
      '#유적지': [
        '문화',
        '유적',
        '사적',
        '역사',
        '고궁',
        '성',
        '탑',
        '박물관',
        '기념관',
        '전통',
        '사찰',
        '고건축',
        '유교',
        '불교',
        '서원',
        '문화재',
        '유물',
        '전시관',
      ],
      '#쇼핑': [
        '쇼핑',
        '백화점',
        '시장',
        '상점가',
        '아울렛',
        '쇼핑몰',
        '기념품',
        '로드샵',
        '브랜드',
        '테마거리',
        '먹자골목',
        '재래시장',
        '상권',
        '프리미엄아울렛',
      ],
      '#가족과 함께': [
        '키즈',
        '아이',
        '어린이',
        '체험',
        '놀이공원',
        '동물원',
        '가족',
        '수목원',
        '전시',
        '테마파크',
        '공연',
        '체험학습',
        '동물',
        '아쿠아리움',
        '키즈카페',
        '실내놀이터',
        '놀이터',
        '놀이',
        '가족',
        '테마',
      ],
    };
    if (categoryCodeMap.containsKey(selectedTag)) {
      final code = categoryCodeMap[selectedTag];
      return spots.where((p) => p.categoryCode?.toUpperCase() == code).toList();
    }

    final keywords = tagKeywordMap[selectedTag] ?? [];
    return spots
        .where((p) => keywords.any((k) => p.category.contains(k)))
        .toList();
  }

/// 선택된 태그에 따라 장소 리스트를 다시 로드
/// - `#자연`, `#카페`, `#가볼만한 곳` 태그는 categoryCode를 기반으로 장소 데이터를 새로 불러옴
/// 장소 데이터는 썸네일과 함께 매핑된 후 상태(state)에 반영됩니다.
  Future<void> reloadWithTag(String selectedTag) async {
    const categoryCodeMap = {'#자연': 'AT4', '#카페': 'CE7', '#가볼만한 곳': 'CT1'};

    final code = categoryCodeMap[selectedTag];
    final loc = await _ref.read(locationProvider.future);

    if (code != null) {
      final raw = await _svc.fetchSpotsByCategory(loc: loc, categoryCode: code);
      final mapped = await _mapWithThumbs(raw);

      final current = state.value;
      if (current != null) {
        state = AsyncValue.data(
          current.copyWith(spots: mapped), 
        );
      }
    } else {
      // 코드 없을 땐 원래 AT4 원본에서 다시 보여줌
      final current = state.value;
      if (current != null) {
        state = AsyncValue.data(current.copyWith(spots: current.originalSpots));
      }
    }
  }
}
