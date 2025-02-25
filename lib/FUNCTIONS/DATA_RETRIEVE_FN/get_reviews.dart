import 'dart:developer';

import 'package:drawer_panel/API/auth_api.dart';
import 'package:drawer_panel/MODEL/DATA/review_model.dart';

class GetReviews {
  static Future<List<ReviewModel>> getAllReviews(String productId) async {
    try {
      final reviewSnapshot =
          await AuthApi.reviews.doc(productId).collection('userReviews').get();

      if (reviewSnapshot.docs.isEmpty) {
        return [];
      }

      List<ReviewModel> reviews = reviewSnapshot.docs.map((doc) {
        return ReviewModel.fromJson(doc.data());
      }).toList();

      return reviews;
    } catch (e) {
      log("Error getting reviews: $e");
      return [];
    }
  }
}
