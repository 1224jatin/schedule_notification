import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'notificationService.dart';

class ParkingExpenseTrraker extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _ParkingExpenseTrraker();
}

class _ParkingExpenseTrraker extends State<ParkingExpenseTrraker> {
   late final int checkinTime;
   late final int checkoutTime;
   late Notificationservice Notification = Notificationservice();

   @override
   void initState(){
     super.initState();
     Notification.init();
   }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Icon(Icons.shutter_speed_outlined),
        title: Text("Parking Expense Tracker"),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ElevatedButton(onPressed: (){
            checkinTime = DateTime.now().minute;
          }, child: Text("cheack in ")),
          ElevatedButton(onPressed: (){
            checkoutTime = DateTime.now().minute;
          }, child: Text("check out")),
          ElevatedButton(onPressed: (){
            Notification.showNotification();
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content:
            Text("${totalChargers(checkinTime, checkoutTime)} is your chargers  ")));
          }, child: Text("chargers"))
        ],

      ),
    );

  }
   int totalChargers(int checkinTime, int checkoutTime){
   int totalMin = checkoutTime - checkinTime ;
   int extramin = totalMin - 60;
   int slot = extramin ~/ 30;
  final int totalCost  ;

   if (extramin ~/ 30 != 0){
     slot = slot+1 ;
   }
   totalCost = 50 + slot*30;

   return totalCost;

}

}