import 'package:flutter/material.dart' hide SearchBar;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:travel_muse_app/constants/app_colors.dart';
import 'package:travel_muse_app/providers/resent_search_provider.dart';
import 'package:travel_muse_app/providers/search_provider.dart';
import 'package:travel_muse_app/views/plan/place_search/widgets/recent_search_section.dart';
import 'package:travel_muse_app/views/plan/place_search/widgets/search_bar.dart';
import 'package:travel_muse_app/views/plan/place_search/widgets/search_result_list.dart';
import 'package:travel_muse_app/views/plan/widgets/schedule_app_bar.dart';

class PlaceSearchPage extends ConsumerStatefulWidget {
  const PlaceSearchPage({super.key, required this.planId});
  final String planId;

  @override
  ConsumerState<PlaceSearchPage> createState() => _PlaceSearchPageState();
}

class _PlaceSearchPageState extends ConsumerState<PlaceSearchPage> {
  final TextEditingController _searchController = TextEditingController();
  final Set<int> _selectedIndexes = {};

  void _performSearch(String query) {
    ref.read(recentSearchProvider.notifier).add(query);
    ref.read(searchViewModelProvider.notifier).search(query.trim());
    _selectedIndexes.clear(); // 검색 새로 하면 선택 초기화
  }

  void _toggleSelected(int index) {
    setState(() {
      if (_selectedIndexes.contains(index)) {
        _selectedIndexes.remove(index);
      } else {
        _selectedIndexes.add(index);
      }
    });
  }

  void _confirmSelection(List<Map<String, String>> places) {
    final selectedPlaces = _selectedIndexes.map((i) => places[i]).toList();
    Navigator.pop(context, selectedPlaces);
  }

  @override
  Widget build(BuildContext context) {
    final searchResults = ref.watch(searchViewModelProvider);
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.white,
      appBar: ScheduleAppBar(planId: widget.planId),
      bottomNavigationBar:
          _selectedIndexes.isEmpty
              ? null
              : Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 24), // 하단 여백
                child: GestureDetector(
                  onTap: () => _confirmSelection(searchResults),
                  child: Container(
                    height: 56,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: AppColors.primary[300],
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Text(
                      '추가하기',
                      style: TextStyle(
                        color: AppColors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'Pretendard',
                      ),
                    ),
                  ),
                ),
              ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: SearchBar(
                controller: _searchController,
                onSearch: () => _performSearch(_searchController.text),
                onSubmitted: _performSearch,
              ),
            ),
            SizedBox(height: 16),
            // 최근 검색어
            RecentSearchSection(
              onSelect: (word) {
                _searchController.text = word;
                _performSearch(word);
              },
            ),
            Expanded(
              child:
                  searchResults.isEmpty
                      ? const Center(child: Text('검색 결과가 없습니다.'))
                      : SearchResultList(
                        places: searchResults,
                        selectedIndexes: _selectedIndexes,
                        onToggle: _toggleSelected,
                      ),
            ),
          ],
        ),
      ),
    );
  }
}
