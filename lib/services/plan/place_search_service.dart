import 'dart:async';
import 'dart:convert';
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
  _RateLimiter(this.capacity, this.period) // 최초 토큰량 = capacity
    : _tokens = capacity,
      _last = DateTime.now();
  final int capacity; // 버킷 크기 (5)
  final Duration period; // 리필 주기 (1초)

  int _tokens; // 남은 토큰 수
  DateTime _last; // 마지막 리필 시각
  final _queue = <Completer<void>>[]; // 대기

  Future<void> take() {
    _refill();
    final c = Completer<void>();
    if (_tokens > 0) {
      _tokens--;
      c.complete();
    } else {
      _queue.add(c);
    }
    return c.future;
  }

  /// 토큰 재충전 + 대기 해제
  void _refill() {
    final now = DateTime.now();
    if (now.difference(_last) >= period) {
      _tokens = capacity;
      _last = now;
      while (_tokens > 0 && _queue.isNotEmpty) {
        _tokens--;
        _queue.removeAt(0).complete();
      }
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
    final cached = _searchCache[key];
    if (cached != null && !_isExpired(cached.createdAt)) return cached.value;

    await _limiter.take();
    try {
      final res = await http.get(
        url,
        headers: {'Authorization': _apiKey, 'User-Agent': 'TravelMuse/1.0'},
      );
      if (res.statusCode == 429) {
        debugPrint('Kakao 429 Too Many Requests → ${url.path}');
        return [];
      }
      if (res.statusCode != 200) {
        throw Exception('Kakao API 실패: ${res.statusCode}');
      }
      final docs =
          (json.decode(res.body)['documents'] as List<dynamic>)
              .map((e) => Place.fromKakaoJson(e))
              .toList();
      _searchCache[key] = _CacheItem(docs);
      return docs;
    } catch (e) {
      debugPrint('Kakao 요청 오류: $e');
      return [];
    }
  }

  /// 썸네일(키워드당 1장) 캐시
  final Map<String, String> _thumbCache = {}; // keyword -> url

  Future<String?> fetchImageThumbnail(String keyword) async {
    final url = Uri.parse(
      '$_baseImageUrl?query=${Uri.encodeQueryComponent(keyword)}&size=1',
    );
    try {
      final res = await http.get(
        url,
        headers: {'Authorization': _apiKey, 'User-Agent': 'TravelMuse/1.0'},
      );
      if (res.statusCode == 429) {
        debugPrint('Kakao 이미지 429: $keyword');
        return null;
      }
      if (res.statusCode != 200) return null;
      final docs = json.decode(res.body)['documents'] as List<dynamic>;
      return docs.isNotEmpty ? docs[0]['thumbnail_url'] as String : null;
    } catch (e) {
      debugPrint('썸네일 요청 실패: $e');
      return null;
    }
  }

  Future<String?> getThumbnailCached(String keyword) async {
    if (_thumbCache.containsKey(keyword)) return _thumbCache[keyword];
    final url = await fetchImageThumbnail(keyword);
    if (url != null) _thumbCache[keyword] = url;
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
