import 'package:drone_hangar_manager/screens/dashboard_screen.dart';
import 'package:drone_hangar_manager/screens/drones_screen.dart';
import 'package:drone_hangar_manager/screens/hangar_screen.dart';
import 'package:drone_hangar_manager/screens/logs_screen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const HangarApp());
}

class HangarApp extends StatelessWidget {
  const HangarApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int selectedIndex = 0;

  final List<Widget> pages = const [
    DashboardScreen(),
    DronesScreen(),
    HangarScreen(),
    LogsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Hangar Manager'),
        backgroundColor: Colors.blue,
      ),
      body: pages[selectedIndex],
      bottomNavigationBar: NavigationBar(
        selectedIndex: selectedIndex,
        onDestinationSelected: (int index) {
          setState(() {
            selectedIndex = index;
          });
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.dashboard),
            label: 'Dashboard',
          ),
          NavigationDestination(
            icon: Icon(Icons.flight),
            label: 'Drones',
          ),
          NavigationDestination(
            icon: Icon(Icons.home_work),
            label: 'Hangar',
          ),
          NavigationDestination(
            icon: Icon(Icons.list),
            label: 'Logs',
          ),
        ],
      ),
    );
  }
}





