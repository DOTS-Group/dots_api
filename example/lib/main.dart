import 'package:flutter/material.dart';
import 'package:dots_baas_flutter/dots_baas_flutter.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: DotsExamplePage(),
    );
  }
}

class DotsExamplePage extends StatefulWidget {
  @override
  _DotsExamplePageState createState() => _DotsExamplePageState();
}

class _DotsExamplePageState extends State<DotsExamplePage> {
  late final Dots dots;
  String status = "Ready";

  @override
  void initState() {
    super.initState();
    // Initialize the SDK
    dots = Dots(
      'demo_app_v1', // Your Project ID
      'YOUR_API_KEY_HERE', // Your API Key
    );

    // Listen to realtime changes
    dots.realtime.listen((data) {
      setState(() {
        status = "Realtime Update: $data";
      });
    });
  }

  Future<void> _signUp() async {
    try {
      final res = await dots.auth
          .signUp(email: "test@example.com", password: "password123");
      setState(() => status = "Signed Up: ${res['id']}");
    } catch (e) {
      setState(() => status = "Error: $e");
    }
  }

  Future<void> _signIn() async {
    try {
      final res = await dots.auth
          .signIn(email: "test@example.com", password: "password123");
      setState(() => status =
          "Signed In. Token: ${res['token'].toString().substring(0, 10)}...");
    } catch (e) {
      setState(() => status = "Error: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Dots BaaS Example')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(status, textAlign: TextAlign.center),
            const SizedBox(height: 20),
            ElevatedButton(onPressed: _signUp, child: const Text('Sign Up')),
            ElevatedButton(onPressed: _signIn, child: const Text('Sign In')),
          ],
        ),
      ),
    );
  }
}
