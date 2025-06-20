import 'package:flutter/material.dart';
import 'package:travel_muse_app/constants/app_colors.dart';

class NotificationSettingPage extends StatefulWidget {
  const NotificationSettingPage({super.key});

  @override
  State<NotificationSettingPage> createState() =>
      _NotificationSettingPageState();
}

class _NotificationSettingPageState extends State<NotificationSettingPage> {
  final List<String> settingsItems = [
    '전체 알림',
    '여행 일정 알림',
    '댓글 알림',
    '야간 알림',
    '공지사항 및 이벤트 알림',
  ];

  final Map<String, bool> _switchValues = {
    '전체 알림': true,
    '여행 일정 알림': true,
    '댓글 알림': true,
    '야간 알림': false,
    '공지사항 및 이벤트 알림': true,
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          '알림 설정',
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
          final item = settingsItems[index];
          return Container(
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
                    item,
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
                Switch(
                  value: _switchValues[item]!,
                  onChanged: (bool value) {
                    setState(() {
                      _switchValues[item] = value;
                    });
                  },
                  activeColor: AppColors.primary[300],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
