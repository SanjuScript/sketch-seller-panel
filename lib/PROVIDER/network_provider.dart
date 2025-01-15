
import 'package:drawer_panel/SERVICES/network_service.dart';
import 'package:flutter/material.dart';

class NetworkProvider with ChangeNotifier {
  bool _isConnected = true;
  late NetworkService _networkService;

  bool get isConnected => _isConnected;

  NetworkProvider() {
    _networkService = NetworkService();
    _networkService.networkStream.listen((status) {
      _isConnected = status;
      notifyListeners();
    });
  }

  Future<void> retry() async {
    await _networkService.retryConnection();
  }

  @override
  void dispose() {
    _networkService.dispose();
    super.dispose();
  }
}
