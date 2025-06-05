import 'package:flutter/material.dart';
import 'package:travel_muse_app/core/widgets/bottom_bar.dart';
import 'package:travel_muse_app/views/calendar/calendar_page.dart';
import 'package:travel_muse_app/views/home/widgets/info_banner.dart';
import 'package:travel_muse_app/views/home/widgets/popular_trips_list.dart';
import 'package:travel_muse_app/views/home/widgets/recommended_places_list.dart';
import 'package:travel_muse_app/views/home/widgets/recommended_restaurants_list.dart';
import 'package:travel_muse_app/views/home/widgets/section_title.dart';
import 'package:travel_muse_app/views/home/widgets/travel_register_button.dart';
import 'package:travel_muse_app/views/plan/place_search/place_search_page.dart';
import 'package:travel_muse_app/views/plan/schedule/schedule_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  int currentIndex = 0;
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
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => PlaceSearchPage()),
              );
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
              backgroundColor: Colors.grey,
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const CalendarPage()),
                );
              },
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
      bottomNavigationBar: BottomBar(),
    );
  }
}
