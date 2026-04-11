import 'models/drone.dart';
import 'models/hangar.dart';

class AppData {

  final Hangar hangar = Hangar();

  List<Drone> drones = [
    StandardDrone("FalconEye", 7, "Recon", 2022, "Parrot", "Anafi"),
    PriorityDrone("SkyCarrier", 8, "Heavy Lift", 2021, "DJI", "Matrice 300"),
    StandardDrone("WindScout", 9, "Survey", 2023, "Autel", "EVO Lite+"),
    PriorityDrone("NightHawk", 10, "Security", 2020, "Skydio", "X2"),
    StandardDrone("AgriFly", 11, "Agriculture", 2024, "DJI", "Agras T10"),
    PriorityDrone("StormRunner", 12, "Inspection", 2023, "Yuneec", "H520"),
  ];


  void populateBay() {
    hangar.bays[0].assignedDrone = drones[0];
    hangar.bays[1].assignedDrone = drones[1];
    hangar.bays[2].assignedDrone = drones[2];
    hangar.bays[3].assignedDrone = drones[3];

  }

}