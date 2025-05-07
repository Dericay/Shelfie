

import 'package:flutter/material.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 252, 235),
      body: Center(
        child:  Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            'assets/images/logo.png',
            height: 200.0,
          ),
          SizedBox(height:20),
          Text(
            'Keep track of your books!',
            style: TextStyle(
              fontSize: 24,
              color: const Color.fromARGB(255, 35, 73, 92),
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 20,),
          ElevatedButton(
            onPressed: () {
              Navigator.pushReplacementNamed(context, '/home');
            },
            style: ElevatedButton.styleFrom(
              foregroundColor: Colors.white, backgroundColor: const Color.fromARGB(255, 35, 73, 92),
              padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15)
            ), child: Text('Continue')),
          ]),
      ),
    );
  }
}