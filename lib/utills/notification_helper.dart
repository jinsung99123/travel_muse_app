import 'package:flutter_local_notifications/flutter_local_notifications.dart';

@pragma('vm:entry-point')
void notificationTapOnBackGround(NotificationResponse response) {
  print(response.payload);
}

class NotificationHelper {
  static final flutterNotificationsPlugin = FlutterLocalNotificationsPlugin();

  static Future<void> init() async {
    final darwinSetting = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestSoundPermission: true,
      requestBadgePermission: true,
    );
    final initSetting = InitializationSettings(iOS: darwinSetting);

    await flutterNotificationsPlugin.initialize(
      initSetting,
      onDidReceiveNotificationResponse: (details) {
        print(details.payload);
      },
      onDidReceiveBackgroundNotificationResponse: notificationTapOnBackGround,
    );
  }

  static Future<void> show(String title, String content) async {
    await flutterNotificationsPlugin.show(
      0,
      title,
      content,
      NotificationDetails(
        iOS: DarwinNotificationDetails(
          presentSound: true,
          presentAlert: true,
          presentBadge: true,
        ),
      ),
      payload: 'hi',
    );
  }
}
