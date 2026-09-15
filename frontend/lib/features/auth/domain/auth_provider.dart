import 'package:flutter/material.dart';
import '../../../core/api/api_client.dart';

class AuthProvider with ChangeNotifier {
  bool _isLoading = false;
  String? _errorMessage;
  String? _token;
  String? _username;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  String? get token => _token;
  String? get username => _username;
  bool get isAuthenticated => _token != null;

  Future<bool> login(String usernameInput, String passwordInput) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    final result = await ApiClient.login(usernameInput, passwordInput);

    _isLoading = false;

    if (result['success'] == true) {
      _token = result['access'];
      _username = usernameInput;
      _errorMessage = null;
      notifyListeners();
      return true;
    } else {
      _errorMessage = result['message'] ?? 'Error desconocido al iniciar sesión';
      notifyListeners();
      return false;
    }
  }

  void logout() {
    _token = null;
    _username = null;
    _errorMessage = null;
    notifyListeners();
  }
}
