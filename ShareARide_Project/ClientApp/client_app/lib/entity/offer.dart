import 'package:client_app/entity/offerStatus.dart';

class Offer {
  int? id;
  int driverId;
  int vehicleId;
  DateTime departureTime;
  int departureCityId;
  int destinationCityId;
  double pricePerSeat;
  DateTime? createdAt;
  DateTime? expiresOn;
  OfferStatus status;

  // Standard Constructor
  Offer({
    this.id,
    required this.driverId,
    required this.vehicleId,
    required this.departureTime,
    required this.departureCityId,
    required this.destinationCityId,
    required this.pricePerSeat,
    this.createdAt,
    this.expiresOn,
    required this.status,
  });

  // 1. Factory constructor to create a User from a JSON Map
  // This is what you use when receiving data from the .NET API
  factory Offer.fromJson(Map<String, dynamic> json) {
    return Offer(
      id: json['id'],
      driverId: json['driverId'] ?? 0,
      vehicleId: json['vehicleId'] ?? 0,
      departureTime: DateTime.parse(json['departureTime']),
      departureCityId: json['departureCityId'] ?? 0,
      destinationCityId: json['destinationCityId'] ?? 0,
      pricePerSeat: json['pricePerSeat']?.toDouble() ?? 0.0,
      createdAt: DateTime.parse(json['createdAt']),
      expiresOn: DateTime.parse(json['expiresOn']),
      status: OfferStatus.Active
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'driverId': driverId,
      'vehicleId': vehicleId,
      'departureTime': departureTime.toIso8601String(),
      'departureCityId': departureCityId,
      'destinationCityId': destinationCityId,
      'pricePerSeat': pricePerSeat,
      'createdAt': createdAt?.toIso8601String(),
      'expiresOn': expiresOn?.toIso8601String(),
      'status': 0,
    };
  }

  @override
  String toString() {
    return 'Driver ID: $driverId\nVehicle ID: $vehicleId\nDeparture Time: $departureTime';
  }
}
