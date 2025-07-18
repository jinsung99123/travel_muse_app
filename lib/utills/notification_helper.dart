import 'dart:io';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

@pragma('vm:entry-point')
void notificationTapOnBackGround(NotificationResponse response) {
  print('[백그라운드 알림 탭] payload: ${response.payload}');
}

class NotificationHelper {
  static final flutterNotificationsPlugin = FlutterLocalNotificationsPlugin();

  static Future<void> init() async {
    final darwinSetting = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestSoundPermission: true,
      requestBadgePermission: true,
    );
    final androidSetting = AndroidInitializationSettings('@mipmap/ic_launcher');

    final initSetting = InitializationSettings(
      android: androidSetting,
      iOS: darwinSetting,
    );

    await flutterNotificationsPlugin.initialize(
      initSetting,
      onDidReceiveNotificationResponse: (details) {
        print('[포그라운드 알림 탭] payload: ${details.payload}');
      },
      onDidReceiveBackgroundNotificationResponse: notificationTapOnBackGround,
    );

    if (Platform.isIOS) {
      await flutterNotificationsPlugin
          .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin
          >()
          ?.requestPermissions(alert: true, badge: true, sound: true);
    }

    tz.initializeTimeZones(); // 예약 알림 위해 시간대 초기화
  }

  static Future<void> show({
    required String title,
    required String content,
    int id = 0,
  }) async {
    await flutterNotificationsPlugin.show(
      id,
      title,
      content,
      const NotificationDetails(
        iOS: DarwinNotificationDetails(
          presentSound: true,
          presentAlert: true,
          presentBadge: true,
        ),
      ),
      payload: 'payload_example',
    );
  }

  static Future<void> schedule({
    required String title,
    required String content,
    required DateTime scheduledTime,
    int id = 100,
  }) async {
    final tzTime = tz.TZDateTime.from(scheduledTime, tz.local);

    await flutterNotificationsPlugin.zonedSchedule(
      id,
      title,
      content,
      tzTime,
      const NotificationDetails(
        iOS: DarwinNotificationDetails(
          presentSound: true,
          presentAlert: true,
          presentBadge: true,
        ),
      ),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      matchDateTimeComponents: null,
      payload: 'payload_example',
    );
  }

  static Future<void> cancel(int id) async {
    await flutterNotificationsPlugin.cancel(id);
  }

  static Future<void> cancelAll() async {
    await flutterNotificationsPlugin.cancelAll();
  }
}
