import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:drawer_panel/API/auth_api.dart';
import 'package:drawer_panel/FUNCTIONS/NOTIFICATIONS/notifications_sender.dart';
import 'package:drawer_panel/HELPERS/CONSTANTS/order_update_msgs.dart';
import 'package:drawer_panel/HELPERS/CONSTANTS/show_toast.dart';
import 'package:drawer_panel/MODEL/ORDER/order_details.dart';
import 'package:drawer_panel/MODEL/user_model.dart';
import 'package:fluttertoast/fluttertoast.dart';

class UpdateOrderDetails {
  static Future<void> updateTrackingStage(
      String nfToken, String orderId, String newStage) async {
    try {
      DocumentReference orderRef = AuthApi.orders.doc(orderId);
      FieldValue serverTimestamp = FieldValue.serverTimestamp();

      await orderRef.update({
        'tracking.stage': newStage,
        'tracking.updated_at': serverTimestamp,
        'tracking.updatedStages.$newStage': serverTimestamp,
      });
      if (nfToken != null && nfToken!.isNotEmpty) {
        Map<String, String> notificationData =
            OrderUpdateMsgs.getNotificationData(newStage);
        log("Notification $nfToken");
        await SendNotification.toSpecificOne(
          nfToken!,
          notificationData['title'] ?? "Order Update",
          notificationData['body'] ?? "Your order status has been updated.",
        );
      }

      showToast("Tracking stage updated successfully");
      log('Tracking stage updated successfully');
    } catch (e) {
      log('Error updating tracking stage: $e');
    }
  }

  static Future<void> deleteUpdatedStage(
      String userId, String orderId, String stageToDelete) async {
    try {
      DocumentReference orderRef = AuthApi.orders.doc(orderId);
      DocumentSnapshot snapshot = await orderRef.get();

      if (!snapshot.exists) {
        log('Order not found for orderId: $orderId');
        Fluttertoast.showToast(msg: "Order not found!");
        return;
      }

      OrderDetailModel order =
          OrderDetailModel.fromJson(snapshot.data() as Map<String, dynamic>);

      if (stageToDelete == "Order Confirmed" ||
          stageToDelete == "Drawing Started") {
        Fluttertoast.showToast(
            msg:
                'Cannot delete stage "$stageToDelete" as it is a protected stage.');
        return;
      }

      if (order.tracking == null ||
          !order.tracking!.updatedStages.containsKey(stageToDelete)) {
        log('Stage "$stageToDelete" does not exist or cannot be removed.');
        Fluttertoast.showToast(msg: 'Stage "$stageToDelete" does not exist.');
        return;
      }

      List<MapEntry<String, dynamic>> sortedStages =
          order.tracking!.updatedStages.entries.toList();

      sortedStages.sort((a, b) {
        DateTime timeA = (a.value is Timestamp)
            ? (a.value as Timestamp).toDate()
            : (a.value as DateTime);
        DateTime timeB = (b.value is Timestamp)
            ? (b.value as Timestamp).toDate()
            : (b.value as DateTime);
        return timeA.compareTo(timeB);
      });

      int stageIndex =
          sortedStages.indexWhere((element) => element.key == stageToDelete);
      String? previousStage =
          (stageIndex > 0) ? sortedStages[stageIndex - 1].key : null;

      order.tracking!.updatedStages.remove(stageToDelete);

      await orderRef.update({
        'tracking.updatedStages': order.tracking!.updatedStages,
        if (previousStage != null) 'tracking.stage': previousStage,
      });

      Fluttertoast.showToast(
          msg:
              'Stage "$stageToDelete" removed successfully. Updated to "$previousStage"');
      log('Stage "$stageToDelete" removed successfully. New stage: "$previousStage"');
    } catch (e) {
      log('Error deleting stage for order $orderId: $e');
      Fluttertoast.showToast(msg: "Failed to delete stage!");
    }
  }

  static Future<void> updateOrderProblem({
    required String orderId,
    required String problemMessage,
    required String nfToken,
  }) async {
    try {
      CollectionReference ordersRef = AuthApi.orders;

      await ordersRef.doc(orderId).update({
        'problem': problemMessage,
      });
      SendNotification.toSpecificOne(
          nfToken, "Your order has an issue", problemMessage);
      showToast("Problem updated successfully for Order ID: $orderId");
    } catch (e) {
      log('Error updating order problem: $e');
    }
  }

  static Future<void> updateOrderDeliveryTime({
    required String orderId,
    required int additionalDays,
  }) async {
    try {
      DocumentReference orderRef = AuthApi.orders.doc(orderId);

      await orderRef.update({
        'delivery_within': additionalDays,
        'estimated_delivery': DateTime.now().add(Duration(days: additionalDays))
      });

      showToast("Delivery time updated successfully for Order ID: $orderId");
    } catch (e) {
      log('Error updating delivery time: $e');
    }
  }
}
