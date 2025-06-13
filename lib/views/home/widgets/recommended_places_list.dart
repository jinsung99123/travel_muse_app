import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:travel_muse_app/providers/home_view_model_provider.dart';
import 'package:travel_muse_app/providers/selected_tag_provider.dart';
import 'package:travel_muse_app/views/home/recommended_place/recommended_places_list_page.dart';
import 'package:travel_muse_app/views/home/recommended_place/widgets/hashtag_selector.dart';
import 'package:travel_muse_app/views/home/recommended_place/widgets/recommended_carousel.dart';

class RecommendedPlacesList extends ConsumerWidget {
  const RecommendedPlacesList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final homeAsync = ref.watch(homeViewModelProvider);
    final selectedTag = ref.watch(selectedTagProvider);
    final selectedTagNotifier = ref.read(selectedTagProvider.notifier);
    final viewModel = ref.read(homeViewModelProvider.notifier);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        HashtagSelector(
          selectedTag: selectedTag,
          onTagTap: (tag) => selectedTagNotifier.state = tag,
        ),
        homeAsync.when(
          loading: () => const SizedBox(
              height: 170,
              child: Center(child: CircularProgressIndicator(strokeWidth: 2))),
          error: (_, __) => const SizedBox(
              height: 170,
              child: Center(child: Text('추천 명소를 불러오지 못했어요'))),
          data: (state) {
            final spots = viewModel.getFilteredSpots(state.spots,selectedTag);
            if (spots.isEmpty) {
              return const SizedBox(
                height: 170,
                child: Center(child: Text('근처 추천 명소가 없어요')),
              );
            }
            return RecommendedCarousel(places: spots);
          },
        ),
        Padding(
          padding: const EdgeInsets.only(top: 8, right: 16),
          child: Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const RecommendedPlacesListPage(),
                ),
              ),
              child: const Text(
                '더보기 >',
                style: TextStyle(
                  fontFamily: 'Pretendard',
                  fontSize: 14,
                  color: Color(0xFF48CDFD),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
