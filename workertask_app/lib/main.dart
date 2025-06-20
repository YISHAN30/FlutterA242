import 'package:flutter/material.dart';
import 'package:workertask_app/view/splashscreen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Worker Task Management System',
      theme: ThemeData(),
      home: const SplashScreen(),
    );
  }
}
