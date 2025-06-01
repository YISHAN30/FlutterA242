import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:os_application/myconfig.dart';
import 'package:os_application/view/tasksubmissionscreen.dart';
import 'package:os_application/model/worker.dart';
import 'package:os_application/view/mainscreen.dart';

class CheckInScreen extends StatefulWidget {
  final Worker worker;
  const CheckInScreen({super.key, required this.worker});

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
      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        return;
      }
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

  void _showSuccessDialog(String checkinDate, String checkinTime) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text("Check-in Successful"),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Worker ID: ${widget.worker.workerId}"),
                Text("Worker Name: ${widget.worker.workerName}"),
                Text("Check-in Date: $checkinDate"),
                Text("Check-in Time: $checkinTime"),
                if (_position != null)
                  Text(
                    "Location: ${_position!.latitude.toStringAsFixed(6)}, ${_position!.longitude.toStringAsFixed(6)}",
                  ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder:
                          (context) =>
                              TaskSubmissionScreen(worker: widget.worker),
                    ),
                  );
                },
                child: const Text("OK"),
              ),
            ],
          ),
    );
  }

  void _checkIn() async {
    if (_image == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please take a photo before check-in"),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }
    if (_position == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Unable to get location"),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final request = http.MultipartRequest(
      "POST",
      Uri.parse("${MyConfig.server}/checkin_worker.php"),
    );
    request.fields['worker_id'] = widget.worker.workerId ?? '';
    request.fields['worker_name'] = widget.worker.workerName ?? '';
    request.fields['checkin_date'] =
        DateTime.now().toLocal().toString().split(' ')[0];
    request.fields['checkin_time'] = TimeOfDay.now().format(context);
    request.fields['latitude'] = _position!.latitude.toString();
    request.fields['longitude'] = _position!.longitude.toString();
    request.files.add(await http.MultipartFile.fromPath('image', _image!.path));

    final response = await request.send();
    final result = await http.Response.fromStream(response);

    if (response.statusCode == 200 &&
        jsonDecode(result.body)['status'] == 'success') {
      final checkinDate = request.fields['checkin_date']!;
      final checkinTime = request.fields['checkin_time']!;
      _showSuccessDialog(checkinDate, checkinTime);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Check-in failed. Please try again."),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final date = DateTime.now();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.greenAccent,
        title: const Text("Check In Screen"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => MainScreen(worker: widget.worker),
              ),
            );
          },
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Worker ID: ${widget.worker.workerId}",
                style: const TextStyle(fontSize: 20),
              ),
              const SizedBox(height: 8),
              Text(
                "Worker Name: ${widget.worker.workerName}",
                style: const TextStyle(fontSize: 20),
              ),
              const SizedBox(height: 8),
              Text(
                "Date: ${date.toLocal().toString().split(' ')[0]}",
                style: const TextStyle(fontSize: 20),
              ),
              const SizedBox(height: 8),
              Text(
                _position == null
                    ? "Locating..."
                    : "Location: ${_position!.latitude.toStringAsFixed(6)}, ${_position!.longitude.toStringAsFixed(6)}",
                style: const TextStyle(fontSize: 20),
              ),
              const SizedBox(height: 20),
              _image != null
                  ? Image.file(_image!, height: 220)
                  : const Text(
                    "No image selected",
                    style: TextStyle(fontSize: 18),
                  ),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                onPressed: _pickImage,
                icon: const Icon(Icons.camera_alt),
                label: const Text(
                  "Take Photo",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 40,
                    vertical: 16,
                  ),
                  backgroundColor: Colors.greenAccent,
                  foregroundColor: Colors.white,
                ),
              ),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: _checkIn,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 40,
                    vertical: 16,
                  ),
                  backgroundColor: Colors.greenAccent,
                  foregroundColor: Colors.white,
                ),
                child: const Text(
                  "Check In",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
