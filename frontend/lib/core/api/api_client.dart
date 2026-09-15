import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class ApiClient {
  // En Android Emulator se usa 10.0.2.2 para conectarse al localhost de la máquina host.
  // En Web o Windows Desktop se usa localhost (127.0.0.1).
  static String get baseUrl {
    if (kIsWeb || defaultTargetPlatform == TargetPlatform.windows) {
      return 'http://127.0.0.1:8000/api/v1';
    }
    return 'http://10.0.2.2:8000/api/v1';
  }

  // Método para obtener el Token JWT (Login)
  static Future<Map<String, dynamic>> login(String username, String password) async {
    final url = Uri.parse('$baseUrl/token/');
    
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'username': username,
          'password': password,
        }),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        return {
          'success': true,
          'access': data['access'],
          'refresh': data['refresh'],
        };
      } else {
        return {
          'success': false,
          'message': data['detail'] ?? 'Credenciales incorrectas.',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'Error de conexión con el servidor ($e).',
      };
    }
  }
}
