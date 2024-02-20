import 'package:chatt/ui/auth/login_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import './firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Chatify',
      theme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: Color.fromARGB(42, 117, 188, 1),
        backgroundColor: Color.fromARGB(28, 27, 27, 1),
      ),
      home: const loginpage(),
    );
  }
}
