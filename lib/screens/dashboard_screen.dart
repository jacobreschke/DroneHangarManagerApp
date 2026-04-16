import 'package:drone_hangar_manager/AppData.dart';
import 'package:drone_hangar_manager/models/hangar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../models/drone.dart';

final AppData appData = AppData();

double borderOpacity = .45;
double backgroundOpacity = .1;
double pagePadding = 12;

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
          buildTitle(),
          buildFleetOverview(),
          buildGridView(),
          buildAlertsBox(context),
          buildCurrentFlightsList(),
          //buildCurrentFlightsBox(),
        ],
      ),
    );
  }

  Padding buildGridView() {
    final droneStatuses = getDroneStatuses();

    return Padding(
      padding: EdgeInsets.all(pagePadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Status', style: TextStyle(fontSize: 18)),
          LayoutBuilder(
            builder: (context, constraints) {
              final width = constraints.maxWidth;

              final crossAxisCount = 2;
              final aspectRatio = 3.2;

              return GridView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                padding: const EdgeInsets.symmetric(vertical: 4),
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
        ],
      ),
    );
  }

  Widget dashboardCard(Map<String, dynamic> droneStatus, BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(.08),
            blurRadius: 16,
            offset: Offset(0, 4),
          ),
        ],
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {
          print('Dashboard Menu Tapped');
        },
        child: Padding(
          padding: EdgeInsets.all(8),
          child: Row(
            children: [
              Icon(
                droneStatus['icon'] as IconData,
                color: droneStatus['color'] as Color,
                size: 20,
              ),
              SizedBox(width: 8),
              Expanded(
                child: Text(
                  '${droneStatus['title']}',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Text(
                '${droneStatus['count']}',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 22,
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
        'subColor': Colors.white,
        'icon': Icons.check_circle,
      },

      {
        'title': 'Charging',
        'count': appData.drones
            .where((drone) => drone.status == Status.charging)
            .length,
        'color': Colors.orange,
        'subColor': Colors.white,
        'icon': Icons.battery_charging_full,
      },
      {
        'title': 'Maintenance',
        'count': appData.drones
            .where((drone) => drone.status == Status.maintenance)
            .length,
        'color': Colors.red,
        'subColor': Colors.white,
        'icon': Icons.build,
      },
      {
        'title': 'Low Battery',
        'count': appData.drones.where((drone) => drone.battery <= 30).length,
        'color': Colors.purple,
        'subColor': Colors.white,
        'icon': Icons.battery_alert,
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
                ? Colors.red.withOpacity(
                    isAlertsExpanded ? 0.35 : borderOpacity,
                  )
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

  Widget buildTitle() {
    final textTheme = Theme.of(context).textTheme;

    return Padding(
      padding: EdgeInsets.all(12),
      child: Container(
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Dashboard',
              style: textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
          ],
        ),
      ),
    );
  }

  Widget buildFleetOverview() {
    final textTheme = Theme.of(context).textTheme;

    final totalDrones = appData.drones.length;
    final occupiedBays = appData.hangar.bays
        .where((bay) => bay.assignedDrone != null)
        .length;

    final flyingDrones = appData.drones
        .where((drone) => drone.status == Status.flying)
        .length;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(.05),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Icon and Fleet Overview
            Row(
              children: [
                Image.asset(
                  'assets/icons/drone.png',
                  height: 20,
                  width: 20,
                  color: Colors.blue,
                ),
                const SizedBox(width: 8),
                Text(
                  'Fleet Overview',
                  style: textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
              decoration: BoxDecoration(
                color: const Color(0xFFEDEFF5),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Row(
                children: [
                  // Left column - total drones
                  Expanded(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '$totalDrones',
                          style: textTheme.displayMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: Text('Total Drones'),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    height: 40,
                    width: 1,
                    color: Colors.grey.withOpacity(0.3),
                  ),
                  const SizedBox(width: 16),
                  // Right column - flying and bays used
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(
                              Icons.flight,
                              size: 16,
                              color: Colors.blue,
                            ),
                            const SizedBox(width: 6),
                            Text('$flyingDrones Flying'),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            const Icon(
                              Icons.home,
                              size: 16,
                              color: Colors.blue,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              '$occupiedBays/${appData.hangar.bays.length} Bays Used',
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }


  Widget buildCurrentFlightsList() {
    final textTheme = Theme.of(context).textTheme;
    final flyingDrones = getFlyingDrones();

    return Padding(
      padding: EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            child: Text('Current Flights', style: textTheme.titleMedium),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 6),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(.05),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Divider(height: 1, color: Colors.grey.withOpacity(0.2)),
                  if (flyingDrones.isEmpty)
                    const Padding(
                      padding: EdgeInsets.all(16),
                      child: Text('No drones currently flying'),
                    )
                  else
                    ...flyingDrones.map((drone) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4.0),
                        child: ListTile(
                          dense: true,
                          leading: const Icon(Icons.flight, color: Colors.blue),
                          title: Text(drone.name),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                getBatteryIcon(drone.battery),
                                size: 16,
                                color: getBatteryColor(drone.battery),
                              ),
                              SizedBox(width: 4,),
                              Text(
                                  '${drone.battery}%',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18
                                ),
                              ),
                            ],
                          ),

                        ),
                      );
                    }).toList(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Color? getBatteryColor(int battery) {
    if (battery >= 70) { return Colors.green; }
    else if (battery >= 30) { return Colors.orange; }
    else { return Colors.red; }
  }

  IconData? getBatteryIcon(int battery) {
    if (battery >= 90) { return Icons.battery_full; }
    if (battery >= 60) { return Icons.battery_6_bar; }
    if (battery >= 30) { return Icons.battery_3_bar; }
    if (battery >= 10) { return Icons.battery_1_bar; }
    else { return Icons.battery_alert; }
  }
}
