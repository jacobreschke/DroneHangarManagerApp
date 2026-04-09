enum Status { available, flying, charging, maintenance }

abstract class Drone {
  int id;
  int year;
  String type;
  String manufacturer;
  String model;
  Status status = Status.available;
  double battery = 100.0;
  double totalFlightHours = 0.0;

  Drone(this.id, this.type, this.year, this.manufacturer, this.model);

  @override
  String toString() {
    return '$manufacturer $model ($year) - $status';
  }
}

class StandardDrone extends Drone {
  StandardDrone(
    super.id,
    super.type,
    super.year,
    super.manufacturer,
    super.model,
  );
}

class PriorityDrone extends Drone {
  PriorityDrone(
    super.id,
    super.year,
    super.type,
    super.manufacturer,
    super.model,
  );
}
