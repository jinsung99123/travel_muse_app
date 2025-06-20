import 'package:flutter/material.dart';
import 'package:travel_muse_app/constants/app_colors.dart';

class ServiceTermPage extends StatelessWidget {
  const ServiceTermPage({super.key});

  @override
  Widget build(BuildContext context) {
    final List<String> settingsItems = [
      '서비스 이용약관',
      '개인정보 처리방침',
      '위치정보 이용동의',
      '커뮤니티 운영정책',
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          '서비스 약관',
          style: TextStyle(
            color: Colors.black,
            fontFamily: 'Pretendard',
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: ListView.builder(
        itemCount: settingsItems.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {},
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(width: 1, color: AppColors.grey[50]!),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.75,
                    child: Text(
                      settingsItems[index],
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      style: TextStyle(
                        color: AppColors.black,
                        fontSize: 16,
                        fontFamily: 'Pretendard',
                        fontWeight: FontWeight.w600,
                        height: 1.50,
                      ),
                    ),
                  ),
                  Icon(
                    Icons.arrow_forward_ios,
                    size: 16,
                    color: AppColors.grey[600],
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
