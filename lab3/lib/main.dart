import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:lab2/services/exact_alarm_helper.dart';
import 'package:lab2/services/local_notification_service.dart';
import 'package:lab2/services/notification_service.dart';
import 'package:provider/provider.dart';
import 'providers/favorite_jokes_provider.dart';
import 'screens/home_screen.dart';
import 'firebase_options.dart';
import 'package:timezone/data/latest.dart' as tz;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  NotificationService.initialize();
  tz.initializeTimeZones();
  await LocalNotificationService.initialize();
  if (await ExactAlarmHelper.checkExactAlarmPermission()) {
    await LocalNotificationService.scheduleDailyNotification();
  } else {
    var isGranted = await ExactAlarmHelper.requestExactAlarmPermission();
    if (isGranted) {
      await LocalNotificationService.scheduleDailyNotification();
    }
  }
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => FavoriteJokesProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Jokes App',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const HomeScreen(),
    );
  }
}
