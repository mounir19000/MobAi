import 'dart:convert';
import 'package:http/http.dart' as http;

class AuthService {
  final String baseUrl = "link"; // Replace with your backend URL

  /// Logs in the user using their email and password.
  Future<Map<String, dynamic>> login(String email, String password) async {
    final url = Uri.parse("$baseUrl/login");
    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "email": email,
          "password": password,
        }),
      );

      if (response.statusCode == 200) {
        return {
          "error": false,
          "data": jsonDecode(response.body), // Return token and message
        };
      } else {
        final errorMessage =
            jsonDecode(response.body)["message"] ?? "Login failed";
        return {
          "error": true,
          "message": errorMessage,
        };
      }
    } catch (e) {
      return {
        "error": true,
        "message": "An error occurred: ${e.toString()}",
      };
    }
  }

  /// Registers a new user with their email and password.
  Future<Map<String, dynamic>> register(String email, String password) async {
    final url = Uri.parse("$baseUrl/register");
    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "email": email,
          "password": password,
        }),
      );

      if (response.statusCode == 200) {
        return {
          "error": false,
          "data": jsonDecode(response.body), // Registration success message
        };
      } else {
        final errorMessage =
            jsonDecode(response.body)["message"] ?? "Registration failed";
        return {
          "error": true,
          "message": errorMessage,
        };
      }
    } catch (e) {
      return {
        "error": true,
        "message": "An error occurred: ${e.toString()}",
      };
    }
  }
}
