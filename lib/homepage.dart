import 'package:flutter/material.dart';
import 'package:todolist_team/teamdashboard.dart';
import 'teampage.dart';   
import 'settingspage.dart'; 
import 'homedashboardpage.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    HomeDashboardPage(), // The HomeDashboardPage widget
    TeamPage(), // The TeamPage widget
    SettingPage(), // The SettingPage widget
    TeamDashboardPage(teamCode: '',),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9E6EE),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF9E6EE),
        elevation: 0,
        title: const Center(
          child: Text(
            'To-D0 App',
            style: TextStyle(
              fontFamily: 'fingerPaint',
              fontSize: 38,
                color: Color(0xFFCD3271),
            ),
          ),
        ),
      ),
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.group),
            label: 'Team',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
        selectedItemColor: const Color(0xFFCD3271),
        unselectedItemColor: const Color(0xFFE594B5),
      ),
    );
  }
}
