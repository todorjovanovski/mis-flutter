import 'package:firebase_messaging/firebase_messaging.dart';

class NotificationService {
  static final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  static Future<void> initialize() async {
    // Request notification permissions
    await _firebaseMessaging.requestPermission();

    // Handle incoming messages
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      if (message.notification != null) {
        print('Message received: ${message.notification!.title}');
      }
    });

    // Handle messages when app is in background
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('Message opened: ${message.data}');
    });

    // Obtain FCM token for sending notifications
    String? token = await _firebaseMessaging.getToken();
    print('FCM Token: $token');
  }
}
