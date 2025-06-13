import 'package:flutter/material.dart';

class PlaceDescription extends StatelessWidget {
  const PlaceDescription({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).textTheme;

    return Text(
      '커플과 가족 단위 여행에 추천!',
      style: theme.bodyLarge?.copyWith(fontWeight: FontWeight.bold),
    );
  }
}
