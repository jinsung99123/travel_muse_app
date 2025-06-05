import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class PlaceInfoSection extends StatelessWidget {
  const PlaceInfoSection({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('주소: 경기도 양평군 양서면 양수리 105-1', style: theme.bodyMedium),
        const SizedBox(height: 4),
        Text('전화: 031-770-1001', style: theme.bodyMedium),
        const SizedBox(height: 4),
        GestureDetector(
          onTap: () => launchUrl(Uri.parse('https://www.yp21.go.kr')),
          child: const Text(
            '홈페이지: www.yp21.go.kr',
            style: TextStyle(color: Colors.blue),
          ),
        ),
      ],
    );
  }
}
