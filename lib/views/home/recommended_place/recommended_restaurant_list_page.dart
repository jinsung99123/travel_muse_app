import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:travel_muse_app/providers/home_view_model_provider.dart';
import 'package:travel_muse_app/views/home/recommended_place/widgets/recommended_restaurant_list_card.dart';

class RecommendedRestaurantsListPage extends ConsumerWidget {
  const RecommendedRestaurantsListPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final homeAsync = ref.watch(homeViewModelProvider);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('추천 맛집 전체 보기', style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        elevation: 1,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: homeAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (_, __) => const Center(child: Text('추천 맛집을 불러오지 못했어요')),
        data: (state) {
          final restaurants = state.foods;
          if (restaurants.isEmpty) {
            return const Center(child: Text('추천 맛집이 없어요'));
          }
          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: restaurants.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (_, index) {
              final r = restaurants[index];
              return RecommendedRestaurantListCard(
                name: r.title,
                image: r.thumbnail,
                description: r.subtitle,
                isActive: true,
                place: r,
              );
            },
          );
        },
      ),
    );
  }
}
