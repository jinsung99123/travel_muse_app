import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:quiver/collection.dart' as quiver;
import 'package:travel_muse_app/models/plan/place.dart';
import 'package:travel_muse_app/providers/plan/schedule/recent_search_provider.dart';
import 'package:travel_muse_app/providers/plan/schedule/search_provider.dart';

/// 캐시용 래퍼 클래스
//   - value: 실제 캐싱 데이터
//   - createdAt: 삽입 시각 (TTL 판정용)
class _CacheItem<T> {
  _CacheItem(this.value) : createdAt = DateTime.now();
  final T value;
  final DateTime createdAt;
}

/// 간단 토큰 버킷(rate‑limit) 구현
//   capacity 만큼 토큰을 들고 시작 -> period(1초)마다 재충전
//   take() 호출로 토큰 확보, 없으면 대기큐에 들어감
class _RateLimiter {
  _RateLimiter(this.capacity, this.period)
      : _tokens = capacity,
        _last = DateTime.now() {
    _timer = Timer.periodic(period, (_) => _refill());
  }

  final int capacity;          
  final Duration period;      

  int _tokens;
  DateTime _last;
  final _queue = <Completer<void>>[];

  late final Timer _timer;     
  void dispose() => _timer.cancel();

  Future<void> take() {
    final c = Completer<void>();
    if (_tokens > 0) {
      _tokens--;
      c.complete();
    } else {
      _queue.add(c);
    }
    return c.future;
  }

  ///타이머에서 호출 ― 토큰 충전 & 대기열 해제
  void _refill() {
    _tokens = capacity;
    _last = DateTime.now();
    while (_tokens > 0 && _queue.isNotEmpty) {
      _tokens--;
      _queue.removeAt(0).complete();
    }
  }
}


class PlaceSearchService {
  static const _baseKeywordUrl =
      'https://dapi.kakao.com/v2/local/search/keyword.json';
  static const _baseCategoryUrl =
      'https://dapi.kakao.com/v2/local/search/category.json';
  static const _baseImageUrl = 'https://dapi.kakao.com/v2/search/image';
  static final String _apiKey = 'KakaoAK ${dotenv.env['KAKAO_API_KEY'] ?? ''}';

  static final _searchCache = quiver.LruMap<String, _CacheItem<List<Place>>>(
    maximumSize: 500,
  );
  static final _addrCache = quiver.LruMap<String, _CacheItem<LatLng?>>(
    maximumSize: 500,
  );
  static const _cacheTTL = Duration(hours: 24);
  static bool _isExpired(DateTime t) =>
      DateTime.now().difference(t) > _cacheTTL;

  static final _limiter = _RateLimiter(5, const Duration(seconds: 1));

  /// 위치 상관없는 키워드 검색
  Future<List<Place>> search(String query) async {
    final url = Uri.parse(
      '$_baseKeywordUrl?query=${Uri.encodeQueryComponent(query)}',
    );
    return _requestPlaces(url);
  }

  /// 내 위치 기준 키워드 검색
  Future<List<Place>> searchByKeyword({
    required String query,
    required double lat,
    required double lng,
    int radius = 10000,
    int page = 1,
    int size = 15,
  }) async {
    final url = Uri.parse(
      '$_baseKeywordUrl?query=${Uri.encodeQueryComponent(query)}&y=$lat&x=$lng&radius=$radius&page=$page&size=$size&sort=distance',
    );
    return _requestPlaces(url);
  }

  /// 카테고리(AT4, FD6 등) 검색
  Future<List<Place>> searchByCategory({
    required String categoryCode,
    required double lat,
    required double lng,
    int radius = 10000,
    int page = 1,
    int size = 15,
  }) async {
    final url = Uri.parse(
      '$_baseCategoryUrl?category_group_code=$categoryCode&y=$lat&x=$lng&radius=$radius&page=$page&size=$size&sort=distance',
    );
    return _requestPlaces(url);
  }

