import 'package:firebase_messaging/firebase_messaging.dart';

class NotificationService {
  FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  void initialize() {
    // Request permission for receiving messages
    _firebaseMessaging.requestPermission();

    // Configure message handling
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print("Received message: ${message.notification?.title}");
      // Handle incoming message here
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print("App opened via notification: ${message.notification?.title}");
      // Handle notification tap when app is in background
    });

    // Handle token refresh
    _firebaseMessaging.onTokenRefresh.listen((token) {
      print("Token refreshed: $token");
    });  }

}