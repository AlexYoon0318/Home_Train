import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:home_t/achievement_page.dart';
import 'package:home_t/calendar_page.dart';
import 'package:home_t/exercise_page.dart';
import 'package:home_t/option_page.dart';
import 'package:home_t/secondary_exercise_page.dart';
import 'package:home_t/static_page.dart';

class TabPage extends StatefulWidget {
  final FirebaseUser user;

  TabPage(this.user);

  @override
  _TabPageState createState() => _TabPageState();
}

class _TabPageState extends State<TabPage> {
  int _selectedIndex = 0;
  List _pages;


  @override
  void initState() {
    super.initState();
    _pages = [
      CalendarPage(),
      StaticPage(),
      ExercisePage(),
      AchievementPage(),
      OptionPage(widget.user),
      SecondaryExercisePage()
    ];
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child:_pages[_selectedIndex],),
      bottomNavigationBar: BottomNavigationBar(
        fixedColor: Colors.black,
        onTap: _onItemTapped,
        currentIndex: _selectedIndex,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
              icon: Icon(Icons.event),
              title: Text('달력',),
              backgroundColor: Colors.grey),
          BottomNavigationBarItem(
              icon: Icon(Icons.equalizer),
              title: Text('통계',),
              backgroundColor: Colors.grey),
          BottomNavigationBarItem(
              icon: Icon(Icons.directions_run),
              title: Text('운동시작'),
              backgroundColor: Colors.grey),
          BottomNavigationBarItem(
              icon: Icon(Icons.star),
              title: Text('업적',),
              backgroundColor: Colors.grey),
          BottomNavigationBarItem(
              icon: Icon(Icons.build),
              title: Text('설정',),
              backgroundColor: Colors.grey),
        ],
      ),
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
}
