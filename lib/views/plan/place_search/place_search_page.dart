import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:travel_muse_app/providers/search_provider.dart';
import 'package:travel_muse_app/views/plan/place_search/widgets/search_bar.dart';
import 'package:travel_muse_app/views/plan/place_search/widgets/search_result_list.dart';

class PlaceSearchPage extends ConsumerStatefulWidget {
  const PlaceSearchPage({super.key});

  @override
  ConsumerState<PlaceSearchPage> createState() => _PlaceSearchPageState();
}

class _PlaceSearchPageState extends ConsumerState<PlaceSearchPage> {
  final TextEditingController _searchController = TextEditingController();
  final Set<int> _selectedIndexes = {};

  void _performSearch(String query) {
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
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: SearchBarWithBackButton(
                controller: _searchController,
                onBack: () => Navigator.pop(context),
                onSearch: () => _performSearch(_searchController.text),
                onSubmitted: _performSearch,
              ),
            ),
            if (_selectedIndexes.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: ElevatedButton(
                  onPressed: () => _confirmSelection(searchResults),
                  child: const Text('선택 완료'),
                ),
              ),
            Expanded(
              child: searchResults.isEmpty
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
