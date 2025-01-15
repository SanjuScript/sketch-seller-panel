import 'dart:developer';
import 'dart:io';
import 'package:drawer_panel/FUNCTIONS/UPLOAD_FN/product_upload_fn.dart';
import 'package:drawer_panel/HELPERS/HANDLERS/snack_bar_helper.dart';
import 'package:drawer_panel/MODEL/DATA/drawing_type_model.dart';
import 'package:drawer_panel/MODEL/DATA/product_size_model.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

class ProductUploaderProvider with ChangeNotifier {
  String? selectedCategory;
  String? selectedType;
  List<File> imageFiles = [];
  List<DrawingTypeModel> drawingTypes = [];
  bool isUploading = false;

  final TextEditingController productTitleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  void setCategory(String? category) {
    selectedCategory = category;
    selectedType = null;
    notifyListeners();
  }

  void setType(String? type) {
    selectedType = type;
    notifyListeners();
  }

  void removeImage(File file) {
    imageFiles.remove(file);
    notifyListeners();
  }

  void removeAllImages() {
    imageFiles.clear();
    notifyListeners();
  }

  Future<void> pickMultipleImages() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.media,
        allowMultiple: true,
      );

      if (result != null && result.files.isNotEmpty) {
        final newFiles = result.files.map((file) => File(file.path!)).toList();
        final totalFiles = imageFiles.length + newFiles.length;

        if (totalFiles > 10) {
          final allowedFilesCount = 10 - imageFiles.length;
          if (allowedFilesCount > 0) {
            imageFiles.addAll(newFiles.take(allowedFilesCount));
          }
        } else {
          imageFiles.addAll(newFiles);
        }

        notifyListeners();
      }
    } catch (e) {
      log("Error picking images: $e");
    }
  }

  void copySizes(int toIndex) {
    if (drawingTypes.isNotEmpty && drawingTypes[0].sizes != null) {
      drawingTypes[toIndex].sizes = List.from(drawingTypes[0].sizes!);
      notifyListeners();
    }
  }

  bool hasValidSizes() {
    if (drawingTypes.isNotEmpty && drawingTypes[0].sizes != null) {
      var sizes = drawingTypes[0].sizes!;
      for (var size in sizes) {
        if (size.width == null ||
            size.length == null ||
            size.price == null ||
            size.width == 0 ||
            size.length == 0 ||
            size.price == 0) {
          return false;
        }
      }

      return true;
    }
    return false;
  }

  String? validateForm() {
    if (drawingTypes.isEmpty) {
      return 'Please add at least one drawing type.';
    }

    for (var drawingType in drawingTypes) {
      if (drawingType.type!.isEmpty) {
        return 'Please specify the drawing type.';
      }

      if (drawingType.sizes == null || drawingType.sizes!.isEmpty) {
        return 'Each drawing type must have at least one size.';
      }

      for (var size in drawingType.sizes!) {
        if (size.length == 0.0 || size.width == 0.0 || size.price == 0.0) {
          return 'Please provide valid size details (length, width, and price).';
        }
      }
    }

    return null;
  }

  Future<void> writeData(BuildContext context) async {
    try {
      isUploading = true;
      notifyListeners();

      ProductUploader productUploader = ProductUploader();

      await productUploader.uploadProduct(
        this,
        drawingTypes,
        selectedType ?? '',
        selectedCategory ?? '',
        imageFiles,
      );

      isUploading = false;
      notifyListeners();
      Future.delayed(Durations.extralong1, () {
        Navigator.pop(context);
        clearAllFields();
      });
       SnackbarHandler.instance.showSnackbar(
        context: context,
        message: "Product upload successful!",
      );
    } catch (e) {
      isUploading = false;
      notifyListeners();

      log("Error during product upload: $e");

      SnackbarHandler.instance.showSnackbar(
        context: context,
        message: "An error occurred during the upload. Please try again.",
      );
    } finally {
      isUploading = false;
      notifyListeners();
    }
  }

  void addDrawingType() {
    drawingTypes.add(DrawingTypeModel(type: '', sizes: []));
    notifyListeners();
  }

  void removeDrawingType(int index) {
    debugPrint('Before Removing DrawingType: $drawingTypes');
    debugPrint('Removing index: $index');
    drawingTypes.removeAt(index);
    notifyListeners();
  }

  void addSize(int drawingTypeIndex) {
    drawingTypes[drawingTypeIndex].sizes!.add(ProductSizeModel(
          length: 0.0,
          width: 0.0,
          price: 0.0,
          offerPrice: 0.0,
        ));
    notifyListeners();
  }

  void removeSize(int drawingTypeIndex, int sizeIndex) {
    debugPrint('Before Removing Size: ${drawingTypes[drawingTypeIndex].sizes}');
    debugPrint('Removing size index: $sizeIndex');
    drawingTypes[drawingTypeIndex].sizes!.removeAt(sizeIndex);
    notifyListeners();
  }

  void updateSize(
      int drawingTypeIndex, int sizeIndex, ProductSizeModel newSize) {
    drawingTypes[drawingTypeIndex].sizes![sizeIndex] = newSize;
    notifyListeners();
  }

  void clearAllFields() {
    productTitleController.clear();
    descriptionController.clear();
    selectedCategory = null;
    selectedType = null;
    drawingTypes.clear();
    imageFiles.clear();
    notifyListeners();
  }

  @override
  void dispose() {
    productTitleController.dispose();
    descriptionController.dispose();
    super.dispose();
  }
}
