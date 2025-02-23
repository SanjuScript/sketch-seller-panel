import 'package:drawer_panel/MODEL/DATA/drawing_type_model.dart';
import 'package:drawer_panel/MODEL/DATA/product_size_model.dart';
import 'package:flutter/material.dart';

class SizeDialogs {
  static void showAddSizeDialog(
    BuildContext context,
    DrawingTypeModel drawingType,
    Function(ProductSizeModel) onSizeAdded,
  ) {
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
              _buildTextField(lengthController, "Length"),
              _buildTextField(widthController, "Width"),
              _buildTextField(priceController, "Price"),
              _buildTextField(offerPriceController, "Offer Price (Optional)"),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () {
                if (_validateInputs(context, lengthController, widthController,
                    priceController)) {
                  ProductSizeModel newSize = ProductSizeModel(
                    length: double.tryParse(lengthController.text)!,
                    width: double.tryParse(widthController.text)!,
                    price: double.tryParse(priceController.text)!,
                    offerPrice: double.tryParse(offerPriceController.text),
                  );

                  onSizeAdded(newSize);

                  Navigator.pop(context);
                }
              },
              child: const Text("Add"),
            ),
          ],
        );
      },
    );
  }

  static void showEditSizeDialog(
    BuildContext context,
    DrawingTypeModel drawingType,
    int index,
    Function(ProductSizeModel) onSizeUpdated,
  ) {
    ProductSizeModel size = drawingType.sizes![index];
    TextEditingController lengthController =
        TextEditingController(text: size.length.toString());
    TextEditingController widthController =
        TextEditingController(text: size.width.toString());
    TextEditingController priceController =
        TextEditingController(text: size.price.toString());
    TextEditingController offerPriceController =
        TextEditingController(text: size.offerPrice?.toString() ?? '');

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
              _buildTextField(lengthController, "Length"),
              _buildTextField(widthController, "Width"),
              _buildTextField(priceController, "Price"),
              _buildTextField(offerPriceController, "Offer Price (Optional)"),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () {
                if (_validateInputs(context, lengthController, widthController,
                    priceController)) {
                  ProductSizeModel updatedSize = size.copyWith(
                    length: double.tryParse(lengthController.text),
                    width: double.tryParse(widthController.text),
                    price: double.tryParse(priceController.text),
                    offerPrice: double.tryParse(offerPriceController.text),
                  );

                  onSizeUpdated(updatedSize);
                  Navigator.pop(context);
                }
              },
              child: const Text("Save"),
            ),
          ],
        );
      },
    );
  }

  static Widget _buildTextField(
      TextEditingController controller, String label) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(labelText: label),
      keyboardType: TextInputType.number,
    );
  }

  static bool _validateInputs(
      BuildContext context,
      TextEditingController length,
      TextEditingController width,
      TextEditingController price) {
    if (length.text.isEmpty || width.text.isEmpty || price.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please fill in all required fields!")),
      );
      return false;
    }
    return true;
  }
}
