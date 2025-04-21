import 'package:flutter/material.dart';
import 'screens/splash_screen.dart';

void main() {
  runApp(RandomUserApp());
}

class RandomUserApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Random User App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: SplashScreen(),
    );
  }
}