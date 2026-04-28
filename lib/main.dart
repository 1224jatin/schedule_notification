import 'package:flutter/material.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:untitled1/parking_expense_trraker.dart';
import 'package:timezone/data/latest.dart' as tz_data;
import 'package:timezone/timezone.dart' as tz;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize timezone data
  tz_data.initializeTimeZones();
  
  try {
    // Get the device's timezone info
    final timezoneInfo = await FlutterTimezone.getLocalTimezone();
    String timeZoneName = timezoneInfo.identifier;

    // Map old timezone identifiers if necessary
    if (timeZoneName == 'Asia/Calcutta') {
      timeZoneName = 'Asia/Kolkata';
    }

    // Set the local location
    tz.setLocalLocation(tz.getLocation(timeZoneName));
  } catch (e) {
    debugPrint('Could not set local location: $e');
    tz.setLocalLocation(tz.getLocation('UTC'));
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: ParkingExpenseTrraker(),
    );
  }
}
