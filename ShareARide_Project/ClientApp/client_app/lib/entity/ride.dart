import 'package:client_app/entity/rideStatus.dart';

class Ride {
  int? id;
  int offerId;

  String departureCityName;
  String destinationCityName;
  DateTime departureTime;

  int driverId;
  String driverName;

  RideStatus status;

  int availableSeats;
  int passengersCount;

  int vehicleId;
  String vehicleMake;
  String vehicleModel;
  int vehicleYear;

  Ride({
    this.id,
    required this.offerId,
    required this.departureCityName,
    required this.destinationCityName,
    required this.departureTime,
    required this.driverId,
    required this.driverName,
    required this.status,
    required this.availableSeats,
    required this.passengersCount,
    required this.vehicleId,
    required this.vehicleMake,
    required this.vehicleModel,
    required this.vehicleYear,
  });

  factory Ride.fromJson(Map<String, dynamic> json) {
    return Ride(
      id: json['id'],
      offerId: json['offerId'] ?? 0,

      departureCityName: json['departureCityName'] ?? '',
      destinationCityName: json['destinationCityName'] ?? '',
      departureTime: DateTime.parse(json['departureTime']),

      driverId: json['driverId'] ?? 0,
      driverName: json['driverName'] ?? '',

      status: parseRideStatus((json['status'] ?? 0).toString()),

      availableSeats: json['availableSeats'] ?? 0,
      passengersCount: json['passengersCount'] ?? 0,

      vehicleId: json['vehicleId'] ?? 0,
      vehicleMake: json['vehicleMake'] ?? '',
      vehicleModel: json['vehicleModel'] ?? '',
      vehicleYear: json['vehicleYear'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'offerId': offerId,
      'departureCityName': departureCityName,
      'destinationCityName': destinationCityName,
      'departureTime': departureTime.toIso8601String(),
      'driverId': driverId,
      'driverName': driverName,
      'status': status.index,
      'availableSeats': availableSeats,
      'passengersCount': passengersCount,
      'vehicleId': vehicleId,
      'vehicleMake': vehicleMake,
      'vehicleModel': vehicleModel,
      'vehicleYear': vehicleYear,
    };
  }

  static RideStatus parseRideStatus(String value) {
    switch (value) {
      case "0":
      case "Open":
        return RideStatus.Open;

      case "1":
      case "Not Started":
        return RideStatus.NotStarted;

      case "2":
      case "In Progress":
        return RideStatus.InProgress;

      case "3":
      case "Finished":
        return RideStatus.Finished;

      case "4":
      case "Cancelled":
        return RideStatus.Cancelled;

      default:
        return RideStatus.Open;
    }
  }

  @override
  String toString() {
    return '$departureCityName → $destinationCityName\n'
        'Driver: $driverName\n'
        'Vehicle: $vehicleMake $vehicleModel ($vehicleYear)\n'
        'Passengers: $passengersCount\n'
        'Status: $status';
  }
}
