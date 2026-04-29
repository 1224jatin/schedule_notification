import 'dart:convert';

import 'package:http/http.dart' as http;

class fcm_api_service{
  Future<void> sendNotification(String token)async{
    final String url = "http://10.0.2.2:3000/send-notification";

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
    if (response.statusCode == 200){
      print("Node.js received the request and sent it to Firebase!");
    }else{
      print("Issue");
    }
  }
}