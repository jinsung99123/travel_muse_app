import 'package:flutter/material.dart';

class PlaceDirectionInfo extends StatelessWidget {
  const PlaceDirectionInfo({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: const [
        SizedBox(height: 24),
        Text(
          '가는방법',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        SizedBox(height: 8),
        Text('양수역에서 도보 15분 / 차량 5분'),
      ],
    );
  }
}
