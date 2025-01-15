import 'package:flutter/material.dart';

class ProductSliderProvider extends ChangeNotifier {
  int _selectedIndex = 0;

  int get selectedIndex => _selectedIndex;

  set selectedIndex(int index) {
    _selectedIndex = index;
    notifyListeners();
  }

  PageController createPageController() {
    return PageController(initialPage: _selectedIndex);
  }

  void onPageChange(int index) {
    selectedIndex = index;
    notifyListeners();
  }

  void navigateToPage(PageController pageController, int index) {
    pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
  }
}
