import 'package:flutter/material.dart';

class PlaceDescription extends StatelessWidget {
  const PlaceDescription({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).textTheme;

    return Text(
      '새벽 물안개와 강변 산책로가 인상적인 감성 명소. 커플과 가족 단위 여행에 추천!',
      style: theme.bodyLarge?.copyWith(fontWeight: FontWeight.bold),
    );
  }
}
