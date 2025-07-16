import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:travel_muse_app/constants/app_colors.dart';
import 'package:travel_muse_app/providers/home/home_view_model_provider.dart';
import 'package:travel_muse_app/views/home/recommended_place/widgets/recommended_restaurant_list_card.dart';
import 'package:travel_muse_app/views/widgets/custom_back_button.dart';

class RecommendedRestaurantsListPage extends ConsumerWidget {
  const RecommendedRestaurantsListPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final homeAsync = ref.watch(homeViewModelProvider);

    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        title: const Text('추천 맛집'),
        leading: const CustomBackButton(),
      ),
      body: homeAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error:
            (_, __) => const Center(
              child: Text('일시적인 문제로 추천을 불러오지 못했어요\n잠시 후 다시 시도해 주세요.'),
            ),
        data: (state) {
          final restaurants = state.foods;
          if (restaurants.isEmpty) {
            return const Center(child: Text('추천 맛집이 없어요'));
          }
          return ListView.separated(
            itemCount: restaurants.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (_, index) {
              final r = restaurants[index];
              return Column(
                children: [
                  RecommendedRestaurantListCard(
                    name: r.title,
                    image: r.thumbnail,
                    description: r.subtitle,
                    catecory: r.category,
                    isActive: true,
                    place: r,
                  ),
                  Divider(
                    height: 1,
                    thickness: 0.5,
                    color: AppColors.grey[200],
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }
}
