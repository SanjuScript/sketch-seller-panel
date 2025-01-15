import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:drawer_panel/API/auth_api.dart';
import 'package:flutter/material.dart';

class GetOrderPendingCount {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static final String userID = AuthApi.auth.currentUser!.uid;

  static Stream<int> getPendingCount() {
    return _firestore
        .collection('admins')
        .doc(userID)
        .snapshots()
        .map((documentSnapshot) {
      if (documentSnapshot.exists) {
        return documentSnapshot.data()?['pending'] ??
            0; 
      }
      return 0;
    });
  }
}
