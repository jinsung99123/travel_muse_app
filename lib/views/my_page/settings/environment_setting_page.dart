import 'package:flutter/material.dart';
import 'package:travel_muse_app/constants/app_colors.dart';
import 'package:travel_muse_app/views/widgets/custom_back_button.dart';

class EnvironmentSettingPage extends StatelessWidget {
  const EnvironmentSettingPage({super.key});

  @override
  Widget build(BuildContext context) {
    final List<String> settingsItems = [
      '진동 설정',
      '테마 설정',
      '폰트 크기 설정',
      '언어 선택',
      '데이터 절약모드',
      '캐시 삭제',
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('환경 설정'),
        leading: Navigator.canPop(context) ? const CustomBackButton() : null,
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
