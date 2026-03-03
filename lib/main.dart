import 'package:flutter/material.dart';
import 'dart:convert'; 
import 'package:http/http.dart' as http;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: StatusScreen(),
    );
  }
}

class StatusScreen extends StatefulWidget {
  const StatusScreen({super.key});


  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

 
  @override
  State<StatusScreen> createState() => _StatusScreenState();

}
class _StatusScreenState extends State<StatusScreen> {
  String responseText = "Press button to check backend";

  Future<void> fetchStatus() async {
   try{
    final response = await http.get(
      Uri.parse("http://46.246.248.195:8080/status?gate_id=A")
      );
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      setState(() {
        responseText = const JsonEncoder.withIndent('  ').convert(data);
      });
    } else {
      setState(() {
        responseText = "Failed to load status: ${response.statusCode}";
      });}
    } catch (e) {
      setState(() {
        responseText = "Connection Error: $e";
      });
   }
  }

  @override
  Widget build(BuildContext context) {
        return Scaffold(
        appBar: AppBar(title: const Text("Smart Parking Status")),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              ElevatedButton(
                onPressed: fetchStatus,
                child: const Text("Check Status"),
              ),
              const SizedBox(height: 20),
              Expanded(
                child: SingleChildScrollView(
                  child: Text(responseText),
                ),
              ),
            ],
     
        ),
      ) // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
