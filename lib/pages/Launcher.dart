import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_workshoptest/pages/AboutPage.dart';
import 'package:flutter_workshoptest/pages/HomePage.dart';
import 'package:flutter_workshoptest/pages/ProfilePage.dart';

class Launcher extends StatefulWidget {
  Launcher({Key? key}) : super(key: key);

  @override
  _LauncherState createState() => _LauncherState();
}

class _LauncherState extends State<Launcher> {
  int _selectedIndex = 0;
  List<Widget> _pageWidget = [HomePage(), ProfilePage(), AboutPage()];

  List<BottomNavigationBarItem> _menuBar = <BottomNavigationBarItem>[
    BottomNavigationBarItem(icon: Icon(FontAwesomeIcons.home), label: 'Home'),
    BottomNavigationBarItem(
        icon: Icon(FontAwesomeIcons.userAlt), label: 'Profile'),
    BottomNavigationBarItem(
        icon: Icon(FontAwesomeIcons.infoCircle), label: 'About'),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pageWidget.elementAt(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        items: _menuBar,
        currentIndex: _selectedIndex,
        selectedItemColor: Theme.of(context).primaryColor,
        unselectedItemColor: Colors.grey,
        onTap: _onItemTapped,
      ),
    );
  }
}
