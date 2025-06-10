import 'dart:async';
import 'package:flutter/material.dart';
import 'package:skinoptix/login.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 3), () {
      if (mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const Login()),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 242, 244, 246), // Same color as your splash config
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/logo.png',
              width: 600,
              height: 400,
            ),
            SizedBox(height: 5),
            CircularProgressIndicator(
              color: Colors.lightBlue, // or any color you want
            ),
          ],
        ),
      ),
    );
  }
}
