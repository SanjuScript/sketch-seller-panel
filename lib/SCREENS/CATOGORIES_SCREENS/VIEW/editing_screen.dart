import 'dart:developer';
import 'package:drawer_panel/FUNCTIONS/DATA_RETRIEVE_FN/get_catogories.dart';
import 'package:drawer_panel/FUNCTIONS/EDIT_PRODUCT_FN/edit_product.dart';
import 'package:drawer_panel/HELPERS/CONSTANTS/show_toast.dart';
import 'package:drawer_panel/MODEL/DATA/art_type_model.dart';
import 'package:drawer_panel/MODEL/DATA/drawing_type_model.dart';
import 'package:drawer_panel/ROUTER/page_routers.dart';
import 'package:drawer_panel/SCREENS/CATOGORIES_SCREENS/VIEW/image_editing_screen.dart';
import 'package:drawer_panel/WIDGETS/BUTTONS/custom_switches.dart';
import 'package:drawer_panel/WIDGETS/DIALOGS/EDITING/add_new_drawing_types.dart';
import 'package:drawer_panel/WIDGETS/DIALOGS/EDITING/delete_doc.dart';
import 'package:drawer_panel/WIDGETS/DIALOGS/EDITING/size_dialogues.dart';
import 'package:drawer_panel/WIDGETS/DIALOGS/global_dialogue.dart';
import 'package:drawer_panel/WIDGETS/UPLOAD_PAGE/text_fields.dart';
import 'package:flutter/material.dart';

class ProductEditingScreen extends StatefulWidget {
  final ArtTypeModel artTypeModel;
  const ProductEditingScreen({super.key, required this.artTypeModel});

  @override
  State<ProductEditingScreen> createState() => _ProductEditingScreenState();
}

