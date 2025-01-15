import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:drawer_panel/PROVIDER/NAV/order_pending_provider.dart';
import 'package:drawer_panel/PROVIDER/VIEW/drawing_type_selector.dart';
import 'package:drawer_panel/PROVIDER/NAV/bottom_nav_provider.dart';
import 'package:drawer_panel/PROVIDER/network_provider.dart';
import 'package:drawer_panel/PROVIDER/product_slider_provider.dart';
import 'package:drawer_panel/PROVIDER/product_uploader_provider.dart';
import 'package:drawer_panel/PROVIDER/profile_editing_provider.dart';
import 'package:drawer_panel/SCREENS/AUTH_SCREEN/login_screen.dart';
import 'package:drawer_panel/SCREENS/NAV_SCREENS/bottom_nav.dart';
import 'package:drawer_panel/STORAGE/app_storage.dart';
import 'package:drawer_panel/THEMES/app_theme.dart';
import 'package:drawer_panel/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

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
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(
        create: (_) => ProductUploaderProvider(),
      ),
      ChangeNotifierProvider(
        create: (_) => NetworkProvider(),
      ),
      ChangeNotifierProvider(
        create: (_) => ProductUploaderProvider(),
      ),
      ChangeNotifierProvider(
        create: (_) => ProductSliderProvider(),
      ),
      ChangeNotifierProvider(
        create: (_) => DrawingTypeProvider(),
      ),
      ChangeNotifierProvider(
        create: (_) => BottomNavProvider(),
      ),
      ChangeNotifierProvider(
        create: (_) => ProfileProvider(),
      ),
      ChangeNotifierProvider(
        create: (_) => PendingCountProvider(),
      ),
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
    return MaterialApp(
      theme: ArtTheme.lightTheme,
      home: FutureBuilder<bool>(
        future: PerfectStateManager.checkAuthState(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(
              body: CircularProgressIndicator(),
            );
          }

          final bool isAuthenticated = snapshot.data ?? false;
          log(isAuthenticated.toString());
          if (isAuthenticated) {
            return const BottomNav();
          } else {
            return const GoogleLoginScreen();
          }
        },
      ),
    );
  }
}
