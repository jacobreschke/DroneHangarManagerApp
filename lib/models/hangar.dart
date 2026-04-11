import 'drone.dart';

class Hangar {

  List<Bay> bays = List.generate(12,  (index) => Bay(id: index + 1),);

  void assignDroneToBay(Drone drone, Bay bay) {

  }

  void removeDroneFromBay(Bay bay) {

  }

}

class Bay {

  final int id;
  Drone? assignedDrone;


  Bay({required this.id, this.assignedDrone});


}
