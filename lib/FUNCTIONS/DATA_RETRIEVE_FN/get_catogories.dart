import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:drawer_panel/API/auth_api.dart';
import 'package:drawer_panel/HELPERS/CONSTANTS/show_toast.dart';
import 'package:drawer_panel/MODEL/DATA/art_type_model.dart';
import 'package:drawer_panel/MODEL/DATA/catogory_model.dart';
import 'package:firebase_storage/firebase_storage.dart';

class GetCatogoriesFN {
  static final FirebaseFirestore firestore = FirebaseFirestore.instance;
  static final String name = AuthApi.auth.currentUser!.displayName ?? '';
  static final String userID = AuthApi.auth.currentUser!.uid;
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  static Stream<CategoryModel?> getCategoryByName(String categoryName) {
    try {
      log("Listening to changes for category: $categoryName");
      String userId = AuthApi.auth.currentUser!.uid;

      final categoryDoc =
          AuthApi.admins.doc(userId).collection('categories').doc(categoryName);

      return categoryDoc.snapshots().map((snapshot) {
        if (snapshot.exists) {
          Map<String, dynamic> categoryData = snapshot.data()!;
          log("Updated Category: ${categoryData['name']}",
              name: "Category Stream");
          return CategoryModel.fromJson(categoryData);
        } else {
          log('Category does not exist', name: "Error");
          return null;
        }
      });
    } catch (e, stackTrace) {
      log("Error: $e", name: "Exception");
      log("Stack Trace: $stackTrace", name: "Exception Stack Trace");
      return const Stream.empty(); // Return an empty stream on error
    }
  }

  static Future<ArtTypeModel?> getArtTypeByName(
      String categoryName, String artTypeId) async {
    try {
      log("Fetching art type: $artTypeId in category: $categoryName");
      String userId = AuthApi.auth.currentUser!.uid;

      final categoryDoc =
          AuthApi.admins.doc(userId).collection('categories').doc(categoryName);

      final categorySnapshot = await categoryDoc.get();

      if (categorySnapshot.exists) {
        Map<String, dynamic> categoryData = categorySnapshot.data()!;
        List<dynamic> types = categoryData['types'] ?? [];

        var artTypeData = types.firstWhere(
          (type) => type['id'] == artTypeId,
          orElse: () => null,
        );

        if (artTypeData != null) {
          log("Fetched ArtType: ${artTypeData['name']}", name: "ArtType Fetch");
          return ArtTypeModel.fromJson(artTypeData);
        } else {
          log("ArtType not found in category", name: "Error");
          return null;
        }
      } else {
        log("Category does not exist", name: "Error");
        return null;
      }
    } catch (e, stackTrace) {
      log("Error: $e", name: "Exception");
      log("Stack Trace: $stackTrace", name: "Exception Stack Trace");
      return null;
    }
  }

  static Future<List<String>> getArtTypeImages(
      String categoryName, String artTypeId) async {
    try {
      log("Fetching images for art type: $artTypeId in category: $categoryName");
      String userId = AuthApi.auth.currentUser!.uid;

      final categoryDoc =
          AuthApi.admins.doc(userId).collection('categories').doc(categoryName);

      final categorySnapshot = await categoryDoc.get();

      if (categorySnapshot.exists) {
        Map<String, dynamic> categoryData = categorySnapshot.data()!;
        List<dynamic> types = categoryData['types'] ?? [];

        var artTypeData = types.firstWhere(
          (type) => type['id'] == artTypeId,
          orElse: () => null,
        );

        if (artTypeData != null) {
          List<String> images =
              List<String>.from(artTypeData['product']['images'] ?? []);
          log("Fetched ${images.length} images", name: "Image Fetch");
          return images;
        } else {
          log("ArtType not found in category", name: "Error");
          return [];
        }
      } else {
        log("Category does not exist", name: "Error");
        return [];
      }
    } catch (e, stackTrace) {
      log("Error: $e", name: "Exception");
      log("Stack Trace: $stackTrace", name: "Exception Stack Trace");
      return [];
    }
  }

