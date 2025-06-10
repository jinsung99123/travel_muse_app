import 'package:flutter/material.dart';
import 'package:travel_muse_app/views/home/recommended_place/recommended_restaurant_detail_page.dart';
import 'package:travel_muse_app/views/home/recommended_place/recommended_restaurant_list_page.dart';

class RecommendedRestaurantsList extends StatelessWidget {
  const RecommendedRestaurantsList({super.key});

  @override
  Widget build(BuildContext context) {
    final List<_RestaurantCardData> restaurants = [
      _RestaurantCardData(title: '부산', imageUrl: 'assets/images/image21.png'),
      _RestaurantCardData(title: '서울', imageUrl: 'assets/images/image22.png'),
      _RestaurantCardData(title: '전주', imageUrl: 'assets/images/image24.png'),
      _RestaurantCardData(title: '대구', imageUrl: 'assets/images/image25.png'),
      _RestaurantCardData(title: '속초', imageUrl: 'assets/images/image26.png'),
      _RestaurantCardData(title: '제천', imageUrl: 'assets/images/image27.png'),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 110,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: restaurants.length,
            separatorBuilder: (context, index) => const SizedBox(width: 12),
            itemBuilder: (context, index) {
              final restaurant = restaurants[index];
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const RecommendedRestaurantDetailPage(),
                    ),
                  );
                },
                child: Column(
                  children: [
                    ClipOval(
                      child: Image.asset(
                        restaurant.imageUrl,
                        width: 56,
                        height: 56,
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(height: 4),
                    SizedBox(
                      width: 56,
                      child: Text(
                        restaurant.title,
                        textAlign: TextAlign.center,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.black,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 8, right: 16),
          child: Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const RecommendedRestaurantsListPage(),
                  ),
                );
              },
              child: const Text(
                '더보기 >',
                style: TextStyle(
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

class _RestaurantCardData {
  _RestaurantCardData({required this.title, required this.imageUrl});
  final String title;
  final String imageUrl;
}
