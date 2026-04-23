// import 'package:client_app/entity/offer.dart';
// import 'package:client_app/entity/user.dart';
// import '../controllers/userUtils.dart';
// import '../controllers/offerUtils.dart';
import 'bookingStatus.dart';

class Booking {
  final int? id;
  final int requestedForId;
  final int requestorId;
  final int offerId;
  final List<String> passengers;
  final BookingStatus? status;

  Booking({
    this.id,
    required this.requestedForId,
    required this.requestorId,
    required this.offerId,
    required this.passengers,
    this.status,
  });

  // Method to convert the object to a Map for the POST request body
  Map<String, dynamic> toJson() {
    return {
      'RequestedForId': requestedForId,
      'RequestorId': requestorId,
      'OfferId': offerId,
      'passengers': passengers,
      // Status is usually handled by the backend on creation,
      // but you can add it here if your API expects it.
    };
  }

  // Factory to create an object from API response
  factory Booking.fromJson(Map<String, dynamic> json) {
    return Booking(
      id: json['id'],
      offerId: json['offerId'] ?? 0,
      requestorId: json['requestorId'] ?? 0,
      requestedForId: json['requestedForId'] ?? 0,
      passengers: List<String>.from(json['passengersNames'] ?? []),
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
