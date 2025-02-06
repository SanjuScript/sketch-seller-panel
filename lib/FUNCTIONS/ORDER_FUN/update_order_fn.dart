import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:drawer_panel/API/auth_api.dart';
import 'package:drawer_panel/FUNCTIONS/NOTIFICATIONS/notifications_sender.dart';
import 'package:drawer_panel/FUNCTIONS/ORDER_FUN/update_user_section.dart';
import 'package:drawer_panel/HELPERS/CONSTANTS/order_update_msgs.dart';
import 'package:drawer_panel/HELPERS/CONSTANTS/show_toast.dart';
import 'package:drawer_panel/MODEL/ORDER/order_details.dart';
import 'package:drawer_panel/MODEL/user_model.dart';
import 'package:fluttertoast/fluttertoast.dart';

class UpdateOrderDetails {
  static Future<void> updateTrackingStage(
      UserDataModel user, String orderId, String newStage) async {
    try {
      DocumentReference orderRef = AuthApi.orders.doc(orderId);

      FieldValue serverTimestamp = FieldValue.serverTimestamp();

      await orderRef.update({
        'tracking.stage': newStage,
        'tracking.updated_at': serverTimestamp,
        'tracking.updatedStages.$newStage': serverTimestamp,
      });
      Map<String, String> notificationData =
          OrderUpdateMsgs.getNotificationData(newStage);
      await SendNotification.toSpecificOne(
          user.nfToken!, notificationData['title']!, notificationData['body']!);
      await UpdateUserSection.updateTrackingStageForUser(
          user.uid!, orderId, newStage);
      showToast("Tracking stage updated successfully");
      log('Tracking stage updated successfully');
    } catch (e) {
      log('Error updating tracking stage: $e');
    }
  }

 static Future<void> deleteUpdatedStage(String userId, String orderId, String stageToDelete) async {
  try {
    DocumentReference orderRef = AuthApi.orders.doc(orderId);
    DocumentSnapshot snapshot = await orderRef.get();

    if (snapshot.exists) {
      OrderDetailModel order =
          OrderDetailModel.fromJson(snapshot.data() as Map<String, dynamic>);

      if (stageToDelete != "Order Confirmed" &&
          stageToDelete != "Drawing Started") {
        if (order.tracking != null &&
            order.tracking!.updatedStages.containsKey(stageToDelete)) {
          
          List<MapEntry<String, dynamic>> sortedStages = order.tracking!.updatedStages.entries.toList();

          // Convert all values to DateTime for sorting
          sortedStages.sort((a, b) {
            DateTime timeA = (a.value is Timestamp) ? (a.value as Timestamp).toDate() : (a.value as DateTime);
            DateTime timeB = (b.value is Timestamp) ? (b.value as Timestamp).toDate() : (b.value as DateTime);
            return timeA.compareTo(timeB);
          });

          int stageIndex = sortedStages.indexWhere((element) => element.key == stageToDelete);
          String? previousStage = (stageIndex > 0) ? sortedStages[stageIndex - 1].key : null;

          order.tracking!.updatedStages.remove(stageToDelete);

          await orderRef.update({
            'tracking.updatedStages': order.tracking!.updatedStages,
            if (previousStage != null) 'tracking.stage': previousStage,
          });

          await UpdateUserSection.deleteUpdatedStageForUser(userId, orderId, stageToDelete);

          Fluttertoast.showToast(
              msg: 'Stage "$stageToDelete" removed successfully. Stage updated to "$previousStage"');
          log('Stage "$stageToDelete" removed successfully. New stage: "$previousStage"');
        } else {
          log('Stage "$stageToDelete" does not exist or cannot be removed.');
        }
      } else {
        Fluttertoast.showToast(
            msg: 'Cannot delete stage "$stageToDelete" as it is a protected stage.');
      }
    } else {
      log('Order not found for orderId: $orderId');
    }
  } catch (e) {
    log('Error deleting stage for order $orderId: $e');
  }
}

}
