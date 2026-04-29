import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:schedule_notification/services/fcm_api_service.dart';
import 'package:schedule_notification/services/fcm_service.dart';
import 'notification_service.dart';

class ParkingExpenseTracker extends StatefulWidget {
  const ParkingExpenseTracker({super.key});

  @override
  State<StatefulWidget> createState() => _ParkingExpenseTrackerState();
}

class _ParkingExpenseTrackerState extends State<ParkingExpenseTracker> {
  // Use nullable ints (not final) to prevent crashes
  int? checkinTime;
  int? checkoutTime;


  FirebaseAnalytics analytics = FirebaseAnalytics.instance;

  @override
  void initState(){
    super.initState();
    FCMService().init();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const Icon(Icons.shutter_speed_outlined),
        title: const Text("Parking Expense Tracker"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                setState(() => checkinTime = DateTime.now().minute);
              },
              child: Text(checkinTime == null ? "Check In" : "Checked In at Min: $checkinTime"),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                setState(() => checkoutTime = DateTime.now().minute);
              },
              child: Text(checkoutTime == null ? "Check Out" : "Checked Out at Min: $checkoutTime"),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                analytics.logEvent(name:
                "charges_button_clicked",
                parameters:{
                  "user":"admin"
                });
                String? token = await FCMService().getToken();
                if(token!=null){
                  await fcm_api_service().sendNotification(token);
                }

                if (checkinTime == null || checkoutTime == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Please Check In and Out first!")),
                  );
                  return;
                }




                int cost = calculateTotalCharges(checkinTime!, checkoutTime!);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Total Charges: ₹$cost")),
                );
              },
              child: const Text("Calculate & Notify"),
            )
          ],
        ),
      ),
    );
  }

  int calculateTotalCharges(int checkin, int checkout) {
    // Duration logic for minutes
    int totalMin = (checkout >= checkin) ? (checkout - checkin) : (60 - checkin + checkout);
    int totalCost = 50;
    if (totalMin > 60) {
      int extraMin = totalMin - 60;
      int slot = (extraMin / 30).ceil();
      totalCost += slot * 30;
    }
    return totalCost;
  }
}
