import 'dart:developer';

import 'package:drawer_panel/SCREENS/AUTH_SCREEN/login_screen.dart';
import 'package:drawer_panel/SCREENS/data_uploading_screen.dart';
import 'package:drawer_panel/SCREENS/home_screen.dart';
import 'package:drawer_panel/STORAGE/app_storage.dart';
import 'package:drawer_panel/THEMES/app_theme.dart';
import 'package:drawer_panel/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
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
            return ProductUploadScreen();
          } else {
            return  GoogleLoginScreen();
          }
        },
      ),
    );
  }
}
