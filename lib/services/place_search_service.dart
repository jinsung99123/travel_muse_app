import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:travel_muse_app/models/place.dart';

class PlaceSearchService {
  //API 기본 값 
  static const _baseKeywordUrl   = 'https://dapi.kakao.com/v2/local/search/keyword.json';
  static const _baseCategoryUrl  = 'https://dapi.kakao.com/v2/local/search/category.json';
  static const _baseImageUrl     = 'https://dapi.kakao.com/v2/search/image';
  static final  String _apiKey   = 'KakaoAK ${dotenv.env['KAKAO_API_KEY'] ?? ''}';

  //키워드 검색
  Future<List<Place>> search(String query) async {
    final url = Uri.parse('$_baseKeywordUrl?query=$query');
    return _requestPlaces(url);
  }

  //키워드 + 위치
  Future<List<Place>> searchByKeyword({
    required String query,
    required double lat,
    required double lng,
    int radius = 10000,
    int page   = 1,
    int size   = 15,
  }) async {
    final url = Uri.parse(
      '$_baseKeywordUrl?query=$query&y=$lat&x=$lng'
      '&radius=$radius&page=$page&size=$size&sort=distance',
    );
    return _requestPlaces(url);
  }

  //카테고리 + 위치
  Future<List<Place>> searchByCategory({
    required String categoryCode, 
    required double lat,
    required double lng,
    int radius = 10000,
    int page   = 1,
    int size   = 15,
  }) async {
    final url = Uri.parse(
      '$_baseCategoryUrl?category_group_code=$categoryCode'
      '&y=$lat&x=$lng&radius=$radius&page=$page&size=$size&sort=distance',
    );
    return _requestPlaces(url);
  }

  //공통 HTTP 처리
  Future<List<Place>> _requestPlaces(Uri url) async {
    final res = await http.get(url, headers: {'Authorization': _apiKey});
    if (res.statusCode != 200) {
      throw Exception('Kakao API 실패: ${res.statusCode}');
    }
    final docs = json.decode(res.body)['documents'] as List<dynamic>;
    return docs.map((e) => Place.fromKakaoJson(e)).toList();
  }

  //이미지 썸네일 직접호출
  Future<String?> fetchImageThumbnail(String keyword) async {
    final url = Uri.parse('$_baseImageUrl?query=$keyword&size=1');
    final res = await http.get(url, headers: {'Authorization': _apiKey});
    if (res.statusCode != 200) return null;

    final docs = json.decode(res.body)['documents'] as List<dynamic>;
    return docs.isNotEmpty ? docs[0]['thumbnail_url'] as String : null;
  }

  //썸네일 캐시 래퍼 
  final Map<String, String> _thumbCache = {};          // keyword -> url

  Future<String?> getThumbnailCached(String keyword) async {
    if (_thumbCache.containsKey(keyword)) return _thumbCache[keyword];

    final url = await fetchImageThumbnail(keyword);
    if (url != null) _thumbCache[keyword] = url;
    return url;
  }

  // 지역명을 좌표로 변환하는 메서드
Future<LatLng?> getLatLngFromRegion(String region) async {
  final url = Uri.parse(
    'https://dapi.kakao.com/v2/local/search/address.json?query=$region',
  );
  final res = await http.get(url, headers: {'Authorization': _apiKey});
  if (res.statusCode != 200) return null;

  final docs = json.decode(res.body)['documents'] as List<dynamic>;
  if (docs.isEmpty) return null;

  final lat = double.tryParse(docs[0]['y']) ?? 0;
  final lng = double.tryParse(docs[0]['x']) ?? 0;
  return LatLng(lat, lng);
}

}
