import 'package:flutter/material.dart';
import 'package:travel_muse_app/views/recommended_place/recommended_restaurant_detail_page.dart';

class RecommendedRestaurantsList extends StatelessWidget {
  const RecommendedRestaurantsList({super.key, required this.color});
  final Color color;

  @override
  Widget build(BuildContext context) {
    final List<_RestaurantCardData> restaurants = [
      _RestaurantCardData(
        title: '핫도그',
        image: 'assets/images/image3.png',
        isActive: true,
      ),
      _RestaurantCardData(title: '준비 중', image: '', isActive: false),
      _RestaurantCardData(title: '준비 중', image: '', isActive: false),
    ];

    return SizedBox(
      height: 120,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: restaurants.length,
        itemBuilder: (context, index) {
          final place = restaurants[index];

          return GestureDetector(
            onTap:
                place.isActive
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
            child: Container(
              width: 100,
              margin: const EdgeInsets.only(right: 12),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(12),
                    ),
                    child:
                        place.image.isNotEmpty
                            ? Image.asset(
                              place.image,
                              width: 100,
                              height: 70,
                              fit: BoxFit.cover,
                            )
                            : Container(
                              width: 100,
                              height: 70,
                              color: Colors.grey[300],
                              child: const Icon(
                                Icons.image_not_supported,
                                color: Colors.grey,
                              ),
                            ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    place.title,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                    ),
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

class _RestaurantCardData {
  final String title;
  final String image;
  final bool isActive;

  _RestaurantCardData({
    required this.title,
    required this.image,
    required this.isActive,
  });
}
