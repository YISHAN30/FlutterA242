import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:os_application/myconfig.dart';
import 'package:os_application/view/tasksubmissionscreen.dart';
import 'package:os_application/model/user.dart';

class CheckInScreen extends StatefulWidget {
  final User user;
  const CheckInScreen({super.key, required this.user});

  @override
  State<CheckInScreen> createState() => _CheckInScreenState();
}

class _CheckInScreenState extends State<CheckInScreen> {
  Position? _position;
  File? _image;
  final picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _getLocation();
  }

  Future<void> _getLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) return;

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      permission = await Geolocator.requestPermission();
    }

    Position position = await Geolocator.getCurrentPosition();
    setState(() {
      _position = position;
    });
  }

  Future<void> _pickImage() async {
    final pickedFile = await picker.pickImage(
      source: ImageSource.camera,
      imageQuality: 75,
    );
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  void _checkIn() async {
    if (_image == null || _position == null) return;

    final request = http.MultipartRequest(
      "POST",
      Uri.parse("${MyConfig.server}/checkin_user.php"),
    );
    request.fields['userid'] = widget.user.userId ?? '';
    request.fields['name'] = widget.user.userName ?? '';
    request.fields['latitude'] = _position!.latitude.toString();
    request.fields['longitude'] = _position!.longitude.toString();
    request.files.add(await http.MultipartFile.fromPath('image', _image!.path));

    final response = await request.send();
    final result = await http.Response.fromStream(response);

    if (response.statusCode == 200 &&
        jsonDecode(result.body)['status'] == 'success') {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Check-in successful")));
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => TaskSubmissionScreen(user: widget.user),
        ),
      );
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Check-in failed")));
    }
  }

  @override
  Widget build(BuildContext context) {
    final date = DateTime.now();
    return Scaffold(
      appBar: AppBar(title: const Text("Check In")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text("User ID: ${widget.user.userId}"),
            Text("Name: ${widget.user.userName}"),
            Text("Date: ${date.toLocal().toString().split(' ')[0]}"),
            Text(
              _position == null
                  ? "Locating..."
                  : "Location: ${_position!.latitude}, ${_position!.longitude}",
            ),
            const SizedBox(height: 10),
            _image != null
                ? Image.file(_image!, height: 200)
                : const Text("No image selected"),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: _pickImage,
              child: const Text("Take Photo"),
            ),
            ElevatedButton(onPressed: _checkIn, child: const Text("Check In")),
          ],
        ),
      ),
    );
  }
}
