import 'package:flutter/material.dart';
import 'package:travel_muse_app/constants/app_colors.dart';
import 'package:travel_muse_app/core/widgets/bottom_bar.dart';
import 'package:travel_muse_app/utills/notification_helper.dart';
import 'package:travel_muse_app/utills/notification_setting.dart'; // SharedPreferences 저장소

class NotificationSettingPage extends StatefulWidget {
  const NotificationSettingPage({super.key});

  @override
  State<NotificationSettingPage> createState() => _NotificationSettingPageState();
}

class _NotificationSettingPageState extends State<NotificationSettingPage> {
  final List<String> settingsItems = [
    '전체 알림',
    '여행 일정 알림',
    '댓글 알림',
    '야간 알림',
    '공지사항 및 이벤트 알림',
  ];

  final Map<String, String> _settingKeys = {
    '전체 알림': NotificationSettings.appNotificationKey,
    '여행 일정 알림': NotificationSettings.tripReminderKey,
    '댓글 알림': NotificationSettings.commentNotificationKey,
    '야간 알림': NotificationSettings.nightNotificationKey,
    '공지사항 및 이벤트 알림': NotificationSettings.eventNotificationKey,
  };

  final Map<String, int> _notificationIds = {
    '여행 일정 알림': 1,
    '댓글 알림': 2,
    '야간 알림': 3,
    '공지사항 및 이벤트 알림': 4,
  };

  final Map<String, bool> _switchValues = {};

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    for (var item in settingsItems) {
      final key = _settingKeys[item]!;
      final value = await NotificationSettings.get(key);
      setState(() {
        _switchValues[item] = value;
      });
    }
  }

  Future<void> _onSwitchChanged(String item, bool value) async {
    final key = _settingKeys[item]!;

    setState(() {
      _switchValues[item] = value;
    });

    await NotificationSettings.set(key, value);

    if (item == '전체 알림') {
      for (var entry in _settingKeys.entries) {
        final k = entry.key;
        if (k == '전체 알림') continue;

        setState(() {
          _switchValues[k] = value;
        });
        await NotificationSettings.set(_settingKeys[k]!, value);

        final notifId = _notificationIds[k];
        if (notifId != null) {
          if (value) {
            await NotificationHelper.schedule(
              id: notifId,
              title: k,
              content: '$k 이(가) 설정되었습니다.',
              scheduledTime: DateTime.now().add(Duration(seconds: 5)),
            );
          } else {
            await NotificationHelper.cancel(notifId);
          }
        }
      }
    } else {
      final notifId = _notificationIds[item];
      if (notifId != null) {
        if (value) {
          await NotificationHelper.schedule(
            id: notifId,
            title: item,
            content: '$item 이(가) 켜졌습니다.',
            scheduledTime: DateTime.now().add(Duration(seconds: 5)),
          );
        } else {
          await NotificationHelper.cancel(notifId);
        }
      }
    }
  }

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
      body:
          _switchValues.length < settingsItems.length
              ? const Center(child: CircularProgressIndicator())
              : ListView.builder(
                itemCount: settingsItems.length,
                itemBuilder: (context, index) {
                  final item = settingsItems[index];
                  final value = _switchValues[item] ?? true;
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
                          value: value,
                          onChanged: (bool val) => _onSwitchChanged(item, val),
                          activeColor: AppColors.primary[300],
                        ),
                      ],
                    ),
                  );
                },
              ),
      bottomNavigationBar: const BottomBar(),
    );
  }
}
