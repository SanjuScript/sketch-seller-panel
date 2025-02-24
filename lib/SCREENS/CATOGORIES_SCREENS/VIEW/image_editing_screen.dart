import 'dart:io';

import 'package:drawer_panel/MODEL/DATA/art_type_model.dart';
import 'package:drawer_panel/PROVIDER/EDITING/edit_images_provider.dart';
import 'package:drawer_panel/WIDGETS/DIALOGS/EDITING/delete_image_dialogue.dart';
import 'package:drawer_panel/WIDGETS/custom_cached_image_displayer.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ImageEditingScreen extends StatefulWidget {
  final ArtTypeModel artTypeModel;
  const ImageEditingScreen({super.key, required this.artTypeModel});

  @override
  State<ImageEditingScreen> createState() => _ImageEditingScreenState();
}

class _ImageEditingScreenState extends State<ImageEditingScreen> {
  @override
  void initState() {
    super.initState();
    _setData();
  }

  void _setData() {
    Future.microtask(() {
      Provider.of<ImageSelectionProvider>(context, listen: false)
          .fetchImages(widget.artTypeModel.catName!, widget.artTypeModel.id);
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ImageSelectionProvider>(context);
    final size = MediaQuery.sizeOf(context);
    return Scaffold(
      appBar: AppBar(title: const Text("Image Editor")),
      body: Column(
        children: [
          if (provider.selectedImages.isNotEmpty)
            SizedBox(
              height: 100,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.all(8),
                itemCount: provider.selectedImages.length,
                itemBuilder: (context, index) {
                  return Stack(
                    children: [
                      Container(
                        margin: const EdgeInsets.all(5),
                        width: size.width * .25,
                        height: size.height * .25,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          image: DecorationImage(
                            image: FileImage(
                                File(provider.selectedImages[index].path)),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      Positioned(
                        top: 4,
                        right: 4,
                        child: GestureDetector(
                          onTap: () => provider.removeSelectedImage(index),
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.6),
                              shape: BoxShape.circle,
                            ),
                            padding: const EdgeInsets.all(4),
                            child: const Icon(Icons.close,
                                color: Colors.white, size: 18),
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          if (provider.selectedImages.isNotEmpty)
            SizedBox(
              width: size.width * .90,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25)),
                ),
                onPressed: () async {
                  await provider
                      .uploadImages(
                          widget.artTypeModel.catName!, widget.artTypeModel.id)
                      .then((_) {
                    _setData();
                  });
                },
                child: Text(
                    provider.isUploading ? "Uploading...." : "Upload Images"),
              ),
            ),
          Expanded(
            child: provider.isLoading
                ? const Center(child: CircularProgressIndicator())
                : provider.fetchedImages.isEmpty
                    ? const Center(child: Text("No images available."))
                    : GridView.builder(
                        padding: const EdgeInsets.all(10),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 10,
                          childAspectRatio: 1,
                        ),
                        itemCount: provider.fetchedImages.length,
                        itemBuilder: (context, index) {
                          var imageUrl = provider.fetchedImages[index];

                          return ClipRRect(
                            borderRadius: BorderRadius.circular(15),
                            child: Stack(
                              fit: StackFit.expand,
                              children: [
                                CustomCachedImageDisplayer(imageUrl: imageUrl),
                                Positioned(
                                  top: 8,
                                  right: 8,
                                  child: InkWell(
                                    onTap: () {
                                      showDeleteImageDialog(
                                          context: context,
                                          onConfirmDelete: () async {
                                            provider.removeFetchedImage(index);
                                            provider.deleteImage(
                                                categoryName: widget
                                                    .artTypeModel.catName!,
                                                artTypeId:
                                                    widget.artTypeModel.id,
                                                imageUrl: imageUrl);
                                          });
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: Colors.black.withOpacity(0.5),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: const Padding(
                                        padding: EdgeInsets.all(5),
                                        child: Icon(Icons.delete,
                                            color: Colors.white, size: 20),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: provider.pickImages,
        backgroundColor: Colors.blue,
        child: const Icon(Icons.add_a_photo, color: Colors.white),
      ),
    );
  }
}
