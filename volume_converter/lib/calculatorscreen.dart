import 'package:flutter/material.dart';
import 'package:volume_converter/lengthconversionscreen.dart';

class CalculatorScreen extends StatefulWidget {
  const CalculatorScreen({super.key});

  @override
  State<CalculatorScreen> createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  TextEditingController lengthcontroller = TextEditingController();
  TextEditingController widthcontroller = TextEditingController();
  TextEditingController heightcontroller = TextEditingController();
  double result = 0.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 255, 245, 135),
        title: const Text("Calculator"),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text("Length (cm)"),
                SizedBox(
                  width: 100,
                  child: TextField(
                    controller: lengthcontroller,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 5),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text("Width (cm)"),
                SizedBox(
                  width: 100,
                  child: TextField(
                    controller: widthcontroller,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 5),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text("Height (cm)"),
                SizedBox(
                  width: 100,
                  child: TextField(
                    controller: heightcontroller,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 5),
            SizedBox(height: 20),
            Text(
              "${result.toStringAsFixed(2)}cm3",
              style: TextStyle(fontSize: 32),
            ),
            Text("Centimeters Cubed"),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: onPressed,
              child: const Text("Calculate"),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const Lengthconversionscreen(),
                  ),
                );
              },
              child: const Text("Length Conversion"),
            ),
          ],
        ),
      ),
    );
  }

  void onPressed() {
    if (lengthcontroller.text.isEmpty ||
        widthcontroller.text.isEmpty ||
        heightcontroller.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter all the values")),
      );
      return;
    }

    if (!isNumeric(lengthcontroller.text) ||
        !isNumeric(widthcontroller.text) ||
        !isNumeric(heightcontroller.text)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter numeric values")),
      );
      return;
    }

    double length = double.parse(lengthcontroller.text);
    double width = double.parse(widthcontroller.text);
    double height = double.parse(heightcontroller.text);
    result = length * width * height;
    setState(() {});
  }

  bool isNumeric(String? s) {
    if (s == null) {
      return false;
    }
    return double.tryParse(s) != null;
  }
}
