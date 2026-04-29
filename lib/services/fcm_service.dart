import 'package:firebase_messaging/firebase_messaging.dart';

class fcm_service  {
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  Future<String?> init() async {
    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
      provisional: true
    );
    if(settings.authorizationStatus==AuthorizationStatus.authorized||
        settings.authorizationStatus==AuthorizationStatus.provisional){
      String? token = await getToken();
      return token;
    }else{
      print("Permission declined");
      return null;
    }

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print("Foreground message received");

      if (message.notification != null) {
        print("Title: ${message.notification!.title}");
        print("Body: ${message.notification!.body}");
      }
    });

  }

  Future<String?> getToken() async{
    return await messaging.getToken();
  }
}