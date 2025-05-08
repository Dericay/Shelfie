import 'package:flutter/material.dart';
import 'package:shelfie/screens/main_screen.dart';
import 'package:shelfie/screens/welcome_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Shelfie',
      initialRoute: '/',
      routes: {
        '/': (context) => const WelcomeScreen(),
        '/discover': (context) => const MainScreen(),
      },
    );
  }
}

