import 'dart:developer';
import 'package:drawer_panel/SCREENS/AUTH_SCREEN/login_screen.dart';
import 'package:drawer_panel/SCREENS/NAV_SCREENS/bottom_nav.dart';
import 'package:drawer_panel/SCREENS/catogory_screen.dart';
import 'package:drawer_panel/SCREENS/splash_screen.dart';
import 'package:drawer_panel/SERVICES/notification_service.dart';
import 'package:drawer_panel/WIDGETS/DIALOGS/notification_permission_dialogue.dart';
import 'package:drawer_panel/main.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

GlobalKey<NavigatorState> navigationKey = GlobalKey<NavigatorState>();
final ValueNotifier<bool> isAuthenticatedNotifier = ValueNotifier(false);

class AppRouter {
  static final GoRouter router = GoRouter(
    navigatorKey: navigationKey,
    refreshListenable: isAuthenticatedNotifier,
    observers: [FirebaseAnalyticsObserver(analytics: firebaseAnalytics)],
    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/',  
        builder: (context, state) {
          return const SplashScreen();
        },
      ),
      GoRoute(
        path: '/home',
        builder: (context, state) => const BottomNav(),
      ),
      GoRoute(
        path: '/login',
        builder: (context, state) => const GoogleLoginScreen(),
      ),
      GoRoute(
        path: '/catogory_up',
        builder: (context, state) => const CatogoryUploader(),
      ),
    ],
    redirect: (context, state) {
      final isLoggedIn = isAuthenticatedNotifier.value;
      final goingToLogin = state.matchedLocation == '/login';

      if (!isLoggedIn && !goingToLogin) {
        return '/login';
      }
      if (isLoggedIn && goingToLogin) {
        return '/home';
      }
      return null;
    },
  );
}

Future<void> checkNotificationPermission(BuildContext context) async {
  bool isNotificationEnabled =
      await NotificationService.checkNotificationPermission();
  if (!isNotificationEnabled) {
    showDialog(
      // ignore: use_build_context_synchronously
      context: context,
      builder: (BuildContext context) {
        return const NotificationPermissionDialog();
      },
    );
  }
}
