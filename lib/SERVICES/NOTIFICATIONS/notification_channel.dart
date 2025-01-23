import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationChannels {
  static const String orderChannelId = 'order_updates';
  static const String serviceChannelId = 'app_service_updates';

  static Future<void> initialize(
      FlutterLocalNotificationsPlugin plugin) async {
    const AndroidNotificationChannel orderChannel = AndroidNotificationChannel(
      orderChannelId,
      'Order Updates',
      description: 'Notifications related to orders (e.g., received, canceled).',
      importance: Importance.high,
    );

    const AndroidNotificationChannel serviceChannel = AndroidNotificationChannel(
      serviceChannelId,
      'App Service Updates',
      description: 'Notifications for app-related updates (data uploads, etc.).',
      importance: Importance.high,
    );

    final androidNotificationPlugin = plugin.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();
    await androidNotificationPlugin?.createNotificationChannel(orderChannel);
    await androidNotificationPlugin?.createNotificationChannel(serviceChannel);
  }
}