class _ProductEditingScreenState extends State<ProductEditingScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  Future<ArtTypeModel?>? _future;

  @override
  void initState() {
    super.initState();
    _setFuture();
  }

  void _setFuture() {
    _future = GetCatogoriesFN.getArtTypeByName(
        widget.artTypeModel.catName!, widget.artTypeModel.id);
  }

  @override
  Widget build(BuildContext context) {
    log("REBUILDED", name: "UI");
    Size size = MediaQuery.sizeOf(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Product'),
        actions: [
          IconButton(
              onPressed: () {
                showCautionDeleteDialog(
                  context,
                  () {
                    EditProduct.deleteTypeFromCategory(
                            widget.artTypeModel.catName!,
                            widget.artTypeModel.id)
                        .then((_) {
                      AppRouter.router.go('/');
                    });
                  },
                );
              },
              icon: const Icon(Icons.delete))
        ],
      ),
      body: FutureBuilder<ArtTypeModel?>(
        future: _future,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text(snapshot.error.toString()));
          }
          if (!snapshot.hasData) {
            return const Center(child: Text("No DATA"));
          }

          final eData = snapshot.data;
          if (eData == null) return const SizedBox();
          bool isHided = !eData.product.isAvailable!;
          bool inOffer = eData.product.inOffer!;
          nameController.text = eData.product.title!;
          descriptionController.text = eData.product.description!;

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8.0, vertical: 5),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CustomSwitch(
                            value: isHided,
                            onChanged: (value) {
                              setState(() {
                                isHided = value;
                              });

                              EditProduct.updateAvailability(
                                widget.artTypeModel.catName!,
                                widget.artTypeModel.id,
                                !isHided,
                              ).then((_) {
                                setState(() => _setFuture());
                              });
                            },
                            label: "Hide"),
                        CustomSwitch(
                            value: inOffer,
                            onChanged: (value) {
                              setState(() {
                                inOffer = value;
                              });
                              EditProduct.updateOffer(
                                widget.artTypeModel.catName!,
                                widget.artTypeModel.id,
                                inOffer,
                              ).then((_) {
                                setState(() => _setFuture());
                              });
                            },
                            label: "Offer"),
                      ],
                    ),
                  ),
                  SizedBox(
                    width: size.width * .90,
                    child: ElevatedButton.icon(
                      icon:const Icon(Icons.edit),
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25)),
                      ),
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ImageEditingScreen(
                                  artTypeModel: eData,
                                )));
                      },
                      label: const Text("Edit Images"),
                    ),
                  ),
                  const SizedBox(height: 10),
                  CustomTextFields(
                    label: "Product name",
                    controller: nameController,
                    hint: "Product name",
                    icon: Icons.title,
                  ),
                  const SizedBox(height: 10),
                  CustomTextFields(
                    isDescription: true,
                    keyboardType: TextInputType.multiline,
                    label: "Description",
                    controller: descriptionController,
                    hint: "Description",
                    icon: Icons.title,
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    width: size.width * .90,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25)),
                      ),
                      onPressed: () {
                        EditProduct.updateTitleAndDescription(
                          widget.artTypeModel.catName!,
                          widget.artTypeModel.id,
                          nameController.text,
                          descriptionController.text,
                        ).then((_) {
                          setState(() => _setFuture());
                        });
                      },
                      child: const Text("Save Changes"),
                    ),
                  ),
                  SizedBox(
                    width: size.width * .90,
                    child: ElevatedButton.icon(
                      icon: const Icon(Icons.add),
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25)),
                      ),
                      onPressed: () {
                        _showAddDrawingTypeDialog();
                      },
                      label: const Text("Add new drawing type"),
                    ),
                  ),
                  const SizedBox(height: 10),
                  ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: widget.artTypeModel.product.drawingTypes!.length,
                    itemBuilder: (context, index) {
                      final drawingType =
                          widget.artTypeModel.product.drawingTypes![index];
                      return Container(
                        margin: const EdgeInsets.symmetric(
                            vertical: 8, horizontal: 5),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.deepPurple.withOpacity(0.1),
                              blurRadius: 5,
                              spreadRadius: 1,
                              offset: const Offset(2, -3),
                            ),
                            BoxShadow(
                              color: Colors.deepPurple.withOpacity(0.1),
                              blurRadius: 5,
                              spreadRadius: 1,
                              offset: const Offset(-3, 2),
                            ),
                          ],
                        ),
                        child: ExpansionTile(
                          collapsedShape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
                          collapsedBackgroundColor: Colors.transparent,
                          backgroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          title: Text(
                            drawingType.type ?? "Unknown Type",
                            style: const TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          children: [
                            ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: drawingType.sizes?.length ?? 0,
                              itemBuilder: (context, sizeIndex) {
                                final size = drawingType.sizes![sizeIndex];
                                return ListTile(
                                  isThreeLine: true,
                                  title: Text(
                                      "Size: ${size.length} x ${size.width}"),
                                  subtitle: Text(
                                      "Price: ₹${size.price} \n${"Offer Price: ₹${size.offerPrice ?? ""}"}"),
                                  trailing: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      IconButton(
                                        icon: const Icon(Icons.edit,
                                            color: Colors.blue),
                                        onPressed: () =>
                                            _editSize(drawingType, sizeIndex),
                                      ),
                                      IconButton(
                                          icon: const Icon(Icons.delete,
                                              color: Colors.red),
                                          onPressed: () {
                                            showConfirmationDialog(
                                                context: context,
                                                title: "Delete Size",
                                                message:
                                                    "Are you sure you want to delete this size? This action cannot be undone.",
                                                confirmText: "Delete",
                                                cancelText: "Cancel",
                                                onConfirm: () {
                                                  _deleteSize(
                                                      drawingType, sizeIndex);
                                                });
                                          }),
                                    ],
                                  ),
                                );
                              },
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 4),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  ElevatedButton.icon(
                                    onPressed: () => _addSize(drawingType),
                                    icon: const Icon(Icons.add),
                                    label: const Text("Add Size"),
                                  ),
                                  TextButton.icon(
                                    onPressed: () {
                                      showConfirmationDialog(
                                          context: context,
                                          title: "Delete Drawing Type?",
                                          message:
                                              "Are you sure you want to delete '${drawingType.type}'? This action cannot be undone.",
                                          confirmText: "Delete",
                                          cancelText: "Cancel",
                                          onConfirm: () {
                                            _deleteDrawingType(
                                                drawingType.type!, index);
                                          });
                                    },
                                    icon: const Icon(Icons.delete,
                                        color: Colors.red),
                                    label: const Text("Delete Type"),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 10),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    nameController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  void _showAddDrawingTypeDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AddDrawingTypeDialog(
          onDrawingTypeAdded: (drawingType) {
            bool exists = widget.artTypeModel.product.drawingTypes!
                .any((type) => type.type == drawingType.type);
            if (!exists) {
              setState(() {
                widget.artTypeModel.product.drawingTypes!.add(drawingType);
              });
            }
            EditProduct.addNewDrawingType(
              widget.artTypeModel.catName!,
              widget.artTypeModel.id,
              drawingType,
            );
          },
        );
      },
    );
  }

  void _deleteDrawingType(String drawingType, int index) {
    if (widget.artTypeModel.product.drawingTypes!.length <= 1) {
      showToast("At least one drawing type is required!");
      return;
    }
    EditProduct.deleteDrawingType(
        widget.artTypeModel.catName!, widget.artTypeModel.id, drawingType);
    setState(() {
      widget.artTypeModel.product.drawingTypes!
          .removeWhere((typee) => typee.type == drawingType);
    });
  }

  void _addSize(DrawingTypeModel drawingType) {
    SizeDialogs.showAddSizeDialog(
      context,
      drawingType,
      (size) {
        EditProduct.addSizeToDrawingType(
          widget.artTypeModel.catName!,
          widget.artTypeModel.id,
          drawingType.type!,
          size,
        ).then((_) {
          setState(() {
            drawingType.sizes!.add(size);
          });
        });
      },
    );
  }

  void _deleteSize(DrawingTypeModel drawingType, int index) {
    EditProduct.deleteSizeFromDrawingType(widget.artTypeModel.catName!,
        widget.artTypeModel.id, drawingType.type!, index);
    if (widget.artTypeModel.product.drawingTypes!.length > 1) {
      setState(() {
        drawingType.sizes!.removeAt(index);
      });
    }
  }

  void _editSize(DrawingTypeModel drawingType, int index) {
    final size = drawingType.sizes![index];
    SizeDialogs.showEditSizeDialog(
      context,
      drawingType,
      index,
      (newSize) {
        EditProduct.updateSizeField(
          widget.artTypeModel.catName!,
          widget.artTypeModel.id,
          drawingType.type!,
          size.length,
          size.width,
          newSize.toJson(),
        ).then((_) {
          setState(() {
            drawingType.sizes![index] = drawingType.sizes![index].copyWith(
                length: newSize.length,
                width: newSize.width,
                offerPrice: newSize.offerPrice,
                price: newSize.price);
          });
        });
      },
    );
  }
}
