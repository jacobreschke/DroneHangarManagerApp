import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../models/drone.dart';



Drone drone1 = new StandardDrone(1, "Standard", 2026, "DJI", "Mini");
Drone drone2 = new PriorityDrone(2, "Standard", 2026, "DJI", "Pro");
Drone drone3 = new PriorityDrone(2, "Standard", 2026, "DJI", "Pro");
Drone drone4 = new PriorityDrone(2, "Standard", 2026, "DJI", "Pro");
Drone drone5 = new PriorityDrone(2, "Standard", 2026, "DJI", "Pro");
Drone drone6 = new PriorityDrone(2, "Standard", 2026, "DJI", "Pro");

var drones = [drone1, drone2, drone3, drone4, drone5, drone6];

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
    final TextTheme textTheme = Theme.of(context).textTheme;

    return Column(
      children: [
        buildTitleWithAddButton(context),
        buildFilterDrones(),

        Expanded(
          child: ListView.builder(
            padding: EdgeInsets.all(8),
            itemCount: drones.length,
            itemBuilder: (BuildContext context, int index) {
              final drone = drones[index];

              return ListTile(
                title: Text(drone.toString()),
              );
            },

          ),
        )
      ],
    );
  }

  Column buildFilterDrones() {
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          const SizedBox(height: 10.0),
          Wrap(
            spacing: 5.0,
            children: List<Widget>.generate(5, (int index) {
              return ChoiceChip(
                label: Text(filterList[index]),
                selected: _value == index,
                onSelected: (bool selected) {
                  setState(() {
                    _value = selected ? index : 0;
                  });
                },
              );
            }).toList(),
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

  void addDrone(BuildContext context) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text("Add drone pressed")));
  }
}
