import 'dart:io';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:os_application/myconfig.dart';
import 'package:os_application/view/loginscreen.dart';
import 'package:os_application/model/user.dart';

class CheckoutScreen extends StatefulWidget {
  final User user;

  const CheckoutScreen({super.key, required this.user});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  Position? _currentPosition;
  String _address = '';
  File? _image;

  @override
  void initState() {
    super.initState();
    _determinePosition();
  }

  void _determinePosition() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    if (permission == LocationPermission.whileInUse ||
        permission == LocationPermission.always) {
      Position position = await Geolocator.getCurrentPosition();
      setState(() {
        _currentPosition = position;
        _address = "${position.latitude}, ${position.longitude}";
      });
    }
  }

  void _pickImage() async {
    final picker = ImagePicker();
    final pickedImage = await picker.pickImage(source: ImageSource.camera);
    if (pickedImage != null) {
      setState(() {
        _image = File(pickedImage.path);
      });
    }
  }

  void _submitCheckout() async {
    if (_image == null || _currentPosition == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please take a photo and wait for GPS")),
      );
      return;
    }

    var request = http.MultipartRequest(
      "POST",
      Uri.parse("${MyConfig.server}/os_application/php/checkout_user.php"),
    );
    request.fields['userid'] = widget.user.userId ?? '';
    request.fields['name'] = widget.user.userName ?? '';
    request.fields['date'] = DateFormat('yyyy-MM-dd').format(DateTime.now());
    request.fields['time'] = DateFormat('HH:mm:ss').format(DateTime.now());
    request.fields['location'] = _address;

    request.files.add(await http.MultipartFile.fromPath('image', _image!.path));

    var response = await request.send();

    if (response.statusCode == 200) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Checkout successful")));
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
      );
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Checkout failed")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Checkout")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text("User ID: ${widget.user.userId}"),
            Text("Name: ${widget.user.userName}"),
            Text("Location: $_address"),
            const SizedBox(height: 20),
            _image == null
                ? const Text("No image taken")
                : Image.file(_image!, height: 150),
            ElevatedButton(
              onPressed: _pickImage,
              child: const Text("Take Photo"),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _submitCheckout,
              child: const Text("Submit Checkout"),
            ),
          ],
        ),
      ),
    );
  }
}
