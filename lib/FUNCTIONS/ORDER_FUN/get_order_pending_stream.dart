import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:drawer_panel/API/auth_api.dart';
import 'package:drawer_panel/FUNCTIONS/ORDER_FUN/update_user_section.dart';
import 'package:drawer_panel/MODEL/ORDER/order_details.dart';
import 'package:drawer_panel/MODEL/ORDER/tracking_details.dart';
import 'package:fluttertoast/fluttertoast.dart';

class GetOrderDetails {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static final String userID = AuthApi.auth.currentUser!.uid;

  static Stream<int> getPendingCount() {
    return _firestore
        .collection('admins')
        .doc(userID)
        .snapshots()
        .map((documentSnapshot) {
      if (documentSnapshot.exists) {
        return documentSnapshot.data()?['pending'] ?? 0;
      }
      return 0;
    });
  }

  static Future<List<OrderDetailModel>> getOrdersConfirmed() async {
    try {
      CollectionReference ordersRef = AuthApi.orders;

      QuerySnapshot snapshot = await ordersRef.get();

      List<OrderDetailModel> orders = snapshot.docs
          .map((doc) {
            OrderDetailModel order =
                OrderDetailModel.fromJson(doc.data() as Map<String, dynamic>);
            if (order.tracking != null &&
                order.tracking!.stage == "Order Confirmed") {
              return order;
            } else {
              return null;
            }
          })
          .whereType<OrderDetailModel>()
          .toList();

      return orders;
    } catch (e) {
      log('Error fetching orders: $e');
      return [];
    }
  }

  static Future<List<OrderDetailModel>> getDeliveredOrders() async {
    try {
      CollectionReference ordersRef = AuthApi.orders;

      QuerySnapshot snapshot = await ordersRef.get();

      List<OrderDetailModel> orders = snapshot.docs
          .map((doc) {
            OrderDetailModel order =
                OrderDetailModel.fromJson(doc.data() as Map<String, dynamic>);
            if (order.tracking != null &&
                order.tracking!.stage == "Delivered") {
              return order;
            } else {
              return null;
            }
          })
          .whereType<OrderDetailModel>()
          .toList();

      return orders;
    } catch (e) {
      log('Error fetching orders: $e');
      return [];
    }
  }

  static Future<List<OrderDetailModel>> getOrdersUpdatable() async {
    try {
      CollectionReference ordersRef = AuthApi.orders;

      QuerySnapshot snapshot = await ordersRef.get();

      List<OrderDetailModel> orders = snapshot.docs
          .map((doc) {
            OrderDetailModel order =
                OrderDetailModel.fromJson(doc.data() as Map<String, dynamic>);
            if (order.tracking != null &&
                order.tracking!.stage != "Order Confirmed" &&
                order.tracking!.stage != "Delivered") {
              return order;
            } else {
              return null;
            }
          })
          .whereType<OrderDetailModel>()
          .toList();

      return orders;
    } catch (e) {
      log('Error fetching orders: $e');
      return [];
    }
  }

  static Future<TrackingModel?> getTrackingModelByOrderId(
      String orderId) async {
    try {
      DocumentReference orderRef = AuthApi.orders.doc(orderId);
      DocumentSnapshot snapshot = await orderRef.get();

      if (snapshot.exists) {
        OrderDetailModel order =
            OrderDetailModel.fromJson(snapshot.data() as Map<String, dynamic>);
        return order.tracking;
      }
      return null;
    } catch (e) {
      log('Error fetching tracking data for order $orderId: $e');
      return null;
    }
  }
}
