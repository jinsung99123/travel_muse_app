import 'package:shared_preferences/shared_preferences.dart';

class NotificationSettings {
  static const appNotificationKey = 'app_notifications_enabled';
  static const tripReminderKey = 'trip_reminder_enabled';
  static const commentNotificationKey = 'comment_notification_enabled';
  static const nightNotificationKey = 'night_notification_enabled';
  static const eventNotificationKey = 'event_notification_enabled';

  static Future<void> set(String key, bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(key, value);
  }

  static Future<bool> get(String key) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(key) ?? true;
  }
}
