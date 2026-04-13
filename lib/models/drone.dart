enum Status { available, flying, charging, maintenance }

abstract class Drone {
  String name;
  final int id;
  final int year;
  final String type;
  final String manufacturer;
  final String model;
  int currentBay = 0;
  Status status = Status.available;
  int battery = 100;
  double totalFlightHours = 0.0;

  Drone(
    this.name,
    this.id,
    this.type,
    this.year,
    this.manufacturer,
    this.model,
  );



  @override
  String toString() {
    return '$name $manufacturer $model $year - $status';
  }

}

class StandardDrone extends Drone {
  StandardDrone(
    super.name,
    super.id,
    super.type,
    super.year,
    super.manufacturer,
    super.model,
  );
}

class PriorityDrone extends Drone {
  PriorityDrone(
    super.name,
    super.id,
    super.type,
    super.year,
    super.manufacturer,
    super.model,
  );
}
