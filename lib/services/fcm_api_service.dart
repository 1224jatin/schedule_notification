import 'dart:convert';

import 'package:http/http.dart' as http;

class fcm_api_service{
  Future<void> sendNotification(String token)async{
    final String url = "http://192.168.1.14:3000/send-notification";

    final response = await http.post(
      Uri.parse(url),
      headers: {
        'Content-Type':'application/json'
      },
      body: jsonEncode({
        "token":token,
        "title":"Parking Alert",
        "body":"Hi Notification"
      })
    );
    print("Server Response : ${response.body}");
  }
}