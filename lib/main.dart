import 'package:flutter/material.dart';
import 'package:skinoptix/spalash_screen.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, // Hide debug banner
      title: 'Tea Sampling App',
      theme: ThemeData(
        primarySwatch: Colors.green, // Set primary color
      ),
      home: const SplashScreen(), // Set SplashScreen as the starting screen
    );
  }
}
