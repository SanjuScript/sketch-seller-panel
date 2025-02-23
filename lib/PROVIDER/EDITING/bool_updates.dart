import 'package:flutter/material.dart';

class BoolUpdatesProvider extends ChangeNotifier {
  bool _isAvailable = false;
  bool _inOffer = false;

  bool get isAvailable => _isAvailable;
  bool get inOffer => _inOffer;

  void setAvailable(bool available) {
    _isAvailable = available;
    notifyListeners();
  }

  void setOffer(bool offer) {
    _inOffer = offer;
    notifyListeners();
  }
}
