import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:drawer_panel/API/permission_api.dart';
import 'package:drawer_panel/SERVICES/image_upload_service.dart';
import 'package:drawer_panel/FUNCTIONS/USER_DATA_FN/user_data_fn.dart';
import 'package:drawer_panel/HELPERS/HANDLERS/snack_bar_helper.dart';

class ProfileProvider extends ChangeNotifier {
  File? _selectedImage;
  String? _newName;
  CroppedFile? _croppedFile;

  String? get newName => _newName;
  File? get selectedImage => _selectedImage;
  CroppedFile? get croppedFile => _croppedFile;

  void setName(String? name) {
    _newName = name;
    notifyListeners();
  }

  void clearFields() {
    _newName = null;
    _selectedImage = null;
    _croppedFile = null;
    notifyListeners();
  }

  Future<void> pickImage(BuildContext context) async {
    bool permissionGranted =
        await PermissionApi.requestStorageOrPhotosPermission(context);
    if (!permissionGranted) {
      SnackbarHandler.instance.showSnackbar(
          context: context,
          message: "Permission to access storage is required");
      return;
    }

    File? imageFile = await ImageUploadService.pickImage();
    if (imageFile != null) {
      _selectedImage = imageFile;
      _croppedFile = null;
      await cropImage(imageFile);
    }
    notifyListeners();
  }

  Future<void> cropImage(File imageFile) async {
    CroppedFile? croppedFile = await ImageUploadService.cropImage(imageFile);
    if (croppedFile != null) {
      _croppedFile = croppedFile;
      notifyListeners();
    }
  }

  Future<void> saveProfile(BuildContext context) async {
    if (_newName!.isNotEmpty) {
      await UserData.updateUserName(_newName!);
    }
    if (_croppedFile != null && _croppedFile!.path.isNotEmpty) {
      await UserData.updateProfilePicture(_croppedFile!.path);
    }
    Navigator.pop(context);
    SnackbarHandler.instance.showSnackbar(
        context: context, message: "Profile updated successfully!");
  }
}
