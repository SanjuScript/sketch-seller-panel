import 'package:drawer_panel/FUNCTIONS/ORDER_FUN/get_order_pending_stream.dart';
import 'package:flutter/material.dart';

class PendingCountProvider extends ChangeNotifier {
  int _pendingCount = 0;

  int get pendingCount => _pendingCount;

  PendingCountProvider() {
    GetOrderPendingCount.getPendingCount().listen((count) {
      _pendingCount = count;
      notifyListeners();
    });
  }

  bool get shouldShowDot => _pendingCount > 0;
}
