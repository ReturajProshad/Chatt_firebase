import 'package:chatt/ui/pages/home_page.dart';
import 'package:chatt/ui/pages/login_screen.dart';
import 'package:chatt/ui/pages/registration_screen.dart';
import 'package:chatt/ui/services/navigation_services.dart';
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

  @override
  Widget build(BuildContext context) {
    // dbService.instance
    //    .createUser("NewUser", "Returaj", ".jpg", "Returaj@gmail.com");
    return MaterialApp(
      title: 'Chatify',
      navigatorKey: navigationService.instance.navigatorkey,
      theme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: Color.fromARGB(42, 117, 188, 1),
        backgroundColor: Color.fromARGB(28, 27, 27, 1),
      ),
      initialRoute: "login",
      routes: {
        "login": (BuildContext _context) => loginpage(),
        "register": (BuildContext _context) => registrationPage(),
        "home": (BuildContext _context) => homePage(),
      },
    );
  }
}
