import 'dart:convert';
import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:drawer_panel/PROVIDER/EDITING/bool_updates.dart';
import 'package:drawer_panel/PROVIDER/NAV/order_pending_provider.dart';
import 'package:drawer_panel/PROVIDER/VIEW/drawing_type_selector.dart';
import 'package:drawer_panel/PROVIDER/NAV/bottom_nav_provider.dart';
import 'package:drawer_panel/PROVIDER/image_downloader_provider.dart';
import 'package:drawer_panel/PROVIDER/network_provider.dart';
import 'package:drawer_panel/PROVIDER/product_slider_provider.dart';
import 'package:drawer_panel/PROVIDER/product_uploader_provider.dart';
import 'package:drawer_panel/PROVIDER/profile_editing_provider.dart';
import 'package:drawer_panel/ROUTER/page_routers.dart';
import 'package:drawer_panel/SERVICES/notification_service.dart';
import 'package:drawer_panel/STORAGE/app_storage.dart';
import 'package:drawer_panel/THEMES/app_theme.dart';
import 'package:drawer_panel/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:firebase_analytics/firebase_analytics.dart';

FirebaseAnalytics firebaseAnalytics = FirebaseAnalytics.instance;
Future _firebaseBackgroundMessage(RemoteMessage message) async {
  if (message.notification != null) {
    log("Some notification Received in background...");
  }
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  FirebaseFirestore.instance.settings = const Settings(
    persistenceEnabled: true,
  );
  if (kIsWeb) {
    var fbOptions = const FirebaseOptions(
      apiKey: 'AIzaSyCS0lfBMUfUXuwTmKia68SL_Ezzt-THuVE',
      appId: '1:50562737824:web:2308ca4393399812bbcbc5',
      messagingSenderId: '50562737824',
      projectId: 'drawing-seller',
      authDomain: 'drawing-seller.firebaseapp.com',
      storageBucket: 'drawing-seller.firebasestorage.app',
      measurementId: 'G-29QT88QH7M',
    );
    await Firebase.initializeApp(options: fbOptions);
  } else {
    await Firebase.initializeApp();
  }
  final isAuthenticated =
      await PerfectStateManager.readState('isAuthenticated') ?? false;
  isAuthenticatedNotifier.value = isAuthenticated;

  await NotificationService.localNotiInit();
  FirebaseMessaging.onBackgroundMessage(_firebaseBackgroundMessage);
  FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
    if (message.notification != null) {
      log("Background Notification Tapped");
      // handleNotificationTapped(message);
      log(message.toMap().toString());
      AppRouter.router.go("/");
    }
  });

  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    String payloadData = jsonEncode(message.data);
    log(payloadData, name: "payload data");
    log("Got a message in foreground");
    if (message.notification != null) {
      if (kIsWeb) {
        log("Web message");
      } else {
        NotificationService.showOrderNotification(
            title: message.notification!.title!,
            body: message.notification!.body!,
            payload: payloadData);
      }
    }
  });

  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => ProductUploaderProvider()),
      ChangeNotifierProvider(create: (_) => NetworkProvider()),
      ChangeNotifierProvider(create: (_) => ProductUploaderProvider()),
      ChangeNotifierProvider(create: (_) => ProductSliderProvider()),
      ChangeNotifierProvider(create: (_) => DrawingTypeProvider()),
      ChangeNotifierProvider(create: (_) => BottomNavProvider()),
      ChangeNotifierProvider(create: (_) => ProfileProvider()),
      ChangeNotifierProvider(create: (_) => PendingCountProvider()),
      ChangeNotifierProvider(create: (_) => DownloadProvider()),
      ChangeNotifierProvider(create: (_) => BoolUpdatesProvider()),
    ],
    child: const MyApp(),
  ));
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
        statusBarColor: Color.fromRGBO(0, 0, 0, 0),
        statusBarIconBrightness: Brightness.dark),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final networkProvider =
          Provider.of<NetworkProvider>(context, listen: false);
      networkProvider.executeOnConnected(() {
        NotificationService.getDeviceToken();
      });
    });
    return MaterialApp.router(
      routerDelegate: AppRouter.router.routerDelegate,
      routeInformationParser: AppRouter.router.routeInformationParser,
      routeInformationProvider: AppRouter.router.routeInformationProvider,
      theme: ArtTheme.lightTheme,
    );
  }
}
