import 'package:drawer_panel/HELPERS/CONSTANTS/show_toast.dart';
import 'package:drawer_panel/MODEL/DATA/drawing_type_model.dart';
import 'package:drawer_panel/MODEL/DATA/product_size_model.dart';
import 'package:flutter/material.dart';

class AddDrawingTypeDialog extends StatefulWidget {
  final Function(DrawingTypeModel) onDrawingTypeAdded;

  const AddDrawingTypeDialog({super.key, required this.onDrawingTypeAdded});

  @override
  _AddDrawingTypeDialogState createState() => _AddDrawingTypeDialogState();
}

class _AddDrawingTypeDialogState extends State<AddDrawingTypeDialog> {
  final List<ProductSizeModel> newSizes = [];
  String selectedDrawingType = 'Single';

  void addSize() {
    TextEditingController lengthController = TextEditingController();
    TextEditingController widthController = TextEditingController();
    TextEditingController priceController = TextEditingController();
    TextEditingController offerPriceController = TextEditingController();
    final _formKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          title: const Text("Add Size"),
          content: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: lengthController,
                  decoration: const InputDecoration(labelText: "Length"),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) return "Enter Length";
                    if (double.tryParse(value) == null) {
                      return "Enter valid number";
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: widthController,
                  decoration: const InputDecoration(labelText: "Width"),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) return "Enter Width";
                    if (double.tryParse(value) == null) {
                      return "Enter valid number";
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: priceController,
                  decoration: const InputDecoration(labelText: "Price"),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) return "Enter Price";
                    if (double.tryParse(value) == null) {
                      return "Enter valid number";
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: offerPriceController,
                  decoration: const InputDecoration(
                      labelText: "Offer Price (Optional)"),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value!.isNotEmpty && double.tryParse(value) == null) {
                      return "Enter valid number";
                    }
                    return null;
                  },
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  setState(() {
                    newSizes.add(ProductSizeModel(
                      length: double.parse(lengthController.text),
                      width: double.parse(widthController.text),
                      price: double.parse(priceController.text),
                      offerPrice: offerPriceController.text.isNotEmpty
                          ? double.parse(offerPriceController.text)
                          : null,
                    ));
                  });
                  Navigator.pop(context);
                  if (newSizes.isEmpty) {
                    showToast("Please add at least one size!");
                    return;
                  }

                  widget.onDrawingTypeAdded(DrawingTypeModel(
                    type: selectedDrawingType,
                    sizes: newSizes,
                  ));

                  Navigator.pop(context);
                }
              },
              child: const Text("Add Size"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      title: Text(
        "Add New Drawing Type",
        style:
            Theme.of(context).textTheme.labelMedium?.copyWith(letterSpacing: 0),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          DropdownButtonFormField<String>(
            dropdownColor: Colors.white,
            borderRadius: BorderRadius.circular(15),
            value: selectedDrawingType,
            decoration: const InputDecoration(labelText: "Select Drawing Type"),
            items: ['Single', 'Double', 'Triple', 'Family'].map((type) {
              return DropdownMenuItem(
                value: type,
                child: Text(
                  type,
                  style: Theme.of(context)
                      .textTheme
                      .labelMedium
                      ?.copyWith(letterSpacing: 0),
                ),
              );
            }).toList(),
            onChanged: (value) {
              setState(() {
                selectedDrawingType = value!;
              });
            },
          ),
          const SizedBox(height: 10),
          // Column(
          //     children: newSizes.asMap().entries.map((entry) {
          //   int index = entry.key;
          //   ProductSizeModel size = entry.value;

          //   return Text(
          //       "Size ${index + 1}: ${size.length} x ${size.width}, Price: ${size.price}");
          // }).toList()),
          ElevatedButton.icon(
            onPressed: addSize,
            icon: const Icon(Icons.add),
            label: const Text("Add Size"),
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
            if (newSizes.isEmpty) {
              showToast("Please add at least one size!");
              return;
            }

            widget.onDrawingTypeAdded(DrawingTypeModel(
              type: selectedDrawingType,
              sizes: newSizes,
            ));

            Navigator.pop(context);
          },
          child: const Text("Add Type"),
        ),
      ],
    );
  }
}
