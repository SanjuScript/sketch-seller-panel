import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:drawer_panel/API/auth_api.dart';
import 'package:drawer_panel/HELPERS/CONSTANTS/show_toast.dart';
import 'package:firebase_core/firebase_core.dart';

class EditProduct {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  static Future<void> updateAvailability(
      String categoryId, String artTypeId, bool isAvailable) async {
    try {
      String userId = AuthApi.currentAdmin!.uid;
      final categoryRef = FirebaseFirestore.instance
          .collection('admins')
          .doc(userId)
          .collection('categories')
          .doc(categoryId);

      final categorySnapshot = await categoryRef.get();

      if (categorySnapshot.exists) {
        List<dynamic> types = categorySnapshot.data()?['types'] ?? [];

        int index = types.indexWhere((type) => type['id'] == artTypeId);
        if (index != -1) {
          types[index]['product']['isAvailable'] = isAvailable;

          await categoryRef.update({'types': types});
          showToast("Product availability updated successfully!");
        } else {
          log("Error: ArtType not found!");
        }
      } else {
        log("Error: Category not found!");
      }
    } catch (e) {
      log("Error updating availability: $e");
    }
  }

  static Future<void> updateOffer(
      String categoryId, String artTypeId, bool inOffer) async {
    try {
      String userId = AuthApi.currentAdmin!.uid;
      final categoryRef = FirebaseFirestore.instance
          .collection('admins')
          .doc(userId)
          .collection('categories')
          .doc(categoryId);

      final categorySnapshot = await categoryRef.get();

      if (categorySnapshot.exists) {
        List<dynamic> types = categorySnapshot.data()?['types'] ?? [];

        int index = types.indexWhere((type) => type['id'] == artTypeId);
        if (index != -1) {
          types[index]['product']['inOffer'] = inOffer;

          await categoryRef.update({'types': types});
          showToast("Offer value updated successfully!");
          log("Offer value updated successfully!");
        } else {
          log("Error: ArtType not found!");
        }
      } else {
        log("Error: Category not found!");
      }
    } catch (e) {
      log("Error updating availability: $e");
    }
  }
}
