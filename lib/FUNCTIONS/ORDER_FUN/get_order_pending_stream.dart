import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:drawer_panel/API/auth_api.dart';
import 'package:drawer_panel/MODEL/ORDER/order_details.dart';
import 'package:drawer_panel/MODEL/ORDER/tracking_details.dart';

class GetOrderDetails {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static final String userID = AuthApi.auth.currentUser!.uid;

  static Stream<int> getPendingCount() {
    return AuthApi.orders
        .where("ownerID", isEqualTo: AuthApi.currentAdmin!.uid)
        .where("status", isEqualTo: "Pending")
        .snapshots()
        .map((snapshot) => snapshot.size);
  }

  static Stream<int> getDeliveredCount() {
    return AuthApi.orders
        .where("ownerID", isEqualTo: AuthApi.currentAdmin!.uid)
        .where("status", isEqualTo: "Delivered")
        .snapshots()
        .map((snapshot) => snapshot.size);
  }

  static Stream<num> getTotalEarnings() {
    return AuthApi.currentAdminDoc.snapshots().map((snapshot) {
      if (snapshot.exists) {
        final data = snapshot.data() as Map<String, dynamic>;
        return (data['total_earned'] ?? 0.0);
      } else {
        return 0.0;
      }
    });
  }

  static Future<List<OrderDetailModel>> getOrdersConfirmed() async {
    try {
      CollectionReference ordersRef = AuthApi.orders;

      QuerySnapshot snapshot = await ordersRef
          .where("ownerID", isEqualTo: AuthApi.currentAdmin!.uid)
          .where("tracking.stage", isEqualTo: "Order Confirmed")
          .orderBy("orderTime", descending: true)
          .get();

      List<OrderDetailModel> orders = snapshot.docs
          .map((doc) =>
              OrderDetailModel.fromJson(doc.data() as Map<String, dynamic>))
          .toList();

      return orders;
    } catch (e) {
      log('Error fetching orders: $e');
      return [];
    }
  }

  static Stream<bool> hasOrderIssue(String orderId) {
    return AuthApi.orders.doc(orderId).snapshots().map((snapshot) {
      if (snapshot.exists) {
        final data = snapshot.data() as Map<String, dynamic>;
        return data.containsKey('problem') &&
            (data['problem'] ?? "").isNotEmpty;
      }
      return false;
    });
  }

  static Future<List<OrderDetailModel>> getDeliveredOrders() async {
    try {
      QuerySnapshot snapshot = await AuthApi.orders
          .where("ownerID", isEqualTo: AuthApi.currentAdmin!.uid)
          .where("tracking.stage", isEqualTo: "Delivered")
          .get();

      return snapshot.docs
          .map((doc) =>
              OrderDetailModel.fromJson(doc.data() as Map<String, dynamic>))
          .toList();
    } catch (e) {
      log('Error fetching delivered orders: $e');
      return [];
    }
  }

  static Future<List<OrderDetailModel>> getOrdersUpdatable() async {
    try {
      QuerySnapshot snapshot = await AuthApi.orders
          .where("ownerID", isEqualTo: AuthApi.currentAdmin!.uid)
          .where("tracking.stage",
              whereNotIn: ["Order Confirmed", "Delivered"]).get();

      return snapshot.docs
          .map((doc) =>
              OrderDetailModel.fromJson(doc.data() as Map<String, dynamic>))
          .toList();
    } catch (e) {
      log('Error fetching updatable orders: $e');
      return [];
    }
  }

  static Future<TrackingModel?> getTrackingModelByOrderId(
      String orderId) async {
    try {
      DocumentSnapshot snapshot = await AuthApi.orders.doc(orderId).get();

      if (!snapshot.exists) {
        log('Order not found: $orderId');
        return null;
      }

      Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;

      if (data['tracking'] == null) {
        log('Tracking data not found for order: $orderId');
        return null;
      }
      Map<String, dynamic> trackingData = data['tracking'];
      trackingData['updated_at'] = trackingData['updated_at'] is Timestamp
          ? trackingData['updated_at']
          : null;

      if (trackingData['updatedStages'] is Map) {
        trackingData['updatedStages'].forEach((key, value) {
          if (value is! Timestamp) {
            trackingData['updatedStages'][key] = null;
          }
        });
      }

      return TrackingModel.fromJson(trackingData);
    } catch (e) {
      log('Error fetching tracking data for order $orderId: $e');
      return null;
    }
  }
}
