import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:travel_muse_app/constants/app_colors.dart';
import 'package:travel_muse_app/core/widgets/bottom_bar.dart';
import 'package:travel_muse_app/providers/home/home_view_model_provider.dart';
import 'package:travel_muse_app/views/home/recommended_place/widgets/recommended_place_list_card.dart';
import 'package:travel_muse_app/views/widgets/custom_app_bar.dart';

class RecommendedPlacesListPage extends ConsumerWidget {
  const RecommendedPlacesListPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final homeAsync = ref.watch(homeViewModelProvider);

    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: CustomAppBar(title: '나의 여행'),
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
              itemCount: spots.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (_, index) {
                final spot = spots[index];
                return Column(
                  children: [
                    RecommendedPlaceListCard(
                      title: spot.title,
                      image: spot.thumbnail,
                      description: spot.subtitle,
                      catecory: spot.category,
                      isActive: true,
                      place: spot,
                    ),
                    Divider(height: 1, thickness: 0.5, color: AppColors.grey[200]),
                  ],
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
