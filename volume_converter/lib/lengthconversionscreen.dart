import 'package:flutter/material.dart';

class Lengthconversionscreen extends StatefulWidget {
  const Lengthconversionscreen({super.key});

  @override
  State<Lengthconversionscreen> createState() => _LengthconversionscreenState();
}

class _LengthconversionscreenState extends State<Lengthconversionscreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(child: Text("Length Converter")),
    );
  }
}
