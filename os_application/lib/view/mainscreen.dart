import 'package:flutter/material.dart';
import 'package:os_application/view/checkinscreen.dart';
import 'package:os_application/model/user.dart';

class MainScreen extends StatefulWidget {
  final User user;
  const MainScreen({super.key, required this.user});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  void _navigateToCheckIn(BuildContext context) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => CheckInScreen(user: widget.user)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Main Screen")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset("image/logo.png", height: 100),
            const SizedBox(height: 20),
            Text("Company Name", style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 10),
            Text("User ID: ${widget.user.userId}"),
            Text("User Name: ${widget.user.userName}"),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: () => _navigateToCheckIn(context),
              child: const Text("Check In"),
            ),
          ],
        ),
      ),
    );
  }
}
