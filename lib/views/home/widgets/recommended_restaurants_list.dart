import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:travel_muse_app/constants/app_colors.dart';
import 'package:travel_muse_app/providers/home/home_view_model_provider.dart';
import 'package:travel_muse_app/views/home/recommended_place/widgets/recommended_carousel.dart';

class RecommendedRestaurantsList extends ConsumerWidget {
  const RecommendedRestaurantsList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final homeAsync = ref.watch(homeViewModelProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        homeAsync.when(
          loading:
              () => const SizedBox(
                height: 170,
                child: Center(child: CircularProgressIndicator(strokeWidth: 2)),
              ),
          error:
              (_, __) => const SizedBox(
                height: 170,
                child: Center(
                  child: Text('일시적인 문제로 추천을 불러오지 못했어요\n잠시 후 다시 시도해 주세요.'),
                ),
              ),
          data:
              (state) =>
                  state.foods.isEmpty
                      ? const SizedBox(
                        height: 170,

                        child: Center(child: Text('근처 추천 맛집이 없어요')),
                      )
                      : RecommendedCarousel(places: state.foods, rounded: true),
        ),

        Padding(
          padding: const EdgeInsets.only(top: 8, right: 16),
          child: Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: () {
                Navigator.of(context).pushNamed('/restaurant_list');
              },
              child: Text(
                '더보기 >',
                style: TextStyle(
                  fontSize: 14,
                  color: AppColors.grey[300],
                  fontWeight: FontWeight.w500,
                  fontFamily: 'Pretendard',
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
