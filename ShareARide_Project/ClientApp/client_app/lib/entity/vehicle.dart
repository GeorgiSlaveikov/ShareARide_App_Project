import '../entity/vehicleMake.dart';

class Vehicle {
  int? id;
  VehicleMake make;
  String model;
  int year;
  int maxCapacity;
  int ownerId;

  Vehicle({
    this.id,
    required this.make,
    required this.model,
    required this.year,
    required this.maxCapacity,
    required this.ownerId,
  });

  factory Vehicle.fromJson(Map<String, dynamic> json) {
    return Vehicle(
      id: json['id'],
      make: parseMake(json['make']?.toString() ?? "0"),
      model: json['model'] ?? 'Unknown',
      year: json['year'] ?? 0,
      maxCapacity: json['maxCapacity'] ?? 0,
      ownerId: json['ownerId'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'make': make.name,
      'model': model,
      'year': year,
      'maxCapacity': maxCapacity,
      'ownerId': ownerId,
    };
  }

  static VehicleMake parseMake(String makeId) {
    VehicleMake make;
    switch (makeId) {
      case "0":
        make = VehicleMake.Unknown;
        break;
      case "1":
        make = VehicleMake.Toyota;
        break;
      case "2":
        make = VehicleMake.Honda;
        break;
      case "3":
        make = VehicleMake.Ford;
        break;
      case "4":
        make = VehicleMake.Chevrolet;
        break;
      case "5":
        make = VehicleMake.Nissan;
        break;
      case "6":
        make = VehicleMake.BMW;
        break;
      case "7":
        make = VehicleMake.MercedesBenz;
        break;
      case "8":
        make = VehicleMake.Audi;
        break;
      case "9":
        make = VehicleMake.Volkswagen;
        break;
      case "10":
        make = VehicleMake.Hyundai;
        break;
      case "11":
        make = VehicleMake.Kia;
        break;
      case "12":
        make = VehicleMake.Subaru;
        break;
      case "13":
        make = VehicleMake.Mazda;
        break;
      case "14":
        make = VehicleMake.Tesla;
        break;
      case "15":
        make = VehicleMake.Jeep;
        break;
      case "16":
        make = VehicleMake.Dodge;
        break;
      case "17":
        make = VehicleMake.Lexus;
        break;
      case "18":
        make = VehicleMake.GMC;
        break;
      case "19":
        make = VehicleMake.Volvo;
        break;
      case "20":
        make = VehicleMake.Porsche;
        break;
      case "21":
        make = VehicleMake.Jaguar;
        break;
      case "22":
        make = VehicleMake.LandRover;
        break;
      case "23":
        make = VehicleMake.Mitsubishi;
        break;
      case "24":
        make = VehicleMake.Fiat;
        break;
      case "25":
        make = VehicleMake.AlfaRomeo;
        break;

      default:
        make = VehicleMake.Unknown; // Default or throw an error
    }
    return make;
  }

  @override
  String toString() {
    return 'Make: $make\nModel: $model\nYear: $year\nMax Capacity: $maxCapacity\nOwner ID: $ownerId';
  }
}
