import 'package:flutter/material.dart';

class RecommendedRestaurantsList extends StatelessWidget {
  final Color color;

  const RecommendedRestaurantsList({Key? key, required this.color})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 100,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: 5,
        itemBuilder: (context, index) {
          return AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            margin: const EdgeInsets.only(right: 12),
            width: 80,
            decoration: BoxDecoration(
              color: color.withOpacity(0.2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(child: Text('맛집 ${index + 1}')),
          );
        },
      ),
    );
  }
}
