import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:drawer_panel/API/auth_api.dart';
import 'package:drawer_panel/MODEL/ORDER/order_details.dart';

class UpdateUserSection {
  static Future<void> updateTrackingStageForUser(
      String userId, String orderId, String newStage) async {
    try {
      DocumentReference orderRef =
          AuthApi.users.doc(userId).collection('orders').doc(orderId);

      FieldValue serverTimestamp = FieldValue.serverTimestamp();

      await orderRef.update({
        'tracking.stage': newStage,
        'tracking.updated_at': serverTimestamp,
        'tracking.updatedStages.$newStage': serverTimestamp,
      });

      log('Tracking stage updated successfully in user orders collection');
    } catch (e) {
      log('Error updating tracking stage in user orders collection: $e');
    }
  }

  static Future<void> deleteUpdatedStageForUser(
      String userId, String orderId, String stageToDelete) async {
    try {
      DocumentReference orderRef =
          AuthApi.users.doc(userId).collection('orders').doc(orderId);
      DocumentSnapshot snapshot = await orderRef.get();

      if (snapshot.exists) {
        OrderDetailModel order =
            OrderDetailModel.fromJson(snapshot.data() as Map<String, dynamic>);

        if (stageToDelete != "Order Confirmed" &&
            stageToDelete != "Drawing Started") {
          if (order.tracking != null &&
              order.tracking!.updatedStages.containsKey(stageToDelete)) {
            List<MapEntry<String, dynamic>> sortedStages =
                order.tracking!.updatedStages.entries.toList();

            // Convert all values to DateTime for sorting
            sortedStages.sort((a, b) {
              DateTime timeA = (a.value is Timestamp)
                  ? (a.value as Timestamp).toDate()
                  : (a.value as DateTime);
              DateTime timeB = (b.value is Timestamp)
                  ? (b.value as Timestamp).toDate()
                  : (b.value as DateTime);
              return timeA.compareTo(timeB);
            });

            int stageIndex = sortedStages
                .indexWhere((element) => element.key == stageToDelete);
            String? previousStage =
                (stageIndex > 0) ? sortedStages[stageIndex - 1].key : null;

            order.tracking!.updatedStages.remove(stageToDelete);

            await orderRef.update({
              'tracking.updatedStages': order.tracking!.updatedStages,
              if (previousStage != null) 'tracking.stage': previousStage,
            });

            log('Stage "$stageToDelete" removed successfully from user orders collection. New stage: "$previousStage"');
          } else {
            log('Stage "$stageToDelete" does not exist or cannot be removed.');
          }
        } else {
          log('Cannot delete stage "$stageToDelete" as it is a protected stage.');
        }
      } else {
        log('Order not found for orderId: $orderId');
      }
    } catch (e) {
      log('Error deleting stage for user $userId, order $orderId: $e');
    }
  }
}
