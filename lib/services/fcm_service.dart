import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:schedule_notification/notification_service.dart';

class FCMService {
  final FirebaseMessaging _messaging = FirebaseMessaging.instance;

  Future<void> init() async {
    // 🔐 Permission
    NotificationSettings settings = await _messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    print("Permission: ${settings.authorizationStatus}");

    // 📲 Get Token
    String? token = await _messaging.getToken();
    print("🔥 FCM TOKEN: $token");

    // 👂 Foreground listener
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print("📩 Foreground message received");

      if(message.notification != null){
        NotificationService().showNotification(
          title: message.notification!.title ?? "No Title",
          body: message.notification!.body ?? "No Body",
        );
      }
    });

    // 📱 App opened from notification
    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      print("🔔 Notification clicked");
    });
  }

  Future<String?> getToken() async {
    return await _messaging.getToken();
  }
}