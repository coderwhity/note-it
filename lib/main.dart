import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:noteit/helpers/authHelpers.dart';
import 'package:noteit/screens/HomePage.dart';
import 'package:noteit/services/NotificationService.dart';
import 'firebase_options.dart';

void main()async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  NotificationService _notificationServices = NotificationService();
  _notificationServices.initialize();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Note It',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: StartScreen(),
    );
  }
}