import 'package:flutter/material.dart' hide SearchBar;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:travel_muse_app/core/widgets/bottom_bar.dart';
import 'package:travel_muse_app/providers/plan/schedule/search_provider.dart';
import 'package:travel_muse_app/providers/plan/schedule/selected_index_provider.dart';
import 'package:travel_muse_app/services/plan/place_search_service.dart';
import 'package:travel_muse_app/views/plan/plan/place_search/widgets/confirm_add_button.dart';
import 'package:travel_muse_app/views/plan/plan/place_search/widgets/recent_search_section.dart';
import 'package:travel_muse_app/views/plan/plan/place_search/widgets/region_recommend_header.dart';
import 'package:travel_muse_app/views/plan/plan/place_search/widgets/search_bar.dart';
import 'package:travel_muse_app/views/plan/plan/place_search/widgets/search_result_list.dart';
import 'package:travel_muse_app/views/plan/plan/widgets/schedule_app_bar.dart';

class PlaceSearchPage extends ConsumerStatefulWidget {
  const PlaceSearchPage({
    super.key,
    required this.planId,
    required this.region,
  });

  final String planId;
  final String region;

  @override
  ConsumerState<PlaceSearchPage> createState() => _PlaceSearchPageState();
}

class _PlaceSearchPageState extends ConsumerState<PlaceSearchPage> {
  final TextEditingController _searchController = TextEditingController();
  bool _showInitialMessage = true;

  // 검색 실행 (서비스 이용)
  void _handleSearch(String query) {
    PlaceSearchService.performSearch(ref, widget.region, query);
    ref.read(selectedIndexProvider.notifier).clear();
    setState(() => _showInitialMessage = false);
  }

  // 선택 완료
  void _confirmSelection(List<Map<String, String>> places) {
    final selected = ref.read(selectedIndexProvider);
    final selectedPlaces = selected.map((i) => places[i]).toList();
    Navigator.pop(context, selectedPlaces);
  }

  // 지역 추천 목록
  Future<void> _loadRecommendedPlacesByRegion() async {
    if (widget.region.isEmpty) return;
    await ref
        .read(searchViewModelProvider.notifier)
        .loadRecommendedByRegion(widget.region);
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(selectedIndexProvider.notifier).clear();
    });

    _loadRecommendedPlacesByRegion();
  }

  @override
  Widget build(BuildContext context) {
    final searchResults = ref.watch(searchViewModelProvider);
    final selectedIndexes = ref.watch(selectedIndexProvider);

    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.white,
      appBar: ScheduleAppBar(planId: widget.planId),
      floatingActionButton: ConfirmAddButton(
        visible: selectedIndexes.isNotEmpty,
        onTap: () => _confirmSelection(searchResults),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: SearchBar(
                controller: _searchController,
                onSearch:
                    () => _handleSearch(_searchController.text), 
                onQueryChanged: _handleSearch,
              ),
            ),
            RecentSearchSection(
              onSelect: (word) {
                _searchController.text = word;
                _handleSearch(word);
              },
            ),
            if (_showInitialMessage)
              RegionRecommendHeader(region: widget.region),
            const SizedBox(height: 8),
            Expanded(
  child: searchResults.isEmpty
      ? Center(
          child: Text(
            _showInitialMessage
                ? '일시적인 문제로 추천을 불러오지 못했어요\n잠시 후 다시 시도해 주세요.'
                : '검색 결과가 없습니다.',
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 14, color: Colors.grey),
          ),
        )
      : SearchResultList(
          places: searchResults,
          selectedIndexes: selectedIndexes,
          onToggle: (i) =>
              ref.read(selectedIndexProvider.notifier).toggle(i),
        ),
),
          ],
        ),
      ),
      bottomNavigationBar: const BottomBar(),
    );
  }
}
