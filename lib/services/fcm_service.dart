import 'package:firebase_messaging/firebase_messaging.dart';

class FcmService {
  final FirebaseMessaging messaging = FirebaseMessaging.instance;

  Future<void> init() async {
    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
      provisional: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized || 
        settings.authorizationStatus == AuthorizationStatus.provisional) {
      print("Permission granted");
      
      // FIX: You must 'await' the token. 
      // messaging.getToken() returns a Future, not a String.
      String? token = await messaging.getToken();
      print("FCM Token: $token");
    } else {
      print("Permission declined or error occurred");
    }
  }
}
