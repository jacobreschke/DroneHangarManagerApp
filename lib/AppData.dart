import 'models/drone.dart';
import 'models/hangar.dart';

class AppData {
  AppData._internal() {
    populateData();
  }
  static final AppData _instance = AppData._internal();
  factory AppData() => _instance;

  final Hangar hangar = Hangar();

  List<Drone> drones = [
    StandardDrone("FalconEye", 7, "Recon", 2022, "Parrot", "Anafi"),
    PriorityDrone("SkyCarrier", 8, "Heavy Lift", 2021, "DJI", "Matrice 300"),
    StandardDrone("WindScout", 9, "Survey", 2023, "Autel", "EVO Lite+"),
    PriorityDrone("NightHawk", 10, "Security", 2020, "Skydio", "X2"),
    StandardDrone("AgriFly", 11, "Agriculture", 2024, "DJI", "Agras T10"),
    PriorityDrone("StormRunner", 12, "Inspection", 2023, "Yuneec", "H520"),
    StandardDrone("CloudRider", 13, "Mapping", 2022, "DJI", "Mini 3 Pro"),
    PriorityDrone("IronWing", 14, "Defense", 2021, "Lockheed", "X-Drone"),
  ];

  void populateData() {
    // --- Assign Bays (not all drones are in bays) ---
    hangar.bays[0].assignedDrone = drones[0];
    drones[0].currentBay = 1;

    hangar.bays[1].assignedDrone = drones[1];
    drones[1].currentBay = 2;

    hangar.bays[2].assignedDrone = drones[2];
    drones[2].currentBay = 3;

    hangar.bays[3].assignedDrone = drones[3];
    drones[3].currentBay = 4;

    // Leave others unassigned (testing empty bays)

    // --- Status Distribution ---
    drones[0].status = Status.available;
    drones[1].status = Status.flying;
    drones[2].status = Status.charging;
    drones[3].status = Status.maintenance;

    drones[4].status = Status.available;
    drones[5].status = Status.flying;
    drones[6].status = Status.charging;
    drones[7].status = Status.available;

    // --- Battery Levels (for "Low Battery" card) ---
    drones[0].battery = 85;
    drones[1].battery = 60;
    drones[2].battery = 25;
    drones[3].battery = 15; // low battery
    drones[4].battery = 90;
    drones[5].battery = 18; // low battery
    drones[6].battery = 40;
    drones[7].battery = 10; // low battery
  }

}