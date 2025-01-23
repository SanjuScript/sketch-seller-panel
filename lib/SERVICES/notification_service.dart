import 'dart:convert';
import 'dart:developer';
import 'package:drawer_panel/FUNCTIONS/USER_DATA_FN/user_data_fn.dart';
import 'package:drawer_panel/ROUTER/notification_router.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  static final _firebaseMessaging = FirebaseMessaging.instance;
  static final FlutterLocalNotificationsPlugin
      _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  // Notification Channel IDs
  static const String orderChannelId = 'order_updates';
  static const String serviceChannelId = 'app_service_updates';

  static Future<void> init() async {
    // Request notification permission
    await _firebaseMessaging.requestPermission(
      alert: true,
      announcement: true,
      badge: true,
      carPlay: false,
      criticalAlert: true,
      provisional: false,
      sound: true,
    );
  }

  static Future<bool> checkNotificationPermission() async {
    bool notificationEnabled = false;
    if (!kIsWeb) {
      final NotificationSettings settings =
          await _firebaseMessaging.requestPermission();
      notificationEnabled =
          settings.authorizationStatus == AuthorizationStatus.authorized;
    }
    return notificationEnabled;
  }

  static Future<String?> getDeviceToken({int maxRetries = 3}) async {
    try {
      String? token;
      if (kIsWeb) {
        token = await _firebaseMessaging.getToken(
          vapidKey:
              "BNMobWMcOOFEOfXsXrKYl5QRYg_kBUmbBsHV0tZyYGNZNO03fB9YlkiXpgGGzrMqBio1iiTzPszMUstAfPMgIOs",
        );
        log("Web device token: $token");
      } else {
        token = await _firebaseMessaging.getToken();
        log("Android device token: $token");
      }
      await UserData.storeNotificationToken(token ?? "");
      return token;
    } catch (e) {
      log("Failed to get device token: $e");
      if (maxRetries > 0) {
        log("Retrying in 10 seconds...");
        await Future.delayed(const Duration(seconds: 10));
        return getDeviceToken(maxRetries: maxRetries - 1);
      }
      return null;
    }
  }

  static Future<void> localNotiInit() async {
    // Define Order Updates Notification Channel
    const AndroidNotificationChannel orderChannel = AndroidNotificationChannel(
      orderChannelId,
      'Order Updates',
      description: 'Notifications related to orders (received, canceled, etc.)',
      importance: Importance.high,
    );

    // Define App Service Updates Notification Channel
    const AndroidNotificationChannel serviceChannel =
        AndroidNotificationChannel(
      serviceChannelId,
      'App Service Updates',
      description: 'Notifications for app-related updates (data uploads, etc.)',
      importance: Importance.high,
    );

    // Create Notification Channels
    final androidNotificationPlugin =
        _flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>();
    await androidNotificationPlugin?.createNotificationChannel(orderChannel);
    await androidNotificationPlugin?.createNotificationChannel(serviceChannel);

    // Initialization settings for all platforms
    const AndroidInitializationSettings androidInitializationSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const DarwinInitializationSettings iosInitializationSettings =
        DarwinInitializationSettings();
    const LinuxInitializationSettings linuxInitializationSettings =
        LinuxInitializationSettings(defaultActionName: 'Open notification');

    const InitializationSettings initializationSettings =
        InitializationSettings(
      android: androidInitializationSettings,
      iOS: iosInitializationSettings,
      linux: linuxInitializationSettings,
    );

    await _flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: onNotificationTap,
      onDidReceiveBackgroundNotificationResponse: onNotificationTap,
    );
  }

  static void onNotificationTap(
      NotificationResponse notificationResponse) async {
    log("Notification Response: ${notificationResponse.payload}");
    NotificationRouter.routeNotification(notificationResponse);
  }

  // Show Order Updates Notification
  static Future<void> showOrderNotification({
    required String title,
    required String body,
    required String payload,
  }) async {
    const AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails(
      orderChannelId,
      'Order Updates',
      channelDescription: 'Updates about orders (e.g., received, canceled)',
      importance: Importance.max,
      priority: Priority.high,
    );
  
    const NotificationDetails notificationDetails = NotificationDetails(
      android: androidNotificationDetails,
    );

    await _flutterLocalNotificationsPlugin.show(
      0,
      title,
      body,
      notificationDetails,
      payload: payload,
    );
    log("Order Notification Payload: $payload");
  }

  // Show App Service Updates Notification
  static Future<void> showServiceNotification({
    required String title,
    required String body,
    required String payload,
    required String imageUrl,
  }) async {
    try {
      ByteData byteData = await rootBundle.load(imageUrl);
      Uint8List imageBytes = byteData.buffer.asUint8List();
      final BigPictureStyleInformation bigPictureStyleInformation =
          BigPictureStyleInformation(
              ByteArrayAndroidBitmap.fromBase64String(base64Encode(imageBytes)),
              largeIcon: ByteArrayAndroidBitmap.fromBase64String(
                  base64Encode(imageBytes)),
              contentTitle: title,
              summaryText: body);

      AndroidNotificationDetails androidNotificationDetails =
          AndroidNotificationDetails(serviceChannelId, 'App Service Updates',
              channelDescription:
                  'Updates about app services (e.g., upload success/failure)',
              importance: Importance.max,
              priority: Priority.high,
              styleInformation: bigPictureStyleInformation);

      NotificationDetails notificationDetails = NotificationDetails(
        android: androidNotificationDetails,
      );
      await _flutterLocalNotificationsPlugin.show(
        1,
        title,
        body,
        notificationDetails,
        payload: payload,
      );
      log("Service Notification Payload: $payload");
    } catch (e) {
      log("Error showing service notification with image: $e");
    }
  }

  static Future<void> showLogoutNotification({
    required String title,
    required String body,
    required String payload,
  }) async {
    try {
      const AndroidNotificationDetails androidNotificationDetails =
          AndroidNotificationDetails(
        serviceChannelId,
        'Silent Notifications',
        channelDescription: 'Silent notifications for background events.',
        importance: Importance.low,
        priority: Priority.low,
        playSound: false,
        silent: true,
        enableVibration: false,
      );

      const NotificationDetails notificationDetails = NotificationDetails(
        android: androidNotificationDetails,
      );

      await _flutterLocalNotificationsPlugin.show(
        2,
        title,
        body,
        notificationDetails,
        payload: payload,
      );
      log("Silent Logout Notification Payload: $payload");
    } catch (e) {
      log("Error showing silent logout notification: $e");
    }
  }
}
