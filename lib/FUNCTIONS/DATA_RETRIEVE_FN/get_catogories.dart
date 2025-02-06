import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:drawer_panel/API/auth_api.dart';
import 'package:drawer_panel/MODEL/DATA/art_type_model.dart';
import 'package:drawer_panel/MODEL/DATA/catogory_model.dart';

class GetCatogoriesFN {
  static final FirebaseFirestore firestore = FirebaseFirestore.instance;
    static final String name = AuthApi.auth.currentUser!.displayName ?? '';
    static final String userID = AuthApi.auth.currentUser!.uid;
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  static Future<CategoryModel?> getCategoryByName(String categoryName) async {
    try {
      log("Name: $categoryName");
      String userId = AuthApi.auth.currentUser!.uid;
      final categoryDoc =
          AuthApi.admins.doc(userId).collection('categories').doc(categoryName);

      final categorySnapshot = await categoryDoc.get();

      if (categorySnapshot.exists) {
        Map<String, dynamic> categoryData = categorySnapshot.data()!;
        // log(categoryData.toString(), name: "Category Data");
        log("Name :${categoryData['name']}", name: "Category name");

        CategoryModel categoryModel = CategoryModel.fromJson(categoryData);

        // log(categoryModel.toString(), name: "Category Model Data");

        return categoryModel;
      } else {
        log('Category does not exist', name: "Error");
        return null;
      }
    } catch (e, stackTrace) {
      log("Error: $e", name: "Exception");
      log("Stack Trace: $stackTrace", name: "Exception Stack Trace");
      return null;
    }
  }

  static Future<List<ArtTypeModel>> getTypesByName(
      String categoryName, String typeName) async {
    try {
      log("Category: $categoryName, Type Name: $typeName");

      final categoryDoc =
          AuthApi.admins.doc(userID).collection('categories').doc(categoryName);

      final categorySnapshot = await categoryDoc.get();

      if (categorySnapshot.exists) {
        Map<String, dynamic> categoryData = categorySnapshot.data()!;
        List<dynamic> typesData = categoryData['types'] ?? [];

        List<ArtTypeModel> filteredTypes = [];

        // Filter types by name
        for (var typeData in typesData) {
          if (typeData['name'] == typeName) {
            filteredTypes.add(ArtTypeModel.fromJson(typeData));
          }
        }

        log("Filtered Types: ${filteredTypes.length}", name: "Filtered Types");

        return filteredTypes;
      } else {
        log('Category does not exist', name: "Error");
        return [];
      }
    } catch (e, stackTrace) {
      log("Error: $e", name: "Exception");
      log("Stack Trace: $stackTrace", name: "Exception Stack Trace");
      return [];
    }
  }
}
