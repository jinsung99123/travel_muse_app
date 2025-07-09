import 'package:flutter/material.dart';
import 'package:travel_muse_app/views/home/recommended_place/widgets/opening_hours_section.dart';
import 'package:url_launcher/url_launcher.dart';

class PlaceDetailSection extends StatelessWidget {
  const PlaceDetailSection({super.key, required this.detail});
  final Map<String, dynamic> detail;

  @override
Widget build(BuildContext context) {
  final weekdayHours = detail['opening_hours']?['weekday_text'];
  final phone = detail['formatted_phone_number'];
  final website = detail['website'];
  final rating = detail['rating'];
  final address = detail['formatted_address'];
  final summary = detail['editorial_summary']?['overview'];
  final status = detail['business_status'];

  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      if (rating != null || status != null) ...[
        const SizedBox(height: 6),
        Wrap(
          spacing: 8,
          runSpacing: 4,
          children: [
            if (rating != null)
              _buildRow(
                icon: Icons.star,
                title: '$rating',
                iconColor: Colors.amber,
              ),
            if (status != null)
              _buildRow(
                icon: Icons.info_outline,
                title: status == 'OPERATIONAL' ? '영업 중' : '영업 종료',
                iconColor: status == 'OPERATIONAL' ? Colors.green : Colors.red,
              ),
          ],
        ),
        const SizedBox(height: 10),
      ],

      if (address != null) ...[
        _buildRow(icon: Icons.place, title: address),
        const SizedBox(height: 20),
      ],

      if (weekdayHours != null) ...[
        OpeningHoursSection(weekdayHours: weekdayHours),
        const SizedBox(height: 20),
      ],

      if (summary != null) ...[
        _buildSectionTitle(Icons.description, '매장 소개'),
        const SizedBox(height: 6),
        Text(summary),
        const SizedBox(height: 20),
      ],

      if (phone != null || website != null) ...[
        _buildSectionTitle(Icons.info_outline, '매장 정보'),
        const SizedBox(height: 10),
        if (phone != null) Text('전화번호: $phone'),
        if (website != null)
          GestureDetector(
            onTap: () => launchUrl(Uri.parse(website)),
            child: Text(
              '웹사이트: $website',
              style: const TextStyle(color: Colors.blue),
            ),
          ),
        const SizedBox(height: 16),
      ],
    ],
  );
}


  // 공통 텍스트 섹션 타이틀
  Widget _buildSectionTitle(IconData icon, String title) {
    return Row(
      children: [
        Icon(icon, size: 20),
        const SizedBox(width: 6),
        Text(
          title,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
      ],
    );
  }

  // 아이콘 + 텍스트 한 줄 표시
  Widget _buildRow({
    required IconData icon,
    required String title,
    Color iconColor = Colors.black,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 2),
          child: Icon(icon, size: 18, color: iconColor),
        ),
        const SizedBox(width: 6),
        Expanded(
          child: Text(
            title,
            style: const TextStyle(fontSize: 14),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
