import 'package:client_app/entity/offerStatus.dart';
// import 'package:client_app/entity/vehicleMake.dart';
// import '../entity/vehicle.dart';

class Offer {
  int? id;
  int driverId;
  String driverName;
  int driverAge;
  int vehicleId;
  String vehicleMake;
  String vehicleModel;
  int vehicleYear;
  DateTime departureTime;
  String departureCityName;
  String destinationCityName;
  double pricePerSeat;
  int availableSeats;
  DateTime? createdAt;
  DateTime? expiresOn;
  OfferStatus status;

  Offer({
    this.id,
    required this.driverId,
    required this.driverName,
    required this.driverAge,
    required this.vehicleId,
    required this.vehicleMake,
    required this.vehicleModel,
    required this.vehicleYear,
    required this.departureTime,
    required this.departureCityName,
    required this.destinationCityName,
    required this.pricePerSeat,
    required this.availableSeats,
    this.createdAt,
    this.expiresOn,
    required this.status,
  });

  factory Offer.fromJson(Map<String, dynamic> json) {
    return Offer(
      id: json['id'],
      driverId: json['driverId'] ?? 0,
      driverName: json['driverName'] ?? '',
      driverAge: json['driverAge'] ?? 18,
      vehicleId: json['vehicleId'] ?? 0,
      vehicleMake: json['vehicleMake'] ?? '',
      vehicleModel: json['vehicleModel'] ?? '',
      vehicleYear: json['vehicleYear'] ?? 0,
      departureTime: DateTime.parse(json['departureTime']),
      departureCityName: json['departureCityName'] ?? '',
      destinationCityName: json['destinationCityName'] ?? '',
      pricePerSeat: json['pricePerSeat']?.toDouble() ?? 0.0,
      availableSeats: json['availableSeats'] ?? 0,
      createdAt: DateTime.parse(json['createdAt']),
      expiresOn: DateTime.parse(json['expiresOn']),
      status: parseOfferStatus(json['offerStatus'].toString())
    );
  }

  Map<String, dynamic> toJson() {
    // return {
    //   'id': id,
    //   'driverId': driverId,
    //   'vehicleId': vehicleId,
    //   'departureTime': departureTime.toIso8601String(),
    //   'departureCityId': departureCityId,
    //   'destinationCityId': destinationCityId,
    //   'pricePerSeat': pricePerSeat,
    //   'createdAt': createdAt?.toIso8601String(),
    //   'expiresOn': expiresOn?.toIso8601String(),
    //   'status': 0,
    // };

    return {
      'id': id,
      'driverName': driverName,
      'vehicleId': vehicleId,
      'departureTime': departureTime.toIso8601String(),
      'departureCityId': departureCityName,
      'destinationCityId': destinationCityName,
      'pricePerSeat': pricePerSeat,
      'createdAt': createdAt?.toIso8601String(),
      'expiresOn': expiresOn?.toIso8601String(),
      'status': 0,
    };
  }

  static OfferStatus parseOfferStatus(String statusOfferId) {
    OfferStatus offerStatus;
    switch (statusOfferId) {
      case "0":
        offerStatus = OfferStatus.Active;
        break;
      case "1":
        offerStatus = OfferStatus.Full;
        break;
      case "2":
        offerStatus = OfferStatus.Cancelled;
        break;
      default:
        offerStatus = OfferStatus.Active; 
    }
    return offerStatus;
  }

  @override
  String toString() {
    return 'Driver ID: $driverId\nVehicle ID: $vehicleId\nDeparture Time: $departureTime';
  }
}
