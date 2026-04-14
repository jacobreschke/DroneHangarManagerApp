import 'package:drone_hangar_manager/AppData.dart';
import 'package:drone_hangar_manager/models/hangar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../models/drone.dart';

final AppData appData = AppData();

double borderOpacity = .45;
double backgroundOpacity = .1;
double pagePadding = 8;

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  bool isAlertsExpanded = false;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          buildGridView(),
          buildAlertsBox(context),
          buildCurrentFlightsBox(),
        ],
      ),
    );
  }

  Padding buildGridView() {
    final droneStatuses = getDroneStatuses();

    return Padding(
      padding: EdgeInsets.all(pagePadding),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final width = constraints.maxWidth;

          final crossAxisCount = width < 500 ? 2 : 3;
          final aspectRatio = crossAxisCount == 2 ? 1.3 : 1.1;

          return GridView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            padding: const EdgeInsets.all(2),
            itemCount: droneStatuses.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: crossAxisCount,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: aspectRatio,
            ),
            itemBuilder: (BuildContext context, int index) {
              return dashboardCard(droneStatuses[index], context);
            },
          );
        },
      ),
    );
  }

  Widget dashboardCard(Map<String, dynamic> droneStatus, BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: (droneStatus['subColor'] as Color).withOpacity(
          backgroundOpacity,
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: (droneStatus['color'] as Color).withOpacity(borderOpacity),
          width: 1.2,
        ),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {
          print('Dashboard Menu Tapped');
        },
        child: Padding(
          padding: EdgeInsets.all(25),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    droneStatus['icon'] as IconData,
                    color: droneStatus['color'] as Color,
                    size: 20,
                  ),
                  SizedBox(width: 3),
                  Expanded(
                    child: Text(
                      '${droneStatus['title']}',
                      style: TextStyle(
                        color: (droneStatus['color'] as Color),
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              Spacer(),
              Text(
                '${droneStatus['count']}',
                style: TextStyle(
                  color: (droneStatus['color'] as Color),
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<Map<String, dynamic>> getAlerts() {
    List<Map<String, dynamic>> alerts = [];

    for (var drone in appData.drones) {
      if (drone.battery <= 20) {
        alerts.add({
          'title': '${drone.name} low battery',
          'icon': Icons.battery_alert,
          'priority': 1,
          'color': Colors.orange,
        });
      }
      if (drone.status == Status.maintenance) {
        alerts.add({
          'title': '${drone.name} in maintenance',
          'icon': Icons.build,
          'priority': 2,
          'color': Colors.orange,
        });
      }

      if (drone.status == Status.flying && drone.battery <= 30) {
        alerts.add({
          'title': '${drone.name} flying with low battery',
          'icon': Icons.warning,
          'priority': 0,
          'color': Colors.red,
        });
      }
    }

    alerts.sort((a, b) => a['priority'].compareTo(b['priority']));

    return alerts;
  }

  List<Map<String, dynamic>> getDroneStatuses() {
    return [
      {
        'title': 'Available',
        'count': appData.drones
            .where((drone) => drone.status == Status.available)
            .length,
        'color': Colors.green,
        'subColor': Colors.green,
        'icon': Icons.check_circle,
      },
      {
        'title': 'Flying',
        'count': appData.drones
            .where((drone) => drone.status == Status.flying)
            .length,
        'color': Color(0xFF3179E1),
        'subColor': Colors.blue,
        'icon': Icons.flight,
      },
      {
        'title': 'Charging',
        'count': appData.drones
            .where((drone) => drone.status == Status.charging)
            .length,
        'color': Colors.orange,
        'subColor': Colors.orange,
        'icon': Icons.battery_charging_full,
      },
      {
        'title': 'Maintenance',
        'count': appData.drones
            .where((drone) => drone.status == Status.maintenance)
            .length,
        'color': Colors.red,
        'subColor': Colors.red,
        'icon': Icons.build,
      },
      {
        'title': 'Low Battery',
        'count': appData.drones.where((drone) => drone.battery <= 30).length,
        'color': Colors.purple,
        'subColor': Colors.white,
        'icon': Icons.battery_alert,
      },
      {
        'title': 'Bays Used',
        'count':
            '${appData.hangar.bays.where((bay) => bay.assignedDrone != null).length}/${appData.hangar.bays.length}',
        'color': Colors.deepPurpleAccent,
        'subColor': Colors.white,
        'icon': Icons.home,
      },
    ];
  }

  Widget buildAlertsBox(BuildContext context) {
    final alerts = getAlerts();
    final hasCritical = alerts.any((a) => a['priority'] == 0);

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: pagePadding),
      child: Container(
        decoration: BoxDecoration(
          color: hasCritical
              ? Colors.red.withOpacity(isAlertsExpanded ? 0.20 : 0.55)
              : Colors.orange.withOpacity(backgroundOpacity),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            width: 1.2,
            color: hasCritical
                ? Colors.red.withOpacity(isAlertsExpanded ? 0.35 : borderOpacity)
                : Colors.orange.withOpacity(borderOpacity),
          ),
        ),
        child: Theme(
          data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
          child: ExpansionTile(
            onExpansionChanged: (expanded) {
              setState(() {
                isAlertsExpanded = expanded;
              });
            },
            tilePadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 4,
            ),
            childrenPadding: const EdgeInsets.only(bottom: 8),
            leading: Icon(
              Icons.warning_amber_rounded,
              color: hasCritical ? Colors.red : Colors.orange,
            ),
            title: const Text(
              'Alerts',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text('${alerts.length} active'),
            children: alerts.isEmpty
                ? [
                    const Padding(
                      padding: EdgeInsets.all(16),
                      child: Text('No alerts'),
                    ),
                  ]
                : alerts.map((alert) {
                    return ListTile(
                      dense: true,
                      leading: Icon(alert['icon'], color: alert['color']),
                      title: Text(alert['title']),
                    );
                  }).toList(),
          ),
        ),
      ),
    );
  }

  List<Drone> getFlyingDrones() {
    return appData.drones
        .where((drone) => drone.status == Status.flying)
        .toList();
  }

  Widget buildCurrentFlightsBox() {
    final flyingDrones = getFlyingDrones();

    return Padding(
      padding: EdgeInsets.all(pagePadding),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey,
          width: 1.2),
        ),
        child: Theme(
          data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
          child: ExpansionTile(
            leading: Icon(Icons.flight),
            title: Text(
              'Current Flights',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            subtitle: Text('${flyingDrones.length} active'),
            children: flyingDrones.isEmpty
                ? [
                    Padding(
                      padding: EdgeInsets.all(16),
                      child: Text('No drones currently flying'),
                    ),
                  ]
                : flyingDrones.map((drone) {
                    return ListTile(
                      dense: true,
                      leading: Icon(Icons.flight, color: Colors.blue),
                      title: Text(drone.name),
                      subtitle: Text('Battery: ${drone.battery}%'),
                    );
                  }).toList(),
          ),
        ),
      ),
    );
  }
}
