import 'package:flutter/material.dart';
import 'package:untitled1/services/fcm_api_service.dart';
import 'package:untitled1/services/fcm_service.dart';
import 'notificationService.dart';

class ParkingExpenseTrraker extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _ParkingExpenseTrraker();
}

class _ParkingExpenseTrraker extends State<ParkingExpenseTrraker> {
  // Use nullable ints (not final) to prevent crashes
  int? checkinTime;
  int? checkoutTime;
  final Notificationservice notificationService = Notificationservice();

  @override
  void initState() {
    super.initState();
    notificationService.init();
    FcmService().init();
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
                if (checkinTime == null || checkoutTime == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Please Check In and Out first!")),
                  );
                  return;
                }
                
                // 1. Local Notification
                notificationService.showNotification();
                
                // 2. FCM Notification via Node.js Backend
                // Make sure your terminal says "Server running on port 3000"
                await FcmApiService().sendNotification(
                  "eMOE7v0HQzWPNRgzDG9r16:APA91bEYw1piegokDvl8Q6TjibMEc9Wl9oPPETPyaNzsDbifr4Iv4OiZQzzfuTTDbYf3yKNlnoT99i6MsYLPa9kDoad_yUxngQgLV5OJ3vA9-6G3zhNyOnI"
                );
                
                int cost = totalChargers(checkinTime!, checkoutTime!);
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

  int totalChargers(int checkin, int checkout) {
    // Duration logic for minutes
    int totalMin = (checkout >= checkin) ? (checkout - checkin) : (60 - checkin + checkout);
    int totalCost = 50; 
    if (totalMin > 60) {
      int extramin = totalMin - 60;
      int slot = (extramin / 30).ceil();
      totalCost += slot * 30;
    }
    return totalCost;
  }
}
