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

  void _performSearch(String query) {
    ref.read(searchViewModelProvider.notifier).search(query.trim());
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
            Expanded(
              child: searchResults.isEmpty
                  ? const Center(child: Text('검색 결과가 없습니다.'))
                  : SearchResultList(places: searchResults),
            ),
          ],
        ),
      ),
    );
  }
}