  /// 내부 공통 로직: 캐시 -> 리미트 -> 네트워크
  Future<List<Place>> _requestPlaces(Uri url) async {
  final key = url.toString();

  // 캐시 확인
  final cached = _searchCache[key];
  if (cached != null && !_isExpired(cached.createdAt)) return cached.value;

  // 레이트리미터 통과
  await _limiter.take();

  try {
    // 카카오 API 호출
    final res = await http.get(
      url,
      headers: {'Authorization': _apiKey, 'User-Agent': 'TravelMuse/1.0'},
    );

    // 429 또는 오류 처리
    if (res.statusCode == 429) {
      debugPrint('Kakao 429 Too Many Requests → ${url.path}');
      return [];
    }
    if (res.statusCode != 200) {
      throw Exception('Kakao API 실패: ${res.statusCode}');
    }

    // 결과 파싱
    final docs = (json.decode(res.body)['documents'] as List<dynamic>)
        .map((e) => Place.fromKakaoJson(e))
        .toList();

    // 결과가 있을 때만 캐시
    if (docs.isNotEmpty) {
      _searchCache[key] = _CacheItem(docs);
    }

    return docs;
  } catch (e) {
    debugPrint('Kakao 요청 오류: $e');
    return [];
  }
}

  /// 썸네일(키워드당 1장) 캐시
  static final _thumbCache =
    quiver.LruMap<String, _CacheItem<String>>(maximumSize: 1000);

  ///썸네일
 Future<String?> fetchImageThumbnail(String keyword) async {
  await _limiter.take();
  final url = Uri.parse(
    '$_baseImageUrl?query=${Uri.encodeQueryComponent(keyword)}&size=1',
  );

  for (var attempt = 0; attempt < 3; attempt++) {
    try {
      final res = await http.get(
        url,
        headers: {
          'Authorization': _apiKey,
          'User-Agent': 'TravelMuse/1.0',
          'Connection': 'close'         
        },
      );
      if (res.statusCode == 200) {
        final docs = json.decode(res.body)['documents'] as List<dynamic>;
        return docs.isNotEmpty ? docs[0]['thumbnail_url'] as String : null;
      }
      if (res.statusCode == 429) return null; 
    } on HttpException catch (e) {
      debugPrint('썸네일 재시도 $attempt: $e');
      await Future.delayed(const Duration(milliseconds: 100));
    }
  }
  return null; // 3회 실패
}


  Future<String?> getThumbnailCached(String keyword) async {
  final cached = _thumbCache[keyword];
  if (cached != null && !_isExpired(cached.createdAt)) return cached.value;

  final url = await fetchImageThumbnail(keyword);
  if (url != null) _thumbCache[keyword] = _CacheItem(url);   
  return url;
}

  /// 주소 -> 좌표 변환
  Future<LatLng?> getLatLngFromRegion(String region) async {
    final key = 'addr:$region';
    final cached = _addrCache[key];
    if (cached != null && !_isExpired(cached.createdAt)) return cached.value;

    await _limiter.take();
    final url = Uri.parse(
      'https://dapi.kakao.com/v2/local/search/address.json?query=${Uri.encodeQueryComponent(region)}',
    );
    try {
      final res = await http.get(
        url,
        headers: {'Authorization': _apiKey, 'User-Agent': 'TravelMuse/1.0'},
      );
      if (res.statusCode == 429) {
        debugPrint('Kakao 주소->좌표 429: $region');
        return null;
      }
      if (res.statusCode != 200) return null;
      final docs = json.decode(res.body)['documents'] as List<dynamic>;
      if (docs.isEmpty) return null;
      final lat = double.tryParse(docs[0]['y']) ?? 0;
      final lng = double.tryParse(docs[0]['x']) ?? 0;
      final coord = LatLng(lat, lng);
      _addrCache[key] = _CacheItem(coord);
      return coord;
    } catch (e) {
      debugPrint('주소->좌표 실패: $e');
      return null;
    }
  }

  ///최근 검색어 저장
  static void performSearch(WidgetRef ref, String region, String query) {
    final trimmed = query.trim();
    if (trimmed.isEmpty) return;
    ref.read(recentSearchProvider.notifier).add(trimmed);
    ref.read(searchViewModelProvider.notifier).search(trimmed, region: region);
  }
}
