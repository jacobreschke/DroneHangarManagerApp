enum Status {
  available,
  flying,
  charging,
  maintenance
}

abstract class Drone {
  int id;
  int year;
  String type;
  String manufacturer;
  String model;
  Status status = Status.available;
  double battery = 100.0;
  double totalFlightHours = 0.0;

  Drone(this.id, this.year, this.type, this.manufacturer, this.model);

}

class StandardDrone extends Drone {
  StandardDrone(
      super.id,
      super.year,
      super.type,
      super.manufacturer,
      super.model
      );

}

class PriorityDrone extends Drone {
  PriorityDrone(
      super.id,
      super.year,
      super.type,
      super.manufacturer,
      super.model
      );

}