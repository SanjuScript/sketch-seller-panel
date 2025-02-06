import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:drawer_panel/API/auth_api.dart';
import 'package:drawer_panel/HELPERS/CONSTANTS/unique_id_generator.dart';
import 'package:drawer_panel/MODEL/DATA/art_type_model.dart';
import 'package:drawer_panel/MODEL/DATA/drawing_type_model.dart';
import 'package:drawer_panel/MODEL/DATA/product_model.dart';
import 'package:drawer_panel/PROVIDER/product_uploader_provider.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';

class ProductUploader {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final FirebaseStorage firebaseStorage = FirebaseStorage.instance;
  final String name = AuthApi.auth.currentUser!.displayName ?? '';
  final String userID = AuthApi.auth.currentUser!.uid;

  Future<List<String>> uploadImages(
      List<File> imageFiles, String category) async {
    List<String> imageUrls = [];

    try {
      for (File imageFile in imageFiles) {
        String imagePath =
            'categories/$category/$userID/images/${DateTime.now().millisecondsSinceEpoch}_${imageFile.uri.pathSegments.last}';

        UploadTask uploadTask =
            firebaseStorage.ref().child(imagePath).putFile(imageFile);

        TaskSnapshot snapshot = await uploadTask;

        String downloadUrl = await snapshot.ref.getDownloadURL();
        imageUrls.add(downloadUrl);
      }

      log("Images uploaded successfully!");
    } catch (e) {
      log("Error uploading images: $e");
    }

    return imageUrls;
  }

  Product createProduct(
    ProductUploaderProvider provider,
    List<DrawingTypeModel> drawingTypes,
    List<String> imageUrls,
    String categoryId,
    String artTypeId,
  ) {
    String productId = GetUniqueID.getCustomUniqueId();
    final currentTimestamp = Timestamp.now();

    return Product(
      productId: "product$productId",
      title: provider.productTitleController.text,
      description: provider.descriptionController.text,
      artist: name,
      drawingTypes: drawingTypes,
      createdAt: currentTimestamp,
      isAvailable: true,
      inOffer: false,
      reviews: [],
      ownerID: userID,
      totalReviewCount: 0,
      avgRating: 0.0,
      images: imageUrls,
      categoryId: categoryId,
      artTypeId: artTypeId,
    );
  }

  ArtTypeModel createArtType(
      String artTypeId, String selectedType, Product product) {
    return ArtTypeModel(
      id: "arttype$artTypeId",
      name: selectedType,
      product: product,
    );
  }

  Future<void> handleCategoryData(
      String categoryId, String selectedCategory, ArtTypeModel artType) async {
    try {
      String userId = AuthApi.auth.currentUser!.uid;
      final categoryDoc = AuthApi.admins
          .doc(userId)
          .collection('categories')
          .doc(selectedCategory);

      final categorySnapshot = await categoryDoc.get();

      if (categorySnapshot.exists) {
        List<dynamic> existingTypes = categorySnapshot.data()?['types'] ?? [];
        existingTypes.add({
          'id': artType.id,
          'name': artType.name,
          "catName": selectedCategory,
          'product': artType.product.toMap(),
        });

        await categoryDoc.update({'types': existingTypes});
      } else {
        Map<String, dynamic> categoryData = {
          'id': "category$categoryId",
          'name': selectedCategory,
          'types': [
            {
              'id': artType.id,
              'name': artType.name,
              "catName": selectedCategory,
              'product': artType.product.toMap(),
            }
          ],
        };

        await categoryDoc.set(categoryData);
      }

      log("Category data handled successfully!");
    } catch (e) {
      log("Error handling category data: $e");
    }
  }

  Future<void> uploadProduct(
      ProductUploaderProvider provider,
      List<DrawingTypeModel> drawingTypes,
      String selectedType,
      String selectedCategory,
      List<File> imageFiles) async {
    try {
      String categoryId = GetUniqueID.getCustomUniqueId();
      String artTypeId = GetUniqueID.getCustomUniqueId();
      List<String> imageUrls = await uploadImages(imageFiles, selectedCategory);
      Product product = createProduct(provider, drawingTypes, imageUrls,
          "category$categoryId", "arttype$artTypeId");
      ArtTypeModel artType = createArtType(artTypeId, selectedType, product);
      await handleCategoryData(categoryId, selectedCategory, artType);
      log("Product upload successful!");
    } catch (e) {
      log("Error uploading product: $e");
    }
  }
}
