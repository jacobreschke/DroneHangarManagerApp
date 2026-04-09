import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../models/drone.dart';

var drone1 = StandardDrone("Drone1", 1, "Standard", 2026, "DJI", "Mini");
Drone drone2 = PriorityDrone("Drone2", 2, "Standard", 2026, "DJI", "Pro");
Drone drone3 = StandardDrone("Drone3", 3, "Standard", 2026, "DJI", "Pro");
Drone drone4 = PriorityDrone("Drone4", 4, "Standard", 2026, "DJI", "Pro");
Drone drone5 = StandardDrone("Drone5", 5, "Standard", 2026, "DJI", "Pro");
Drone drone6 = PriorityDrone("Drone6", 6, "Standard", 2026, "DJI", "Pro");

var drones = [drone1, drone2, drone3, drone4, drone5, drone6];
List<Drone> filteredDrones = drones;


class DronesScreen extends StatefulWidget {
  const DronesScreen({super.key});

  @override
  State<StatefulWidget> createState() => _DronesScreenState();
}

class _DronesScreenState extends State<DronesScreen> {
  int _value = 0;
  var filterList = ["All", "Ready", "Flying", "Charge", "Maint."];


  @override
  Widget build(BuildContext context) {

    drones[0].status = Status.available;
    drones[1].status = Status.flying;
    drones[2].status = Status.charging;
    drones[3].status = Status.maintenance;


    final TextTheme textTheme = Theme
        .of(context)
        .textTheme;

    return Column(
      children: [
        buildTitleWithAddButton(context),
        buildFilterDronesBar(),
        buildDronesCardViewer(),
      ],
    );
  }

  Expanded buildDronesCardViewer() {
    return Expanded(
      child: ListView.builder(
        padding: EdgeInsets.all(8),
        itemCount: filteredDrones.length,
        itemBuilder: (BuildContext context, int index) {
          final drone = filteredDrones[index];
          return Card(
            elevation: 2,
            margin: const EdgeInsets.symmetric(vertical: 1),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AspectRatio(
                  aspectRatio: 16 / 6,
                  child: ClipRRect(
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(8),
                    ),
                    child: Image.asset(
                      'assets/images/drone.png',
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(drone.name),
                      Text('${drone.manufacturer} ${drone.model}'),
                      Text('Bay 1'),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Column buildFilterDronesBar() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.5, vertical: 6),
          child: Container(
            padding: EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              children: List<Widget>.generate(filterList.length, (int index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 2),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(16),
                    onTap: () {
                      setState(() {
                        _value = index;
                        filteredDrones = filterDrones(_value);
                      });
                    },
                    child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 18,
                            vertical: 6),
                        decoration: BoxDecoration(
                          color: _value == index ? Colors.white : Colors
                              .transparent,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Text(
                            filterList[index],
                            style: TextStyle(
                              fontWeight: _value == index
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                            )
                        )
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ),
      ],
    );
  }

  Row buildTitleWithAddButton(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 10.0),
          child: Text(
            'Current Drones',
            style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: ElevatedButton.icon(
            onPressed: () {
              addDrone(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.black,
              foregroundColor: Colors.white,
            ),
            icon: const Icon(Icons.add),
            label: const Text("Add"),
          ),
        ),
      ],
    );
  }

  List<Drone> filterDrones(int value) {
    List<Drone> filtered = [];
    switch (value) {
      case 0:
        return drones;
      case 1:
        for (Drone drone in drones) {
          if (drone.status == Status.available) {
            filtered.add(drone);
          }
        }
        return filtered;
      case 2:
        for (Drone drone in drones) {
          if (drone.status == Status.flying) {
            filtered.add(drone);
          }
        }
        return filtered;
      case 3:
        for (Drone drone in drones) {
          if (drone.status == Status.charging) {
            filtered.add(drone);
          }
        }
        return filtered;
      case 4:
        for (Drone drone in drones) {
          if (drone.status == Status.maintenance) {
            filtered.add(drone);
          }
        }
        return filtered;
      default:
        return drones;
    }
  }

  void addDrone(BuildContext context) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text("Add drone pressed")));
  }
}
