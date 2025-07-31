import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class GooglePlaceDetailService {
  final String _apiKey =
      Platform.isIOS
          ? dotenv.env['GOOGLE_PLACES_API_KEY_IOS'] ?? ''
          : dotenv.env['GOOGLE_PLACES_API_KEY_ANDROID'] ?? '';

  /// 장소명 + 위경도 기반 placeId 조회 (더 정확함)
  Future<String?> getPlaceIdByLatLng(
    String name,
    String address,
    double lat,
    double lng,
  ) async {
    final region = _extractRegionFromAddress(address);
    final url = Uri.parse(
      'https://maps.googleapis.com/maps/api/place/textsearch/json'
      '?query=${Uri.encodeComponent("$name, $region")}'
      '&location=$lat,$lng'
      '&radius=1000'
      '&key=$_apiKey',
    );

    final res = await http.get(url);
    if (res.statusCode == 200) {
      final jsonBody = json.decode(res.body);
      final results = jsonBody['results'];
      if (results != null && results.isNotEmpty) {
        return results[0]['place_id'];
      } else {
        debugPrint('[place_id 결과 없음]: $jsonBody');
      }
    } else {
      debugPrint('[요청 실패]: ${res.statusCode}');
    }
    return null;
  }

  /// placeId로 상세정보 가져오기
  Future<Map<String, dynamic>?> getPlaceDetail(String placeId) async {
    final url = Uri.parse(
      'https://maps.googleapis.com/maps/api/place/details/json'
      '?place_id=$placeId'
      '&fields=name,rating,formatted_address,formatted_phone_number,'
      'opening_hours,website,reviews,user_ratings_total,editorial_summary,business_status'
      '&language=ko'
      '&key=$_apiKey',
    );

    final res = await http.get(url);
    if (res.statusCode == 200) {
      final jsonBody = json.decode(res.body);
      return jsonBody['result'];
    }
    return null;
  }

  /// 장소명 + 위경도 기반 상세정보 가져오기
  Future<Map<String, dynamic>?> getDetailByNameAndLatLng(
    String name,
    String address,
    double lat,
    double lng,
  ) async {
    final placeId = await getPlaceIdByLatLng(name, address, lat, lng);
    if (placeId == null) return null;
    return await getPlaceDetail(placeId);
  }

/// 전체 주소 문자열에서 시 + 구 (또는 도 + 시)만 추출
  String _extractRegionFromAddress(String address) {
    final parts = address.split(' ');
    if (parts.length >= 2) {
      return '${parts[0]} ${parts[1]}';
    }
    return address;
  }
}
