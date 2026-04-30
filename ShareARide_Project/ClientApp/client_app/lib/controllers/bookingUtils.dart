import '../entity/booking.dart';
import 'utils.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class BookingUtils {
  static Future<List<Booking>> getBookings() async {
    final url = Uri.parse('http://${Utils().ip}:5205/api/bookings');

    try {
      final response = await http.get(url).timeout(const Duration(seconds: 5));

      if (response.statusCode == 200) {
        var bookings = jsonDecode(response.body);
        var bookingsList = (bookings as List)
            .map((booking) => Booking.fromJson(booking))
            .toList();
        return bookingsList;
      }
    } catch (e) {
      print("API unreachable: $e");
      return [];
    }
    return [];
  }

  static Future<Booking?> getBooking(int id) async {
    final url = Uri.parse('http://${Utils().ip}:5205/api/bookings/$id');

    try {
      final response = await http.get(url).timeout(const Duration(seconds: 5));

      if (response.statusCode == 200) {
        var booking = jsonDecode(response.body);
        return Booking.fromJson(booking);
      }
    } catch (e) {
      print("API unreachable: $e");
      return null;
    }
    return null;
  }

  static Future<List<Booking>> getBookingsForMe(int id) async {
    final url = Uri.parse(
      'http://${Utils().ip}:5205/api/bookings/requests_for_user/$id',
    );

    try {
      final response = await http.get(url).timeout(const Duration(seconds: 5));

      if (response.statusCode == 200 || response.statusCode == 201) {
        print("RAW JSON FROM API: ${response.body}");
        var bookings = jsonDecode(response.body);
        var bookingsList = (bookings as List)
            .map((booking) => Booking.fromJson(booking))
            .toList();
        return bookingsList;
      }
    } catch (e) {
      print("API unreachable: $e");
      return [];
    }
    return [];
  }

  static Future<List<Booking>> getBookingsFromMe(int id) async {
    final url = Uri.parse(
      'http://${Utils().ip}:5205/api/bookings/requests_from_user/$id',
    );

    try {
      final response = await http.get(url).timeout(const Duration(seconds: 5));

      if (response.statusCode == 200 || response.statusCode == 201) {
        // print("Offers for me");
        // print(response.body);
        var bookings = jsonDecode(response.body);
        var bookingsList = (bookings as List)
            .map((booking) => Booking.fromJson(booking))
            .toList();
        return bookingsList;
      }
    } catch (e) {
      print("API unreachable: $e");
      return [];
    }
    return [];
  }

  static Future<bool> createBooking(
    int requestedForId,
    int requesterId,
    int offerId
  ) async {
    final url = Uri.parse('http://${Utils().ip}:5205/api/bookings/create');

    try {
      final response = await http.post(
        url,
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
        },
        body: jsonEncode({
          "requestedForId": requestedForId,
          "requesterId": requesterId,
          "offerId": offerId
        }),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return true;
      } else {
        print('Server Error: ${response.statusCode}');
        return false;
      }
    } catch (e) {
      print('Connection Error: $e');
      return false;
    }
  }
}
