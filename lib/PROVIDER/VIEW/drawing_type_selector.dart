import 'package:drawer_panel/MODEL/DATA/product_model.dart';
import 'package:flutter/material.dart';

class DrawingTypeProvider extends ChangeNotifier {
  double _price = 0;
  double? _offerPrice = 0;
  int _selectedDrawingTypeIndex = 0;
  int _selectedSizeIndex = 0;

  int get selectedDrawingTypeIndex => _selectedDrawingTypeIndex;
  int get selectedSizeIndex => _selectedSizeIndex;
  double get price => _price;
  double get offerPrice => _offerPrice ?? 0.0;

  void updatePriceAndOffer(Product product) {
    final drawingType = product.drawingTypes![_selectedDrawingTypeIndex];
    final size = drawingType.sizes![_selectedSizeIndex];

    _price = size.price ?? 0.0;
    _offerPrice = size.offerPrice!;
    notifyListeners();
  }

  set selectedDrawingTypeIndex(int index) {
    _selectedDrawingTypeIndex = index;
    _selectedSizeIndex = 0;
    notifyListeners();
  }

  set selectedSizeIndex(int index) {
    _selectedSizeIndex = index;
    notifyListeners();
  }
}
