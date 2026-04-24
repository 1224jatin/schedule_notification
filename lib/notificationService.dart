import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
class Notificationservice {

  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();




  //initialization -

  Future <void> init() async {
    flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
        ?.requestNotificationsPermission();
     const AndroidInitializationSettings androidSettings = AndroidInitializationSettings(
        "@mipmap/ic_launcher");
     const DarwinInitializationSettings iosSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,

    );

     const InitializationSettings initializationSettings = InitializationSettings(
        android: androidSettings,
        iOS: iosSettings
    );
     flutterLocalNotificationsPlugin.initialize(initializationSettings);


  }

  void showNotification({id, title, body}){

    AndroidNotificationDetails androidDetials = AndroidNotificationDetails(
        "ut001",
        "myNotifyApp",
        importance: Importance.max,
        priority: Priority.max,
        icon: "@mipmap/ic_launcher",
        playSound: true
    ) ;

    DarwinNotificationDetails iosDetails = DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
        presentBanner: true
    );

    late NotificationDetails notificationDetails = NotificationDetails(
        android: androidDetials,
        iOS: iosDetails
    );


    flutterLocalNotificationsPlugin.show(0,"Quick HUB", "HI notification hitted",
       notificationDetails);

    flutterLocalNotificationsPlugin.zonedSchedule(0,
       "Quick Hub",
        "NOTIFICATION",
        tz.TZDateTime.from(DateTime.now().add(Duration(seconds: 5)), tz.local),

    notificationDetails,
      uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.wallClockTime,
     androidScheduleMode:AndroidScheduleMode.exactAllowWhileIdle ,
  );

  }


  }
