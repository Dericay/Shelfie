import 'package:flutter/material.dart';
import 'package:shelfie/screens/home_screen.dart';
import 'package:shelfie/screens/myshelf_screen.dart';
import 'package:shelfie/screens/search_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 1;

  final List<Widget> _pages = [HomeScreen(), SearchScreen(), MyShelfScreen()];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_filled), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Discover'),
          BottomNavigationBarItem(icon: Icon(Icons.menu_book), label: 'Books'),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Color(0xFF003566),
        onTap: _onItemTapped,
      ),
    );
  }
}
