import 'dart:convert';
import 'package:http/http.dart' as http;

class FCMApiService {
  // Replace this with your actual Render URL after deployment
  // Example: "https://your-app-name.onrender.com"
  static const String _baseUrl ="https://schedule-notification-8amp.onrender.com";

  Future<void> sendNotification({
    required String token,
    required String title,
    required String body,
    Map<String, dynamic>? data,
  }) async {
    final String url = "$_baseUrl/send-notification";

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          "token": token,
          "title": title,
          "body": body,
          "data": data ?? {},
        }),
      );

      if (response.statusCode == 200) {
        print("✅ Notification sent: ${response.body}");
      } else {
        print("❌ Failed to send notification: ${response.statusCode} - ${response.body}");
      }
    } catch (e) {
      print("Error calling FCM Backend: $e");
    }
  }
}
