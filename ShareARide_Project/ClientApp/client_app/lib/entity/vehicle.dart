import '../entity/vehicleMake.dart';

class Vehicle {
  int? id;
  VehicleMake make;
  String model;
  int year;
  int maxCapacity;
  int ownerId;
  String? vehiclePicturePath;
  bool isDeleted;

  Vehicle({
    this.id,
    required this.make,
    required this.model,
    required this.year,
    required this.maxCapacity,
    required this.ownerId,
    this.vehiclePicturePath,
    this.isDeleted = false,
  });

  factory Vehicle.fromJson(Map<String, dynamic> json) {
    return Vehicle(
      id: json['id'],
      make: parseMake(json['make']?.toString() ?? "0"),
      model: json['model'] ?? 'Unknown',
      year: json['year'] ?? 0,
      maxCapacity: json['maxCapacity'] ?? 0,
      ownerId: json['ownerId'] ?? 0,
      vehiclePicturePath: json['vehiclePicturePath'],
      isDeleted: json['isDeleted'] ?? false,
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
      'vehiclePicturePath': vehiclePicturePath,
      'isDeleted': isDeleted,
    };
  }

  static VehicleMake parseMake(String makeId) {
    switch (makeId) {
      case "0":
        return VehicleMake.Unknown;
      case "1":
        return VehicleMake.Toyota;
      case "2":
        return VehicleMake.Honda;
      case "3":
        return VehicleMake.Ford;
      case "4":
        return VehicleMake.Chevrolet;
      case "5":
        return VehicleMake.Nissan;
      case "6":
        return VehicleMake.BMW;
      case "7":
        return VehicleMake.MercedesBenz;
      case "8":
        return VehicleMake.Audi;
      case "9":
        return VehicleMake.Volkswagen;
      case "10":
        return VehicleMake.Hyundai;
      case "11":
        return VehicleMake.Kia;
      case "12":
        return VehicleMake.Subaru;
      case "13":
        return VehicleMake.Mazda;
      case "14":
        return VehicleMake.Tesla;
      case "15":
        return VehicleMake.Jeep;
      case "16":
        return VehicleMake.Dodge;
      case "17":
        return VehicleMake.Lexus;
      case "18":
        return VehicleMake.GMC;
      case "19":
        return VehicleMake.Volvo;
      case "20":
        return VehicleMake.Porsche;
      case "21":
        return VehicleMake.Jaguar;
      case "22":
        return VehicleMake.LandRover;
      case "23":
        return VehicleMake.Mitsubishi;
      case "24":
        return VehicleMake.Fiat;
      case "25":
        return VehicleMake.AlfaRomeo;
      default:
        return VehicleMake.Unknown;
    }
  }
}