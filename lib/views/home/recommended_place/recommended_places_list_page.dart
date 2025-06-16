import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:travel_muse_app/core/widgets/bottom_bar.dart';
import 'package:travel_muse_app/providers/home_view_model_provider.dart';
import 'package:travel_muse_app/views/home/recommended_place/widgets/recommended_place_list_card.dart';

class RecommendedPlacesListPage extends ConsumerWidget {
  const RecommendedPlacesListPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final homeAsync = ref.watch(homeViewModelProvider);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('추천 명소 전체 보기', style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        elevation: 1,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: SafeArea(
        child: homeAsync.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (_, __) => const Center(child: Text('추천 명소를 불러오지 못했어요')),
          data: (state) {
            final spots = state.spots;
            if (spots.isEmpty) {
              return const Center(child: Text('추천 명소가 없어요'));
            }

            return ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: spots.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (_, index) {
                final spot = spots[index];
                return RecommendedPlaceListCard(
                  title: spot.title,
                  image: spot.thumbnail,
                  description: spot.subtitle,
                  isActive: true,
                  place: spot,
                );
              },
            );
          },
        ),
      ),
      bottomNavigationBar: BottomBar(),
    );
  }
}
