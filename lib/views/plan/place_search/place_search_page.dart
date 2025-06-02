import 'package:flutter/material.dart';
import 'package:travel_muse_app/views/plan/place_search/widgets/search_bar.dart';
import 'package:travel_muse_app/views/plan/place_search/widgets/search_result_list.dart';

class PlaceSearchPage extends StatefulWidget {
  const PlaceSearchPage({super.key});

  @override
  State<PlaceSearchPage> createState() => _PlaceSearchPageState();
}

class _PlaceSearchPageState extends State<PlaceSearchPage> {
  final TextEditingController _searchController = TextEditingController();
  List<Map<String, String>> _searchResults = [];

  final List<Map<String, String>> _places = [
    {
      'title': '서울 타워',
      'subtitle': '서울 야경 명소',
      'image':
          'https://cdn.pixabay.com/photo/2017/06/24/04/37/cloud-2436676_1280.jpg',
    },
    {
      'title': '서울 경복궁',
      'subtitle': '조선의 중심 궁궐',
      'image':
          'https://cdn.pixabay.com/photo/2017/06/24/04/37/cloud-2436676_1280.jpg',
    },
    {
      'title': '제주도',
      'subtitle': '자연과 함께하는 힐링 여행',
      'image':
          'https://cdn.pixabay.com/photo/2017/06/24/04/37/cloud-2436676_1280.jpg',
    },
    {
      'title': '해운대',
      'subtitle': '부산의 대표 바닷가',
      'image':
          'https://cdn.pixabay.com/photo/2017/06/24/04/37/cloud-2436676_1280.jpg',
    },
  ];

  //로직 구현시 viewmodel로 분리
  void _performSearch(String query) {
    final results =
        _places
            .where((place) => place['title']!.contains(query.trim()))
            .toList();

    setState(() {
      _searchResults = results;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            //검색창 위젯
            Padding(
              padding: const EdgeInsets.all(16),
              child: SearchBarWithBackButton(
                controller: _searchController,
                onBack: () => Navigator.pop(context),
                onSearch: () => _performSearch(_searchController.text),
                onSubmitted: _performSearch,
              ),
            ),
            //결과 리스트
            Expanded(
              child:
                  _searchResults.isEmpty
                      ? const Center(child: Text('검색 결과가 없습니다.'))
                      : SearchResultList(places: _searchResults),
            ),
          ],
        ),
      ),
    );
  }
}
