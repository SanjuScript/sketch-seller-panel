import 'dart:developer';
import 'package:drawer_panel/API/permission_api.dart';
import 'package:drawer_panel/HELPERS/HANDLERS/catagory_helper.dart';
import 'package:drawer_panel/HELPERS/HANDLERS/haptic_handler.dart';
import 'package:drawer_panel/HELPERS/HANDLERS/snack_bar_helper.dart';
import 'package:drawer_panel/PROVIDER/product_uploader_provider.dart';
import 'package:drawer_panel/WIDGETS/BUTTONS/custom_button.dart';
import 'package:drawer_panel/WIDGETS/UPLOAD_PAGE/custom_drop_menu.dart';
import 'package:drawer_panel/WIDGETS/UPLOAD_PAGE/text_fields.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CatogoryUploader extends StatefulWidget {
  const CatogoryUploader({super.key});

  @override
  State<CatogoryUploader> createState() => _CatogoryUploaderState();
}

class _CatogoryUploaderState extends State<CatogoryUploader> {
  final _formKey = GlobalKey<FormState>();
  final drawingTypeOptions = ['Single', 'Double', 'Triple', 'Family'];
  @override
  Widget build(BuildContext context) {
    log('Rebuilded');
    return Scaffold(
      appBar: AppBar(
        title: const Text('Upload Product'),
        leading: const Icon(Icons.upload),
      ),
      body: Consumer<ProductUploaderProvider>(
          builder: (context, provider, child) {
        return Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.all(16.0),
            children: [
              CustomDropdown<String>(
                label: 'Category',
                items: CatagoryHelper.categories,
                selectedValue: provider.selectedCategory,
                onChanged: provider.setCategory,
                validator: (value) =>
                    value == null ? 'Please select a category' : null,
              ),
              const SizedBox(height: 20),
              if (provider.selectedCategory != null)
                CatagoryHelper.types[provider.selectedCategory!]!.isNotEmpty
                    ? CustomDropdown<String>(
                        label: 'Type',
                        items: CatagoryHelper.types[provider.selectedCategory]!,
                        selectedValue: provider.selectedType,
                        onChanged: (value) =>
                            setState(() => provider.selectedType = value),
                        validator: (value) =>
                            value == null ? 'Please select a type' : null,
                      )
                    : const Text(
                        "No types available for this category.",
                        style: TextStyle(color: Colors.grey, fontSize: 16),
                      ),
              const SizedBox(
                height: 15,
              ),
              CustomTextFields(
                label: "Product title",
                controller: provider.productTitleController,
                hint: "Enter title of product*",
                icon: Icons.title_rounded,
                validator: (value) =>
                    value!.isEmpty ? 'Please enter a product title' : null,
              ),
              const SizedBox(height: 16),
              CustomTextFields(
                label: "Product description",
                controller: provider.descriptionController,
                hint: "Enter description of product*",
                keyboardType: TextInputType.multiline,
                isDescription: true,
                icon: Icons.description,
                validator: (value) =>
                    value!.isEmpty ? 'Please enter a descrition' : null,
              ),
              const SizedBox(height: 16),
              ...provider.drawingTypes.asMap().entries.map((entry) {
                final index = entry.key;
                final drawingType = entry.value;
                log('Drawing type options: $drawingTypeOptions');
                log('Selected drawing type: ${drawingType.type}');

                return Container(
                  key: ValueKey(drawingType),
                  margin: const EdgeInsets.symmetric(vertical: 5),
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.black, width: 2),
                      borderRadius: BorderRadius.circular(15)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Drawing type ${index + 1}",
                        style: Theme.of(context)
                            .textTheme
                            .labelSmall
                            ?.copyWith(fontSize: 12),
                      ),
                      const SizedBox(height: 5),
                      CustomDropdown<String>(
                        label: 'Drawing Type',
                        items: drawingTypeOptions,
                        selectedValue:
                            drawingTypeOptions.contains(drawingType.type)
                                ? drawingType.type
                                : null,
                        onChanged: (value) {
                          if (value != null) {
                            setState(() {
                              drawingType.type = value;
                            });
                            provider.notifyListeners();
                          }
                        },
                        validator: (value) => value == null
                            ? 'Please select a drawing type'
                            : null,
                      ),
                      const SizedBox(height: 10),
                      ...drawingType.sizes!.asMap().entries.map((sizeEntry) {
                        final sizeIndex = sizeEntry.key;
                        final size = sizeEntry.value;
                        return Column(
                          key: ValueKey("${drawingType.type}-$sizeIndex"),
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 5),
                            Text("Size ${sizeIndex + 1}"),
                            const SizedBox(height: 5),
                            TextFormField(
                              keyboardType: TextInputType.number,
                              initialValue: size.length.toString(),
                              decoration:
                                  const InputDecoration(labelText: 'Length'),
                              onChanged: (value) {
                                provider.updateSize(
                                  index,
                                  sizeIndex,
                                  size.copyWith(
                                    length: double.tryParse(value) ?? 0.0,
                                  ),
                                );
                              },
                            ),
                            TextFormField(
                              initialValue: size.width.toString(),
                              keyboardType: TextInputType.number,
                              decoration:
                                  const InputDecoration(labelText: 'Width'),
                              onChanged: (value) {
                                provider.updateSize(
                                  index,
                                  sizeIndex,
                                  size.copyWith(
                                    width: double.tryParse(value) ?? 0.0,
                                  ),
                                );
                              },
                            ),
                            TextFormField(
                              initialValue: size.price.toString(),
                              keyboardType: TextInputType.number,
                              decoration:
                                  const InputDecoration(labelText: 'Price'),
                              onChanged: (value) {
                                provider.updateSize(
                                  index,
                                  sizeIndex,
                                  size.copyWith(
                                    price: double.tryParse(value) ?? 0.0,
                                  ),
                                );
                              },
                            ),
                            TextFormField(
                              initialValue: size.offerPrice.toString(),
                              keyboardType: TextInputType.number,
                              decoration: const InputDecoration(
                                  labelText: 'Offer Price'),
                              onChanged: (value) {
                                provider.updateSize(
                                  index,
                                  sizeIndex,
                                  size.copyWith(
                                    offerPrice: double.tryParse(value) ?? 0.0,
                                  ),
                                );
                              },
                            ),
                            const SizedBox(height: 10),
                            CustomButton(
                              text: 'Remove Size',
                              onPressed: () =>
                                  provider.removeSize(index, sizeIndex),
                              gradientColors: const [
                                Colors.orange,
                                Colors.deepOrange
                              ],
                            ),
                          ],
                        );
                      }),
                      const SizedBox(height: 10),
                      FittedBox(
                        child: Row(
                          children: [
                            CustomButton(
                              text: 'Add Size',
                              onPressed: () => provider.addSize(index),
                              gradientColors: const [
                                Colors.blue,
                                Colors.lightBlueAccent
                              ],
                            ),
                            // if (provider.hasValidSizes())
                            //   CustomButton(
                            //     text: 'Copy recent ',
                            //     onPressed: () {
                            //       if (provider.drawingTypes.length > 1) {
                            //         provider.copySizes(index );
                            //       }
                            //     },
                            //     gradientColors: const [
                            //       Colors.blue,
                            //       Colors.lightBlueAccent
                            //     ],
                            //   ),
                            const SizedBox(width: 10),
                            CustomButton(
                              text: 'Remove Drawing Type',
                              onPressed: () =>
                                  provider.removeDrawingType(index),
                              gradientColors: const [
                                Colors.red,
                                Colors.orangeAccent
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 10),
                    ],
                  ),
                );
              }),
              const SizedBox(
                height: 10,
              ),
              ElevatedButton(
                onPressed: provider.addDrawingType,
                child: const Text('Add Drawing Type'),
              ),
              const SizedBox(height: 10),
              if (provider.imageFiles.isNotEmpty)
                Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: (provider.imageFiles).map((image) {
                    return Stack(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.file(
                            image,
                            width: 100,
                            height: 100,
                            fit: BoxFit.cover,
                          ),
                        ),
                        Positioned(
                          top: 0,
                          right: 0,
                          child: IconButton(
                            icon: const Icon(Icons.close, color: Colors.red),
                            onPressed: () {
                              provider.removeImage(image);
                            },
                          ),
                        ),
                      ],
                    );
                  }).toList(),
                ),
              const SizedBox(height: 10),
              ElevatedButton.icon(
                icon: const Icon(Icons.image),
                label: const Text('Pick Images'),
                onPressed: () async {
                  await PermissionApi.requestStorageOrPhotosPermission(context)
                      .then((onValue) async {
                    if (onValue) {
                      if (provider.imageFiles.length < 10 &&
                          provider.imageFiles.isEmpty) {
                        await provider.pickMultipleImages();
                      } else {
                        SnackbarHandler.instance.showSnackbar(
                            context: context,
                            message: "You can only add up to 10 images.");
                      }
                    }
                  });
                },
              ),
              const SizedBox(height: 10),
              CustomButton(
                showLeading: true,
                isuploading: provider.isUploading,
                icon: Icons.upload,
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    final validationMSG = provider.validateForm();

                    if (validationMSG != null) {
                      HapticHandler.instance.errorImpact();
                      SnackbarHandler.instance.showSnackbar(
                        context: context,
                        message: validationMSG,
                      );
                      return;
                    }

                    if (provider.imageFiles.isNotEmpty) {
                      if (provider.drawingTypes.isNotEmpty) {
                        provider.writeData(context);
                      } else {
                        HapticHandler.instance.errorImpact();
                        SnackbarHandler.instance.showSnackbar(
                            context: context,
                            message: "Please specify your drawing type");
                      }
                    } else {
                      HapticHandler.instance.errorImpact();
                      SnackbarHandler.instance.showSnackbar(
                          context: context,
                          message: "Please select minimum 1 image");
                    }
                  } else {
                    HapticHandler.instance.errorImpact();
                    SnackbarHandler.instance.showSnackbar(
                        context: context,
                        message: "Please fill the required fields");
                  }
                },
                text: 'Upload Product',
                gradientColors: const [
                  Colors.lightBlueAccent,
                  Colors.teal,
                ],
              ),
            ],
          ),
        );
      }),
    );
  }
}
