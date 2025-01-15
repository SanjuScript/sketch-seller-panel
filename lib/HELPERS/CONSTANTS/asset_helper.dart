import 'package:flutter/material.dart';

class GetAsset {
  static const svgs = _GetSvgs();
  static const lottie = _GetLotties(); // Static instance
  static const google = "assets/images/google.png";
  static const wb1 = "assets/images/wb1.jpeg";
  static const wb2 = "assets/images/wb2.jpeg";
  static const wb3 = "assets/images/wb3.jpeg";
  static const wb6 = "assets/images/wb6.jpeg";
  static const gl1 = "assets/images/gl1.jpeg";
  static const dr1 = "assets/images/dr1.jpeg";

  static const List<String> allWbAssets = [];


  //lottie
  static const loader = "assets/lotties/loading.json";
  static const uploading = "assets/lotties/uploading.json";
}

class _GetSvgs {
  const _GetSvgs();

  // Non-static fields for SVGs
  // final String google = "assets/icons/google.svg";
}

class _GetLotties {
  const _GetLotties();

  // Now `loader` is static
  static const loader = "assets/lottie/loading.json";
}
class MyWidget extends StatelessWidget {
  const MyWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}