import 'dart:developer';

import 'package:drawer_panel/FUNCTIONS/EDIT_PRODUCT_FN/edit_product.dart';
import 'package:drawer_panel/MODEL/DATA/art_type_model.dart';
import 'package:drawer_panel/MODEL/DATA/drawing_type_model.dart';
import 'package:drawer_panel/MODEL/DATA/product_size_model.dart';
import 'package:drawer_panel/WIDGETS/BUTTONS/custom_switches.dart';
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
  bool isHided = false;
  bool inOffer = false;

  @override
  void initState() {
    super.initState();
    nameController.text = widget.artTypeModel.product.title!;
    descriptionController.text = widget.artTypeModel.product.description!;
    isHided = !widget.artTypeModel.product.isAvailable!;
    inOffer = widget.artTypeModel.product.inOffer!;
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.sizeOf(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Product'),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: () {
              // Handle save functionality here
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8.0, vertical: 5),
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
                          );
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
                          );
                        },
                        label: "Offer"),
                  ],
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
              ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: widget.artTypeModel.product.drawingTypes!.length,
                itemBuilder: (context, index) {
                  final drawingType =
                      widget.artTypeModel.product.drawingTypes![index];
                  return Container(
                    margin:
                        const EdgeInsets.symmetric(vertical: 8, horizontal: 5),
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
                              title:
                                  Text("Size: ${size.length} x ${size.width}"),
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
                                    onPressed: () =>
                                        _deleteSize(drawingType, sizeIndex),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 4),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              ElevatedButton.icon(
                                onPressed: () => _addSize(drawingType),
                                icon: const Icon(Icons.add),
                                label: const Text("Add Size"),
                              ),
                              TextButton.icon(
                                onPressed: () => _deleteDrawingType(index),
                                icon:
                                    const Icon(Icons.delete, color: Colors.red),
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
              ElevatedButton(
                onPressed: () {},
                child: const Text('Save Changes'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    nameController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  void _deleteDrawingType(int index) {
    setState(() {
      widget.artTypeModel.product.drawingTypes!.removeAt(index);
    });
  }

  void _addSize(DrawingTypeModel drawingType) {
    TextEditingController lengthController = TextEditingController();
    TextEditingController widthController = TextEditingController();
    TextEditingController priceController = TextEditingController();
    TextEditingController offerPriceController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          title: const Text("Add New Size"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: lengthController,
                decoration: const InputDecoration(labelText: "Length"),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: widthController,
                decoration: const InputDecoration(labelText: "Width"),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: priceController,
                decoration: const InputDecoration(labelText: "Price"),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: offerPriceController,
                decoration:
                    const InputDecoration(labelText: "Offer Price (Optional)"),
                keyboardType: TextInputType.number,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  drawingType.sizes!.add(ProductSizeModel(
                    length: double.tryParse(lengthController.text) ?? 0.0,
                    width: double.tryParse(widthController.text) ?? 0.0,
                    price: double.tryParse(priceController.text) ?? 0.0,
                    offerPrice: double.tryParse(offerPriceController.text),
                  ));
                });
                Navigator.pop(context);
              },
              child: const Text("Add"),
            ),
          ],
        );
      },
    );
  }

  void _deleteSize(DrawingTypeModel drawingType, int index) {
    setState(() {
      drawingType.sizes!.removeAt(index);
    });
  }

  void _editSize(DrawingTypeModel drawingType, int index) {
    TextEditingController lengthController = TextEditingController(
        text: drawingType.sizes![index].length.toString());
    TextEditingController widthController =
        TextEditingController(text: drawingType.sizes![index].width.toString());
    TextEditingController priceController =
        TextEditingController(text: drawingType.sizes![index].price.toString());
    TextEditingController offerPriceController = TextEditingController(
        text: drawingType.sizes![index].offerPrice?.toString() ?? '');

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          title: const Text("Edit Size"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: lengthController,
                decoration: const InputDecoration(labelText: "Length"),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: widthController,
                decoration: const InputDecoration(labelText: "Width"),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: priceController,
                decoration: const InputDecoration(labelText: "Price"),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: offerPriceController,
                decoration:
                    const InputDecoration(labelText: "Offer Price (Optional)"),
                keyboardType: TextInputType.number,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  drawingType.sizes![index] =
                      drawingType.sizes![index].copyWith(
                    length: double.tryParse(lengthController.text),
                    width: double.tryParse(widthController.text),
                    price: double.tryParse(priceController.text),
                    offerPrice: double.tryParse(offerPriceController.text),
                  );
                });
                Navigator.pop(context);
              },
              child: const Text("Save"),
            ),
          ],
        );
      },
    );
  }
}
