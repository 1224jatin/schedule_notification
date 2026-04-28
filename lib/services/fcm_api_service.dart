import 'dart:convert';
import 'package:http/http.dart' as http;

class FcmApiService {
  // Use 10.0.2.2 for Android Emulator, or your PC's IP for physical devices
  static const String baseUrl = "http://10.0.2.2:3000";

  Future<void> sendNotification(String token) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/send-notification'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          "token": token,
          "title": "Hello Student",
          "body": "Notification from Node.js Backend!"
        }),
      );

      if (response.statusCode == 200) {
        print("Backend: Notification sent successfully");
      } else {
        print("Backend: Failed to send notification: ${response.body}");
      }
    } catch (e) {
      print("Error connecting to backend: $e");
    }
  }
}
