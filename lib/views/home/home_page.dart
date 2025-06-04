import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:travel_muse_app/core/widgets/bottom_bar.dart';
import 'package:travel_muse_app/views/home/widgets/info_banner.dart';
import 'package:travel_muse_app/views/home/widgets/popular_trips_list.dart';
import 'package:travel_muse_app/views/home/widgets/recommended_places_list.dart';
import 'package:travel_muse_app/views/home/widgets/recommended_restaurants_list.dart';
import 'package:travel_muse_app/views/home/widgets/section_title.dart';
import 'package:travel_muse_app/views/home/widgets/travel_register_button.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeInAnimation;

  final Color primaryColor = const Color(0xFF03A9F4); // Primary/400
  final Color secondaryColor = const Color(0xFF1E88E5); // Secondary/400

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _fadeInAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeIn,
    );
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        title: const Text('TravelMuse', style: TextStyle(color: Colors.white)),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications, color: Colors.white),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.search, color: Colors.white),
            onPressed: () {
              context.go('/place_search');
            },
          ),
        ],
      ),
      body: FadeTransition(
        opacity: _fadeInAnimation,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TravelRegisterButton(
              onPressed: () {
                context.go('/schedule');
              },
              backgroundColor: secondaryColor,
            ),
            const SizedBox(height: 16),
            const SectionTitle(title: '추천 명소'),
            RecommendedPlacesList(color: primaryColor),
            const SizedBox(height: 16),
            const SectionTitle(title: '인기 여행기'),
            PopularTripsList(color: secondaryColor),
            const SizedBox(height: 16),
            const SectionTitle(title: '유용한 정보 & 혜택'),
            InfoBanner(
              primaryColor: primaryColor,
              secondaryColor: secondaryColor,
            ),
            const SizedBox(height: 16),
            const SectionTitle(title: '추천 맛집'),
            RecommendedRestaurantsList(color: primaryColor),
          ],
        ),
      ),
      bottomNavigationBar: BottomBar(
        primaryColor: primaryColor,
        currentIndex: 0,
        onTap: (index) {
          switch (index) {
            case 0:
              context.go('/home');
              break;
            case 1:
              context.go('/schedule');
              break;
            case 2:
              context.go('/place_search');
              break;
            case 3:
              context.go('/mypage');
              break;
          }
        },
      ),
    );
  }
}
