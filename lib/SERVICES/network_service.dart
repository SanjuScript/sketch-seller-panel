import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';

class NetworkService {
  final Connectivity _connectivity = Connectivity();
  final StreamController<bool> _networkController = StreamController<bool>();

  Stream<bool> get networkStream => _networkController.stream;

  NetworkService() {
    _connectivity.onConnectivityChanged
        .listen((List<ConnectivityResult> result) {
      _networkController.add(_isConnected(result));
    });
  }

  bool _isConnected(List<ConnectivityResult> results) {
    return results.contains(ConnectivityResult.mobile) ||
        results.contains(ConnectivityResult.wifi);
  }

  Future<void> retryConnection() async {
    List<ConnectivityResult> result = await _connectivity.checkConnectivity();
    _networkController.add(_isConnected(result));
  }

  void dispose() {
    _networkController.close();
  }
}
