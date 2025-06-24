import 'package:flutter/material.dart';
import 'package:travel_muse_app/constants/app_colors.dart';
import 'package:travel_muse_app/views/user/onboarding/terms_web_view_page.dart';

final List<Map<String, String>> termsData = [
  {'title': '만 14세 이상입니다.', 'url': ''},
  {
    'title': '서비스 이용약관',
    'url': 'https://www.notion.so/21cc9d67bce980ab9579ebf380ad5d2c',
  },
  {
    'title': '개인정보 처리방침',
    'url': 'https://www.notion.so/21cc9d67bce980d58f34ec20ee46d139',
  },
  {
    'title': '마케팅 수신 동의',
    'url': 'https://www.notion.so/21cc9d67bce980ab9579ebf380ad5d2c?pvs=12',
  },
  {
    'title': '커뮤니티 운영정책',
    'url': 'https://www.notion.so/21cc9d67bce980b1a257c3a7dcf39cc2',
  },
  {
    'title': '위치정보 이용동의',
    'url': 'https://www.notion.so/21cc9d67bce9802e92f5fbaceffe6190',
  },
];

class ServiceTermPage extends StatelessWidget {
  const ServiceTermPage({super.key});

  @override
  Widget build(BuildContext context) {
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
        itemCount: termsData.length,
        itemBuilder: (context, index) {
          final term = termsData[index];
          return GestureDetector(
            onTap:
                term['url'] != null && term['url']!.isNotEmpty
                    ? () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder:
                              (_) => TermsWebViewPage(
                                title: term['title']!,
                                url: term['url']!,
                              ),
                        ),
                      );
                    }
                    : null,
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
                      term['title']!,
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
                  term['url'] != null && term['url']!.isNotEmpty
                      ? Icon(
                        Icons.arrow_forward_ios,
                        size: 16,
                        color: AppColors.grey[600],
                      )
                      : SizedBox.shrink(),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
