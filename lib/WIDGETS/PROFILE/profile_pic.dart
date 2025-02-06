import 'dart:developer';
import 'dart:io';
import 'package:drawer_panel/WIDGETS/custom_cached_image_displayer.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';

class ProfilePic extends StatelessWidget {
  final String image;
  final bool isShowPhotoUpload;
  final VoidCallback? imageUploadBtnPress;
  final CroppedFile? img;
  const ProfilePic({
    super.key,
    required this.image,
    this.isShowPhotoUpload = false,
    this.imageUploadBtnPress,
    this.img,
  });

  @override
  Widget build(BuildContext context) {
    if (img != null) {
      log(img!.path.toString());
    } else {
      log("No image selected");
    }

    return Container(
      padding: const EdgeInsets.all(16.0),
      margin: const EdgeInsets.symmetric(vertical: 16.0),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color:
              Theme.of(context).textTheme.bodyLarge!.color!.withOpacity(0.08),
        ),
      ),
      child: Stack(
        alignment: Alignment.bottomRight,
        children: [
          CircleAvatar(
            radius: 60,
            child: isShowPhotoUpload
                ? const CircularProgressIndicator()
                : img != null && img!.path.isNotEmpty
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(100),
                        child: Image.file(
                          File(img!.path),
                          fit: BoxFit.cover,
                        ))
                    : CustomCachedImageDisplayer(
                        borderRadius: BorderRadius.circular(100),
                        imageUrl: image,
                      ),
          ),
          InkWell(
            onTap: imageUploadBtnPress,
            child: CircleAvatar(
              radius: 13,
              backgroundColor: Theme.of(context).primaryColor,
              child: const Icon(
                Icons.add,
                color: Colors.white,
                size: 20,
              ),
            ),
          )
        ],
      ),
    );
  }
}
