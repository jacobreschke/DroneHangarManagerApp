enum Status { available, flying, charging, maintenance }

abstract class Drone {
  String _name;
  final int _id;
  final int _year;
  final String _type;
  final String _manufacturer;
  final String _model;
  Status _status = Status.available;
  int _battery = 100;
  double _totalFlightHours = 0.0;

  Drone(
    this._name,
    this._id,
    this._type,
    this._year,
    this._manufacturer,
    this._model,
  );

  @override
  String toString() {
    return '$_name $_manufacturer $_model ($_year) - $_status';
  }

  String getName() {
    return _name;
  }

  int getId() {
    return _id;
  }

  int getYear() {
    return _year;
  }

  String getType() {
    return _type;
  }

  String getManufacturer() {
    return _manufacturer;
  }

  String getModel() {
    return _model;
  }

  Status getStatus() {
    return _status;
  }

  int getBattery() {
    return _battery;
  }

  double getTotalFlightHours() {
    return _totalFlightHours;
  }
}

class StandardDrone extends Drone {
  StandardDrone(
    super._name,
    super._id,
    super._type,
    super._year,
    super._manufacturer,
    super._model,
  );
}

class PriorityDrone extends Drone {
  PriorityDrone(
    super._name,
    super._id,
    super._type,
    super._year,
    super._manufacturer,
    super._model,
  );
}
