import 'dart:developer';
import 'package:drawer_panel/ROUTER/page_routers.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationRouter {
  static void routeNotification(
      NotificationResponse notificationResponse) async {
    final payload = notificationResponse.payload;
    log(payload.toString(), name: "Payload");
    switch (payload) {
      case "order_received":
        log('Order Recieved');
        AppRouter.router.go("/orders");
        break;
      case "category_up":
        AppRouter.router.go('/catogory_up');
        break;
      case "logout_event":
        AppRouter.router.go('/login');
        break;
      default:
        AppRouter.router.go("/");
        break;
    }
  }
}
