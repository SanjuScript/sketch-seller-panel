import 'dart:developer';

import 'package:drawer_panel/EXTENSIONS/xFile_convert.dart';
import 'package:drawer_panel/FUNCTIONS/DATA_RETRIEVE_FN/get_catogories.dart';
import 'package:drawer_panel/FUNCTIONS/NOTIFICATIONS/notifications_sender.dart';
import 'package:drawer_panel/HELPERS/CONSTANTS/show_toast.dart';
import 'package:drawer_panel/SERVICES/notification_service.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ImageSelectionProvider extends ChangeNotifier {
  final ImagePicker _picker = ImagePicker();
  List<XFile> _selectedImages = [];
  List<String> _fetchedImages = [];
  bool _isLoading = false;
  bool _isUploading = false;

  List<XFile> get selectedImages => _selectedImages;
  List<String> get fetchedImages => _fetchedImages;
  bool get isLoading => _isLoading;
  bool get isUploading => _isUploading;

  int get totalImagesCount => _selectedImages.length + _fetchedImages.length;

  Future<void> fetchImages(String categoryName, String artTypeId) async {
    _isLoading = true;
    notifyListeners();

    List<String> images =
        await GetCatogoriesFN.getArtTypeImages(categoryName, artTypeId);
    _fetchedImages = images;

    _isLoading = false;
    notifyListeners();
  }

  Future<void> pickImages() async {
    if (totalImagesCount >= 6) {
      showToast("You can only upload a maximum of 6 images.");
      return;
    }
    log(totalImagesCount.toString());

    final List<XFile>? pickedFiles = await _picker.pickMultiImage();

    if (pickedFiles != null && pickedFiles.isNotEmpty) {
      int remainingSlots = 6 - totalImagesCount;
      if (pickedFiles.length > remainingSlots) {
        showToast("Only $remainingSlots more images can be added.");
        _selectedImages.addAll(pickedFiles.take(remainingSlots));
      } else {
        _selectedImages.addAll(pickedFiles);
      }
      notifyListeners();
    }
  }



  Future<bool> uploadImages(String category, String artID) async {
    _isUploading = true;
    notifyListeners();

    try {
      if (_selectedImages.isEmpty) {
        showToast("No new images to upload.");
        _isUploading = false;
        notifyListeners();
        return false;
      }
      if (_selectedImages.isNotEmpty && totalImagesCount > 6) {
        showToast("Image cant upload maximum 6 images allowed.");
        _isUploading = false;
        notifyListeners();

        return false;
      }

      bool success = await GetCatogoriesFN.uploadImages(
        categoryName: category,
        artTypeId: artID,
        imageFiles: _selectedImages.toFileList(),
      );

      if (success) {
        _selectedImages.clear();
        showToast("Images uploaded successfully.");
        NotificationService.showOrderNotification(
            title: "Image Updated",
            body: "Images Uploaded successfully",
            payload: '');
      } else {
        showToast("Failed to upload images.");
      }

      _isUploading = false;
      notifyListeners();
      return success;
    } catch (e, stackTrace) {
      log("Error uploading images: $e", name: "Upload Error");
      log("Stack Trace: $stackTrace", name: "Upload Stack Trace");

      _isUploading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> deleteImage({
    required String categoryName,
    required String artTypeId,
    required String imageUrl,
  }) async {
    bool success = await GetCatogoriesFN.deleteArtTypeImage(
      categoryName: categoryName,
      artTypeId: artTypeId,
      imageUrl: imageUrl,
    );

    if (success) {
      _fetchedImages.remove(imageUrl);
      notifyListeners();
      showToast("Image deleted successfully.");
    } else {
      showToast("Failed to delete image.");
    }

    return success;
  }

  void removeSelectedImage(int index) {
    _selectedImages.removeAt(index);
    notifyListeners();
  }

  void removeFetchedImage(int index) {
    _fetchedImages.removeAt(index);
    notifyListeners();
  }
}
