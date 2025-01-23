import 'package:flutter/material.dart';

class GetAsset {
  static const _GetSvgs svgs = _GetSvgs();
  static const _GetLotties lottie = _GetLotties();
  static const _GetNotifImg notifImg = _GetNotifImg();
  static const google = "assets/images/google.png";
  static const wb1 = "assets/images/wb1.jpeg";
  static const wb2 = "assets/images/wb2.jpeg";
  static const wb3 = "assets/images/wb3.jpeg";
  static const wb6 = "assets/images/wb6.jpeg";
  static const gl1 = "assets/images/gl1.jpeg";
  static const dr1 = "assets/images/dr1.jpeg";

  static const List<String> allWbAssets = [];
}

class _GetSvgs {
  const _GetSvgs();

  // Non-static fields for SVGs
  // final String google = "assets/icons/google.svg";
}

class _GetLotties {
  const _GetLotties();

  final String loader = "assets/lotties/loading.json";
  final String uploading = "assets/lotties/uploading.json";
}

class _GetNotifImg {
  const _GetNotifImg();

  final String uploadSuccess = "assets/images/NElements/upload_success.png";
  final String uploadFailed = "assets/images/NElements/upload_failed.png";
}

