import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:shelfie/models/books.dart';
import 'package:shelfie/screens/main_screen.dart';
import 'package:shelfie/screens/welcome_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();

  Hive.registerAdapter(BookAdapter());

  await Hive.openBox<Book>('savedBooks');
  await Hive.openBox<Book>('readingBooks');

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
