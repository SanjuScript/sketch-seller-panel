import 'package:flutter/material.dart';

class DownloadButton extends StatelessWidget {
  final void Function()? onPressed;
  const DownloadButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.sizeOf(context);
    return SizedBox(
      width: size.width * .90,
      child: ElevatedButton.icon(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 20.0),
          backgroundColor: const Color(0xFF02AAB0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          elevation: 4,
        ),
        icon: const Icon(Icons.download_rounded, color: Colors.white),
        label: const Text(
          "Download Image",
          style: TextStyle(fontSize: 16, color: Colors.white),
        ),
      ),
    );
  }
}
