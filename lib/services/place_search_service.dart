import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:travel_muse_app/models/place.dart';

class PlaceSearchService {
  static const String _baseUrl =
      'https://dapi.kakao.com/v2/local/search/keyword.json';
  static final String _apiKey = 'KakaoAK ${dotenv.env['KAKAO_API_KEY'] ?? ''}';

  Future<List<Place>> search(String query) async {
    final url = Uri.parse('$_baseUrl?query=$query');

    final response = await http.get(url, headers: {'Authorization': _apiKey});

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final List<dynamic> documents = data['documents'];
      return documents.map((doc) => Place.fromKakaoJson(doc)).toList();
    } else {
      throw Exception('카카오 장소 검색 실패: ${response.statusCode}');
    }
  }

  Future<String?> fetchImageThumbnail(String keyword) async {
    final url = Uri.parse(
      'https://dapi.kakao.com/v2/search/image?query=$keyword',
    );
    final response = await http.get(
      url,
      headers: {'Authorization': _apiKey},
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final List<dynamic> docs = data['documents'];
      if (docs.isNotEmpty) {
        return docs[0]['thumbnail_url'];
      }
    }

    return null; // 결과 없거나 실패 시
  }
}
