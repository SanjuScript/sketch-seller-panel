import 'dart:developer';
import 'dart:io';
import 'package:drawer_panel/HELPERS/HANDLERS/snack_bar_helper.dart';
import 'package:drawer_panel/SERVICES/device_info_service.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as path;
import 'package:permission_handler/permission_handler.dart';

class DownloadProvider with ChangeNotifier {
  bool _isDownloading = false;
  double _progress = 0.0;

  bool get isDownloading => _isDownloading;
  double get progress => _progress;

  Future<void> downloadImage(
      String downloadUrl, String fileName, BuildContext context) async {
    try {
      _isDownloading = true;
      _progress = 0.0;
      notifyListeners();

      await _requestPermissions();

      var response = await http.get(Uri.parse(downloadUrl));

      if (response.statusCode == 200) {
        Directory picturesDirectory =
            Directory('/storage/emulated/0/Pictures/BlackArts');
        if (!picturesDirectory.existsSync()) {
          picturesDirectory.createSync(recursive: true);
        }

        String customFilename = _generateFilename(fileName, downloadUrl);
        File file = File(path.join(picturesDirectory.path, customFilename));
        log(customFilename);

        if (!file.parent.existsSync()) {
          file.parent.createSync(recursive: true);
        }

        await file.writeAsBytes(response.bodyBytes);
        log("Download completed");

        _progress = 1.0;
        notifyListeners();

        SnackbarHandler.instance.showSnackbar(
            context: context, message: "Download completed successfully!");
      } else {
        log("Failed to download file: ${response.statusCode}");
        SnackbarHandler.instance.showSnackbar(
            context: context,
            message: "Failed to download file: ${response.statusCode}");
      }
    } catch (e) {
      SnackbarHandler.instance.showSnackbar(
          context: context, message: 'Error downloading image: $e');
      log('Error downloading image: $e');
    } finally {
      _isDownloading = false;
      _progress = 0.0;
      notifyListeners();
    }
  }

  Future<void> _requestPermissions() async {
    if (Platform.isAndroid) {
      int sdkVersion = await DeviceInfoService().getAndroidVersion();

      if (sdkVersion >= 30) {
        if (!await Permission.photos.request().isGranted) {
          throw Exception("Photos permission denied.");
        }
      } else {
        if (!await Permission.storage.request().isGranted) {
          throw Exception("Storage permission denied.");
        }
      }
    }
  }

  String _generateFilename(String presetName, String downloadUrl) {
    String fileName = Uri.parse(downloadUrl).pathSegments.last;
    String extension = path.extension(fileName);
    return "$presetName$fileName$extension";
  }

  // bool checkIfDownloaded(String downloadUrl, String presetName) {
  //   Directory picturesDirectory =
  //       Directory('/storage/emulated/0/Pictures/Shoffy');
  //   String customFilename = _generateFilename(presetName, downloadUrl);
  //   File file = File(path.join(picturesDirectory.path, customFilename));
  //   return file.existsSync();
  // }
}
