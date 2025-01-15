import 'package:drawer_panel/SERVICES/device_info_service.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter/material.dart';

class PermissionApi {
  static Future<bool> requestStorageOrPhotosPermission(
      BuildContext context) async {
    DeviceInfoService deviceInfoService = DeviceInfoService();
    int androidVersion = await deviceInfoService.getAndroidVersion();

    if (androidVersion == 0) {
      return true;
    }

    // For Android version 12 or below (API level 31 or lower)
    if (androidVersion <= 31) {
      final status = await Permission.storage.request();
      return await _handlePermissionResponse(status, context);
    }

    // For Android version 13 or above (API level 33 or higher)
    if (androidVersion >= 33) {
      final status = await Permission.photos.request();
      return await _handlePermissionResponse(status, context);
    }

    return false;
  }

  static Future<bool> _handlePermissionResponse(
      PermissionStatus status, BuildContext context) async {
    if (status.isGranted) {
      return true;
    } else if (status.isDenied) {
      final result = await _showPermissionDialog(context);
      if (result == true) {
        return await _requestAgain();
      }
    } else if (status.isPermanentlyDenied) {
      await _showSettingsDialog(context);
    }
    return false;
  }

  static Future<bool> _requestAgain() async {
    final status = await Permission.storage.request();
    return status.isGranted;
  }

  static Future<void> _showSettingsDialog(BuildContext context) async {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Permission Required'),
        content: const Text(
            'This app requires storage/photos permission to function properly. Please go to settings and grant the permission.'),
        actions: [
          TextButton(
            onPressed: () {
              openAppSettings();
              Navigator.of(context).pop();
            },
            child: const Text('Go to Settings'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }

  static Future<bool> _showPermissionDialog(BuildContext context) async {
    return await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Permission Needed'),
            content: const Text(
                'This app needs storage/photos permission to proceed. Do you want to grant it?'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(false);
                },
                child: const Text('No'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(true);
                },
                child: const Text('Yes'),
              ),
            ],
          ),
        ) ??
        false;
  }

  static Future<bool> requestLocationPermission() async {
    final status = Permission.location.request();
    return status.isGranted;
  }
}
