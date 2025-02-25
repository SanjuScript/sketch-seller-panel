import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:drawer_panel/API/auth_api.dart';
import 'package:drawer_panel/HELPERS/CONSTANTS/show_toast.dart';

class UpdateAdminData {
  static Future<void> incrementTotalEarnings(num amount) async {
    try {
      final adminRef = AuthApi.currentAdminDoc;

      await FirebaseFirestore.instance.runTransaction((transaction) async {
        final adminSnapshot = await transaction.get(adminRef);

        if (adminSnapshot.exists) {
          final data = adminSnapshot.data() as Map<String, dynamic>?;
          double currentEarnings = (data?['total_earned'] ?? 0).toDouble();

          transaction
              .update(adminRef, {'total_earned': currentEarnings + amount});
        } else {
          log("Error: Admin document not found!");
        }
      });

      // showToast("Total earnings updated successfully!");
    } catch (e) {
      log("Error updating total earnings: $e");
      // showToast("Try again later $e");
    }
  }
}
