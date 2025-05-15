import 'package:flutter/material.dart';
import 'package:timer/project.dart';
import 'package:timer/tasks.dart';
import 'package:timer/timers.dart';

import 'group.dart';
void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.blue),
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [TimersScreen(), GroupByProjectScreen()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Home")),
      drawer: Drawer(
        child: ListView(
          children: [
            DrawerHeader(child: Text("Navigation")),
            ListTile(
              title: Text("Projects"),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => ProjectsScreen()));
              },
            ),
            ListTile(
              title: Text("Tasks"),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => TasksScreen()));
              },
            ),
          ],
        ),
      ),
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.timer), label: "Timers"),
          BottomNavigationBarItem(icon: Icon(Icons.list), label: "Group By Project"),
        ],
        onTap: (index) => setState(() => _selectedIndex = index),
      ),
    );
  }
}
