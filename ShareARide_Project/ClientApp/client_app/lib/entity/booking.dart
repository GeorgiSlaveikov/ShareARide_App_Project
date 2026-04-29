// import 'package:client_app/entity/offer.dart';
// import 'package:client_app/entity/user.dart';
// import '../controllers/userUtils.dart';
// import '../controllers/offerUtils.dart';
import 'bookingStatus.dart';

class Booking {
  final int? id;
  final String driverName;
  final int requestedForId;
  final String requestedForName;
  final int requesterId;
  final String requesterName;
  final int offerId;
  final int bookedSeats;
  final double pricePerSeat;
  final double totalPrice;
  final String departureCityName;
  final String destinationCityName;
  final BookingStatus? status;
  final DateTime createdAt;
  final DateTime departureTime;

  Booking({
    this.id,
    required this.requestedForId,
    required this.requestedForName,
    required this.requesterId,
    required this.requesterName,
    required this.offerId,
    required this.pricePerSeat,
    required this.totalPrice,
    required this.bookedSeats,
    required this.departureTime,
    required this.createdAt,
    required this.departureCityName,
    required this.destinationCityName,
    required this.driverName,
    this.status,
  });

  // Method to convert the object to a Map for the POST request body
  Map<String, dynamic> toJson() {
    return {
      'RequestedForId': requestedForId,
      'RequesterId': requesterId,
      'OfferId': offerId,
    };
  }

  // Factory to create an object from API response
  factory Booking.fromJson(Map<String, dynamic> json) {
    return Booking(
      id: json['id'],
      offerId: json['offerId'] ?? 0,
      requesterId: json['requesterId'] ?? 0,
      requesterName: json['requesterName'] ?? "Unknown",
      requestedForId: json['requestedForId'] ?? 0,
      requestedForName: json['requestedForName'] ?? "Unknown",
      bookedSeats: json['bookedSeats'] ?? 0,
      pricePerSeat: (json['pricePerSeat'] ?? 0).toDouble(),
      totalPrice: (json['totalPrice'] ?? 0).toDouble(),
      departureTime: DateTime.parse(json['departureTime'] ?? DateTime.now().toString()),
      createdAt: DateTime.parse(json['createdAt'] ?? DateTime.now().toString()),
      departureCityName: json['departureCityName'] ?? "Unknown", 
      destinationCityName: json['destinationCityName'] ?? "Unknown",
      driverName: json['driverName'] ?? "Unknown",
      status: parseStatus(json['status']?.toString() ?? "0"),
    );
  }

  static BookingStatus parseStatus(String statusId) {
    BookingStatus status;
    switch (statusId) {
      case "0":
        status = BookingStatus.Pending;
        break;
      case "1":
        status = BookingStatus.Accepted;
        break;
      case "2":
        status = BookingStatus.Rejected;
        break;
      default:
        status = BookingStatus.Pending; // Default or throw an error
    }
    return status;
  }
}
