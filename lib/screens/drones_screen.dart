import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../AppData.dart';
import '../models/drone.dart';

enum DronesScreenState { viewDrones, addDrone, editDrone }

AppData appData = new AppData();

List<Drone> filteredDrones = appData.drones;

class DronesScreen extends StatefulWidget {
  const DronesScreen({super.key});

  @override
  State<StatefulWidget> createState() => _DronesScreenState();
}

class _DronesScreenState extends State<DronesScreen> {
  int _value = 0;
  var filterList = ["All", "Ready", "Flying", "Charge", "Maint."];
  DronesScreenState screenState = DronesScreenState.viewDrones;

  @override
  Widget build(BuildContext context) {
    appData.drones[0].status = Status.available;
    appData.drones[1].status = Status.flying;
    appData.drones[2].status = Status.charging;
    appData.drones[3].status = Status.maintenance;

    final TextTheme textTheme = Theme.of(context).textTheme;

    return decideScreenState();
  }

  Widget decideScreenState() {
    switch (screenState) {
      case DronesScreenState.viewDrones:
        return Column(
          children: [
            buildTitleWithAddButton(context),
            buildFilterDronesBar(),
            buildDronesCardViewer(),
          ],
        );
      case DronesScreenState.addDrone:
        return AddDronePage(
          onBack: () {
            setState(() {
              screenState = DronesScreenState.viewDrones;
            });
          },
        );

      case DronesScreenState.editDrone:
        return EditDronePage(
          onBack: () {
            setState(() {
              screenState = DronesScreenState.viewDrones;
            });
          },
        );
    }
  }

  Expanded buildDronesCardViewer() {
    return Expanded(
      child: ListView.builder(
        padding: EdgeInsets.all(8),
        itemCount: filteredDrones.length,
        itemBuilder: (BuildContext context, int index) {
          final drone = filteredDrones[index];
          return displayDroneCard(drone);
        },
      ),
    );
  }

  Card displayDroneCard(Drone drone) {
    return Card(
      elevation: 2,

      margin: const EdgeInsets.symmetric(vertical: 1),
      child: InkWell(
        borderRadius: BorderRadius.vertical(
          bottom: Radius.circular(8),
          top: Radius.circular(8),
        ),
        onTap: () {
          setState(() {
            screenState = DronesScreenState.editDrone;
          });
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                AspectRatio(
                  aspectRatio: 16 / 6,
                  child: ClipRRect(
                    borderRadius: BorderRadius.vertical(
                      bottom: Radius.circular(20),
                      top: Radius.circular(20),
                    ),
                    child: Image.asset(
                      'assets/images/drone.png',
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Positioned(
                  top: 8,
                  right: 8,
                  child: Badge(
                    label: Padding(
                      padding: const EdgeInsets.all(6.0),
                      child: Text(decideStatusText(drone)),
                    ),
                    textStyle: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                    backgroundColor: decideStatusColor(drone)?.withOpacity(.3),
                    textColor: decideStatusColor(drone),
                  ),
                ),
              ],
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
      ),
    );
  }

  Column buildFilterDronesBar() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.5, vertical: 6),
          child: Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              children: List.generate(filterList.length, (int index) {
                final isSelected = _value == index;

                return Expanded(
                  child: Padding(
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
                        padding: const EdgeInsets.symmetric(vertical: 6),
                        decoration: BoxDecoration(
                          color: isSelected ? Colors.white : Colors.transparent,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Text(
                          filterList[index], // 👈 FIXED POSITION
                          textAlign: TextAlign.center,
                          maxLines: 1,
                          softWrap: false,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context).textTheme.bodySmall
                              ?.copyWith(
                                fontWeight: isSelected
                                    ? FontWeight.bold
                                    : FontWeight.normal,
                              ),
                        ),
                      ),
                    ),
                  ),
                );
              }),
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
              setState(() {
                screenState = DronesScreenState.addDrone;
              });
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
        return appData.drones;
      case 1:
        for (Drone drone in appData.drones) {
          if (drone.status == Status.available) {
            filtered.add(drone);
          }
        }
        return filtered;
      case 2:
        for (Drone drone in appData.drones) {
          if (drone.status == Status.flying) {
            filtered.add(drone);
          }
        }
        return filtered;
      case 3:
        for (Drone drone in appData.drones) {
          if (drone.status == Status.charging) {
            filtered.add(drone);
          }
        }
        return filtered;
      case 4:
        for (Drone drone in appData.drones) {
          if (drone.status == Status.maintenance) {
            filtered.add(drone);
          }
        }
        return filtered;
      default:
        return appData.drones;
    }
  }

  Color? decideStatusColor(Drone drone) {
    if (drone.status == Status.available) {
      return Colors.green;
    } else if (drone.status == Status.charging) {
      return Colors.orange;
    } else if (drone.status == Status.flying) {
      return Colors.blue;
    } else if (drone.status == Status.maintenance) {
      return Colors.red;
    }
    return Colors.green;
  }

  String decideStatusText(Drone drone) {
    if (drone.status == Status.available) {
      return 'available';
    } else if (drone.status == Status.charging) {
      return 'charging';
    } else if (drone.status == Status.flying) {
      return 'flying';
    } else if (drone.status == Status.maintenance) {
      return 'maintenance';
    }
    return 'No Status';
  }
}

class AddDronePage extends StatelessWidget {
  const AddDronePage({super.key, required this.onBack});

  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Padding(
              padding: EdgeInsets.all(8),
              child: IconButton(
                onPressed: () {
                  onBack();
                },
                icon: Icon(Icons.arrow_back),
              ),
            ),
            Text('Add Drone'),
          ],
        ),
      ],
    );
  }
}

class EditDronePage extends StatelessWidget {
  const EditDronePage({super.key, required this.onBack});

  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Padding(
              padding: EdgeInsets.all(8),
              child: IconButton(
                onPressed: () {
                  onBack();
                },
                icon: Icon(Icons.arrow_back),
              ),
            ),
            Text('Edit Drone'),
          ],
        ),
      ],
    );
  }
}
