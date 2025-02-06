import 'package:drawer_panel/MODEL/HELPER/status_model.dart';
import 'package:flutter/material.dart';

class StatusDataGetter {
  static List<StatusModel> getStatuses(String? currentStage) {
    List<StatusModel> statuses = [
      StatusModel(
          title: "Order Confirmed",
          subtitle: "Your order has been confirmed",
          icon: Icons.check_circle),
      StatusModel(
          title: "Drawing Started",
          subtitle: "Artist has started the drawing",
          icon: Icons.brush),
      StatusModel(
          title: "Drawing Completed",
          subtitle: "The drawing is now completed",
          icon: Icons.format_paint),
      StatusModel(
          title: "Shipped",
          subtitle: "Your order has been shipped",
          icon: Icons.local_shipping),
      StatusModel(
          title: "Out for Delivery",
          subtitle: "Order is on the way",
          icon: Icons.delivery_dining),
    ];

    if (currentStage == "Delivery Failed") {
      statuses.add(StatusModel(
          title: "Delivery Failed",
          color: Colors.red[400]!,
          subtitle: "The delivery attempt was unsuccessful",
          icon: Icons.error_outline));
    } else if (currentStage == "Refunded") {
      statuses.add(StatusModel(
          title: "Refunded",
          color: Colors.blueAccent,
          subtitle: "Refund Comepleted",
          icon: Icons.done_all));
    } else {
      statuses.add(StatusModel(
          title: "Delivered",
          color: Colors.green,
          subtitle: "Your order has been delivered",
          icon: Icons.done_all));
    }

    return statuses;
  }

  static List<StatusModel> getStatusesForDropDown() {
    List<StatusModel> statuses = [
      StatusModel(
          title: "Order Confirmed",
          subtitle: "Your order has been confirmed",
          icon: Icons.check_circle),
      StatusModel(
          title: "Drawing Started",
          subtitle: "Artist has started the drawing",
          icon: Icons.brush),
      StatusModel(
          title: "Drawing Completed",
          subtitle: "The drawing is now completed",
          icon: Icons.format_paint),
      StatusModel(
          title: "Shipped",
          subtitle: "Your order has been shipped",
          icon: Icons.local_shipping),
      StatusModel(
          title: "Out for Delivery",
          subtitle: "Order is on the way",
          icon: Icons.delivery_dining),
      StatusModel(
          title: "Delivery Failed",
          color: Colors.red[400]!,
          subtitle: "The delivery attempt was unsuccessful",
          icon: Icons.error_outline),
      StatusModel(
          title: "Refunded",
          color: Colors.blueAccent,
          subtitle: "Refund Comepleted",
          icon: Icons.payments_rounded),
      StatusModel(
          title: "Delivered",
          color: Colors.green,
          subtitle: "Your order has been delivered",
          icon: Icons.done_all)
    ];

    return statuses;
  }

  static List<String> getStatusProgression() {
    return [
      "Order Confirmed",
      "Drawing Started",
      "Drawing Completed",
      "Shipped",
      "Out for Delivery",
      "Delivered",
      "Refunded",
      "Delivery Failed"
    ];
  }
}