  static Future<bool> deleteArtTypeImage({
    required String categoryName,
    required String artTypeId,
    required String imageUrl,
  }) async {
    try {
      log("Deleting image: $imageUrl for art type: $artTypeId in category: $categoryName");

      String userId = AuthApi.auth.currentUser!.uid;

      final categoryDoc =
          AuthApi.admins.doc(userId).collection('categories').doc(categoryName);

      final categorySnapshot = await categoryDoc.get();

      if (!categorySnapshot.exists) {
        log("Category does not exist", name: "Error");
        return false;
      }

      Map<String, dynamic> categoryData = categorySnapshot.data()!;
      List<dynamic> types = categoryData['types'] ?? [];

      var artTypeIndex = types.indexWhere((type) => type['id'] == artTypeId);
      if (artTypeIndex == -1) {
        log("ArtType not found in category", name: "Error");
        return false;
      }

      List<String> images =
          List<String>.from(types[artTypeIndex]['product']['images'] ?? []);

      if (images.length <= 1) {
        log("Cannot delete. Only one image left.", name: "Restriction");
        showToast("Cannot delete. Only one image left.");
        return false;
      }

      images.remove(imageUrl);
      types[artTypeIndex]['product']['images'] = images;
      await categoryDoc.update({'types': types});

      log("Image deleted from Firestore", name: "Firestore");

      try {
        await FirebaseStorage.instance.refFromURL(imageUrl).delete();
        log("Image deleted from Storage", name: "Firebase Storage");
      } catch (storageError) {
        log("Storage delete failed: $storageError", name: "Error");
      }

      return true;
    } catch (e, stackTrace) {
      log("Error: $e", name: "Exception");
      log("Stack Trace: $stackTrace", name: "Exception Stack Trace");
      return false;
    }
  }

  static Future<bool> uploadImages({
    required String categoryName,
    required String artTypeId,
    required List<File> imageFiles,
  }) async {
    try {
      log("Uploading images for art type: $artTypeId in category: $categoryName");

      String userId = AuthApi.auth.currentUser!.uid;
      final categoryDoc =
          AuthApi.admins.doc(userId).collection('categories').doc(categoryName);

      final categorySnapshot = await categoryDoc.get();
      if (!categorySnapshot.exists) {
        log("Category does not exist", name: "Error");
        return false;
      }

      Map<String, dynamic> categoryData = categorySnapshot.data()!;
      List<dynamic> types = categoryData['types'] ?? [];

      var artTypeIndex = types.indexWhere((type) => type['id'] == artTypeId);
      if (artTypeIndex == -1) {
        log("ArtType not found in category", name: "Error");
        return false;
      }

      List<String> uploadedImageUrls = [];

      for (var imageFile in imageFiles) {
        String imagePath =
            'categories/$categoryName/$userId/images/${DateTime.now().millisecondsSinceEpoch}_${imageFile.uri.pathSegments.last}';

        UploadTask uploadTask =
            FirebaseStorage.instance.ref(imagePath).putFile(imageFile);

        TaskSnapshot taskSnapshot = await uploadTask;
        String downloadUrl = await taskSnapshot.ref.getDownloadURL();
        uploadedImageUrls.add(downloadUrl);
      }

      List<String> existingImages =
          List<String>.from(types[artTypeIndex]['product']['images'] ?? []);
      existingImages.addAll(uploadedImageUrls);
      types[artTypeIndex]['product']['images'] = existingImages;

      await categoryDoc.update({'types': types});

      log("All images uploaded successfully", name: "Firestore");
      return true;
    } catch (e, stackTrace) {
      log("Error: $e", name: "Exception");
      log("Stack Trace: $stackTrace", name: "Exception Stack Trace");
      return false;
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
