import 'package:flutter/material.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  TextEditingController mytextctrl = TextEditingController();
  TextEditingController numactrl = TextEditingController();
  TextEditingController numbctrl = TextEditingController();
  int result = 0;
  String mydata = "";
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text("My App"),
          backgroundColor: Colors.amber,
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Welcome To My App"),
              Text("Flutter is awesome"),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [Text("Hello"), Text("World"), Text("Flutter")],
              ),
              SizedBox(width: 300, child: TextField(controller: mytextctrl)),
              ElevatedButton(
                onPressed: () {
                  mydata = mytextctrl.text;
                  print(mydata);
                  setState(() {});
                },
                child: const Text("CLICK ME"),
              ),
              Text(mydata),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  SizedBox(width: 100, child: TextField(controller: numactrl)),
                  SizedBox(width: 100, child: TextField(controller: numbctrl)),
                  ElevatedButton(onPressed: calculateMe, child: Text("+")),
                  Text(result.toString()),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void calculateMe() {
    int num1 = int.parse(numactrl.text);
    int num2 = int.parse(numbctrl.text);
    result = num1 + num2;
    setState(() {});
  }
}
