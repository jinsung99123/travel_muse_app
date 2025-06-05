import 'package:flutter/material.dart';
import 'package:travel_muse_app/views/recommended_place/recommended_restaurant_detail_page.dart';

class RecommendedRestaurantsListPage extends StatelessWidget {
  const RecommendedRestaurantsListPage({super.key});

  @override
  Widget build(BuildContext context) {
    final primaryColor = const Color(0xFF03A9F4);

    final List<_RestaurantData> restaurants = [
      _RestaurantData(
        name: '핫도그 두물머리점',
        image: 'assets/images/image3.png',
        description: '두물머리 명물 수제 핫도그',
      ),
      _RestaurantData(name: '준비 중', image: '', description: '곧 추가될 맛집'),
      _RestaurantData(name: '준비 중', image: '', description: '곧 추가될 맛집'),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('추천 맛집 전체 보기'),
        backgroundColor: primaryColor,
      ),
      body: ListView.builder(
        itemCount: restaurants.length,
        padding: const EdgeInsets.all(16),
        itemBuilder: (context, index) {
          final restaurant = restaurants[index];

          return GestureDetector(
            onTap:
                restaurant.name != '준비 중'
                    ? () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder:
                              (_) => const RecommendedRestaurantDetailPage(),
                        ),
                      );
                    }
                    : null,
            child: Card(
              elevation: 2,
              margin: const EdgeInsets.only(bottom: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.horizontal(
                      left: Radius.circular(12),
                    ),
                    child:
                        restaurant.image.isNotEmpty
                            ? Image.asset(
                              restaurant.image,
                              width: 100,
                              height: 100,
                              fit: BoxFit.cover,
                            )
                            : Container(
                              width: 100,
                              height: 100,
                              color: Colors.grey[300],
                              child: const Icon(Icons.image_not_supported),
                            ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 12,
                        horizontal: 8,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            restaurant.name,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            restaurant.description,
                            style: const TextStyle(
                              fontSize: 13,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const Icon(
                    Icons.arrow_forward_ios,
                    size: 16,
                    color: Colors.grey,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class _RestaurantData {
  final String name;
  final String image;
  final String description;

  _RestaurantData({
    required this.name,
    required this.image,
    required this.description,
  });
}
