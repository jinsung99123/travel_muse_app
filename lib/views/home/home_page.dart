import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:travel_muse_app/constants/app_colors.dart';
import 'package:travel_muse_app/core/widgets/bottom_bar.dart';
import 'package:travel_muse_app/providers/user/profile_view_model_provider.dart';
import 'package:travel_muse_app/views/home/widgets/info_banner.dart';
import 'package:travel_muse_app/views/home/widgets/recommended_places_list.dart';
import 'package:travel_muse_app/views/home/widgets/recommended_restaurants_list.dart';
import 'package:travel_muse_app/views/home/widgets/section_title.dart';
import 'package:travel_muse_app/views/home/widgets/travel_register_button.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileState = ref.watch(profileViewModelProvider);
    final nickname = profileState.currentNickname;
    if (nickname == null) {
      return const Center(child: CircularProgressIndicator());
    }
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/images/Logo.png',
                      width: 20,
                      height: 20,
                      fit: BoxFit.contain,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Travelmuse',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColors.grey[800],
                        fontFamily: 'Ssangmun',
                      ),
                    ),
                  ],
                ),
              ),
              const InfoBanner(),
              const SizedBox(height: 8),
              Center(child: TravelRegisterButton()),
              const SizedBox(height: 24),

              SectionTitle(title: '$nickname님의 위치 기반 추천 명소예요'),

              const SizedBox(height: 8),
              const RecommendedPlacesList(),
              const SizedBox(height: 10),

              SectionTitle(title: '최근 유행하는 맛집이에요'),

              const SizedBox(height: 8),
              const RecommendedRestaurantsList(),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
      bottomNavigationBar: const BottomBar(),
    );
  }
}
