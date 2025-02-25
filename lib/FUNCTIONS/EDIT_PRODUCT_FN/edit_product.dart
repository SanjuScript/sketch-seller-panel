import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:drawer_panel/API/auth_api.dart';
import 'package:drawer_panel/HELPERS/CONSTANTS/show_toast.dart';
import 'package:drawer_panel/MODEL/DATA/drawing_type_model.dart';
import 'package:drawer_panel/MODEL/DATA/product_size_model.dart';

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

  static Future<void> updateOfferMsg(
      String categoryId, String artTypeId, String msg) async {
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
          types[index]['product']['offermsg'] = msg;

          await categoryRef.update({'types': types});
          showToast("Offer message updated successfully!");
        } else {
          log("Error: ArtType not found!");
        }
      } else {
        log("Error: Category not found!");
      }
    } catch (e) {
      log("Error updating offer message: $e");
      showToast("Try again later $e");
    }
  }

  static Future<void> incrementProductStats(
      String categoryId, String artTypeId, num orderRevenue) async {
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
          Map<String, dynamic> product = types[index]['product'];

          product['revenue'] = (product['revenue'] ?? 0) + orderRevenue;
          product['totalOrders'] = (product['totalOrders'] ?? 0) + 1;

          types[index]['product'] = product;

          await categoryRef.update({'types': types});
          showToast("Order stats updated successfully!");
        } else {
          log("Error: ArtType not found!");
        }
      } else {
        log("Error: Category not found!");
      }
    } catch (e) {
      log("Error updating order stats: $e");
      showToast("Try again later $e");
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

  static Future<void> updateTitleAndDescription(String categoryId,
      String artTypeId, String newTitle, String newDescription) async {
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
          types[index]['product']['title'] = newTitle;
          types[index]['product']['description'] = newDescription;

          await categoryRef.update({'types': types});
          showToast("Title & Description updated successfully!");
          log("Title & Description updated successfully!");
        } else {
          log("Error: ArtType not found!");
        }
      } else {
        log("Error: Category not found!");
      }
    } catch (e) {
      log("Error updating title & description: $e");
    }
  }

  static Future<void> updateSizeField(
      String categoryId,
      String artTypeId,
      String drawingTypeName,
      double length,
      double width,
      Map<String, dynamic> updatedFields) async {
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

        int typeIndex = types.indexWhere((type) => type['id'] == artTypeId);
        if (typeIndex != -1) {
          List<dynamic> drawingTypes =
              types[typeIndex]['product']['drawingTypes'] ?? [];

          int drawingTypeIndex =
              drawingTypes.indexWhere((dt) => dt['type'] == drawingTypeName);
          if (drawingTypeIndex != -1) {
            List<dynamic> sizes = drawingTypes[drawingTypeIndex]['sizes'] ?? [];

            int sizeIndex = sizes.indexWhere(
                (size) => size['length'] == length && size['width'] == width);
            if (sizeIndex != -1) {
              sizes[sizeIndex].addAll(updatedFields);

              await categoryRef.update({'types': types});
              showToast("Size updated successfully!");
              log("Size updated successfully!");
            } else {
              log("Error: Size not found!");
            }
          } else {
            log("Error: DrawingType not found!");
          }
        } else {
          log("Error: ArtType not found!");
        }
      } else {
        log("Error: Category not found!");
      }
    } catch (e) {
      log("Error updating size: $e");
    }
  }

  static Future<void> addSizeToDrawingType(String categoryId, String artTypeId,
      String drawingTypeName, ProductSizeModel newSize) async {
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

        int typeIndex = types.indexWhere((type) => type['id'] == artTypeId);
        if (typeIndex != -1) {
          List<dynamic> drawingTypes =
              types[typeIndex]['product']['drawingTypes'] ?? [];

          int drawingIndex = drawingTypes
              .indexWhere((drawing) => drawing['type'] == drawingTypeName);

          if (drawingIndex != -1) {
            Map<String, dynamic> newSizeJson = newSize.toJson();

            drawingTypes[drawingIndex]['sizes'].add(newSizeJson);

            await categoryRef.update({'types': types});

            showToast("Size added successfully!");
            log("Size added successfully!");
          } else {
            log("Error: Drawing Type not found!");
          }
        } else {
          log("Error: Art Type not found!");
        }
      } else {
        log("Error: Category not found!");
      }
    } catch (e) {
      log("Error adding size: $e");
    }
  }

  static Future<void> deleteSizeFromDrawingType(String categoryId,
      String artTypeId, String drawingTypeName, int sizeIndex) async {
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

        int typeIndex = types.indexWhere((type) => type['id'] == artTypeId);
        if (typeIndex != -1) {
          List<dynamic> drawingTypes =
              types[typeIndex]['product']['drawingTypes'] ?? [];

          int drawingIndex = drawingTypes
              .indexWhere((drawing) => drawing['type'] == drawingTypeName);

          if (drawingIndex != -1) {
            List<dynamic> sizes = drawingTypes[drawingIndex]['sizes'];

            if (sizes.length == 1 && drawingTypes.length == 1) {
              // Prevent deleting the last size if it's the only drawing type
              showToast(
                  "At least one drawing type with a size must be present!");
              log("Error: Cannot delete the last size of the only drawing type!");
              return;
            } else if (sizes.length == 1) {
              // If it's the last size of the drawing type, remove the drawing type itself
              drawingTypes.removeAt(drawingIndex);
            } else {
              // Remove only the selected size
              sizes.removeAt(sizeIndex);
            }

            // Update Firestore with the modified list
            await categoryRef.update({'types': types});

            showToast("Size deleted successfully!");
            log("Size deleted successfully!");
          } else {
            log("Error: Drawing Type not found!");
          }
        } else {
          log("Error: Art Type not found!");
        }
      } else {
        log("Error: Category not found!");
      }
    } catch (e) {
      log("Error deleting size: $e");
    }
  }

  static Future<void> addNewDrawingType(String categoryId, String artTypeId,
      DrawingTypeModel drawingTypeModel) async {
    try {
      if (drawingTypeModel.sizes!.isEmpty) {
        showToast("Please add at least one valid size!");
        log("Error: No sizes provided!");
        return;
      }

      String userId = AuthApi.currentAdmin!.uid;
      final categoryRef = FirebaseFirestore.instance
          .collection('admins')
          .doc(userId)
          .collection('categories')
          .doc(categoryId);

      final categorySnapshot = await categoryRef.get();

      if (categorySnapshot.exists) {
        List<dynamic> types = categorySnapshot.data()?['types'] ?? [];

        int typeIndex = types.indexWhere((type) => type['id'] == artTypeId);
        if (typeIndex != -1) {
          List<dynamic> drawingTypes =
              types[typeIndex]['product']['drawingTypes'] ?? [];

          int existingIndex = drawingTypes
              .indexWhere((dt) => dt['type'] == drawingTypeModel.type);
          if (existingIndex != -1) {
            showToast("This drawing type already exists!");
            log("Error: Drawing type '${drawingTypeModel.type}' already exists!");
            return;
          }

          drawingTypes.add(drawingTypeModel.toJson());

          await categoryRef.update({'types': types});

          showToast("Drawing type added successfully!");
          log("Drawing type '${drawingTypeModel.type}' added successfully!");
        } else {
          log("Error: Art Type not found!");
        }
      } else {
        log("Error: Category not found!");
      }
    } catch (e) {
      log("Error adding drawing type: $e");
    }
  }

  static Future<void> deleteDrawingType(
      String categoryId, String artTypeId, String drawingType) async {
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
          List<dynamic> drawingTypes =
              types[index]['product']['drawingTypes'] ?? [];

          if (drawingTypes.length <= 1) {
            showToast("At least one drawing type is required!");
            return;
          }

          drawingTypes.removeWhere((type) => type['type'] == drawingType);
          types[index]['product']['drawingTypes'] = drawingTypes;

          await categoryRef.update({'types': types});
          showToast("Drawing Type deleted successfully!");
          log("Drawing Type deleted successfully!");
        } else {
          log("Error: ArtType not found!");
        }
      } else {
        log("Error: Category not found!");
      }
    } catch (e) {
      log("Error deleting drawing type: $e");
    }
  }

  static Future<void> deleteTypeFromCategory(
    String categoryId,
    String typeId,
  ) async {
    try {
      String userId = AuthApi.currentAdmin!.uid;

      final categoryRef = FirebaseFirestore.instance
          .collection('admins')
          .doc(userId)
          .collection('categories')
          .doc(categoryId);

      final categorySnapshot = await categoryRef.get();

      if (!categorySnapshot.exists) {
        log("Error: Category not found!");
        return;
      }

      List<dynamic> types = categorySnapshot.data()?['types'] ?? [];

      if (types.isEmpty) {
        log("Error: No types found in this category!");
        return;
      }

      types.removeWhere((type) => type['id'] == typeId);

      if (types.isEmpty) {
        await categoryRef.delete();
        showToast("Category deleted as it had only one type!");
        log("Category deleted as it had only one type!");
      } else {
        await categoryRef.update({'types': types});
        showToast("Type deleted successfully!");
        log("Type deleted successfully!");
      }
    } catch (e) {
      log("Error deleting type: $e");
    }
  }
}
