import 'dart:convert';
import 'package:http/http.dart' as http;
import '../entity/ride.dart';
import 'utils.dart';

class RideUtils {
  static Future<List<Map<String, dynamic>>> getRidesForUser_Dummy(
    int currentUserId,
  ) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 800));

    final now = DateTime.now();

    return [
      // 1. UPCOMING RIDE - AS DRIVER
      {
        "id": 101,
        "driverId": currentUserId, // You are the driver
        "driverName": "You",
        "departureCity": "Sofia",
        "destinationCity": "Plovdiv",
        "departureTime": now
            .add(const Duration(days: 1, hours: 2))
            .toIso8601String(),
        "pricePerSeat": 15.0,
        "passengersCount": 2,
        "vehicle": "Tesla Model 3 (Black)",
        "status": "Open",
      },
      // 2. UPCOMING RIDE - AS PASSENGER
      {
        "id": 102,
        "driverId": 999, // Someone else is driving
        "driverName": "Ivan Ivanov",
        "departureCity": "Varna",
        "destinationCity": "Burgas",
        "departureTime": now.add(const Duration(days: 3)).toIso8601String(),
        "pricePerSeat": 12.50,
        "passengersCount": 3,
        "vehicle": "VW Golf 7 (Silver)",
        "status": "Open",
      },
      // 3. PAST RIDE - AS DRIVER
      {
        "id": 88,
        "driverId": currentUserId, // You were the driver
        "driverName": "You",
        "departureCity": "Plovdiv",
        "destinationCity": "Stara Zagora",
        "departureTime": now
            .subtract(const Duration(days: 10))
            .toIso8601String(),
        "pricePerSeat": 10.0,
        "passengersCount": 4,
        "vehicle": "Tesla Model 3 (Black)",
        "status": "Completed",
      },
      // 4. PAST RIDE - AS PASSENGER
      {
        "id": 75,
        "driverId": 888, // Someone else drove
        "driverName": "Maria Petrova",
        "departureCity": "Ruse",
        "destinationCity": "Sofia",
        "departureTime": now
            .subtract(const Duration(days: 30))
            .toIso8601String(),
        "pricePerSeat": 25.0,
        "passengersCount": 2,
        "vehicle": "Audi A4 (Blue)",
        "status": "Completed",
      },
    ];
  }

  static Future<List<Ride>> getRides() async {
    final url = Uri.parse('http://${Utils().ip}:5205/api/rides');

    try {
      final response = await http.get(url).timeout(const Duration(seconds: 5));

      if (response.statusCode == 200) {
        final rides = jsonDecode(response.body);

        return (rides as List).map((ride) => Ride.fromJson(ride)).toList();
      } else {
        print('Get rides failed: ${response.statusCode}');
        print(response.body);
        return [];
      }
    } catch (e) {
      print('Get rides error: $e');
      return [];
    }
  }

  static Future<Ride?> getRide(int id) async {
    final url = Uri.parse('http://${Utils().ip}:5205/api/rides/$id');

    try {
      final response = await http.get(url).timeout(const Duration(seconds: 5));

      if (response.statusCode == 200) {
        final ride = jsonDecode(response.body);
        return Ride.fromJson(ride);
      } else {
        print('Get ride failed: ${response.statusCode}');
        print(response.body);
        return null;
      }
    } catch (e) {
      print('Get ride error: $e');
      return null;
    }
  }

  static Future<bool> createRide(int offerId, int driverId) async {
    final url = Uri.parse('http://${Utils().ip}:5205/api/rides/create');

    try {
      final response = await http
          .post(
            url,
            headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
            },
            body: jsonEncode({'driverId': driverId, 'offerId': offerId}),
          )
          .timeout(const Duration(seconds: 5));

      if (response.statusCode == 200 || response.statusCode == 201) {
        print('Ride created successfully!');
        return true;
      } else {
        print('Create ride failed: ${response.statusCode}');
        print(response.body);
        return false;
      }
    } catch (e) {
      print('Create ride error: $e');
      return false;
    }
  }

  static Future<List<Map<String, dynamic>>> getRidesForUser(int userId) async {
    final url = Uri.parse(
      'http://${Utils().ip}:5205/api/rides/related_to_user/$userId',
    );

    try {
      final response = await http.get(url).timeout(const Duration(seconds: 5));

      if (response.statusCode == 200) {
        final rides = jsonDecode(response.body);

        return (rides as List).map<Map<String, dynamic>>((ride) {
          return {
            "id": ride["id"],
            "offerId": ride["offerId"],

            "departureCity": ride["departureCityName"],
            "destinationCity": ride["destinationCityName"],
            "departureTime": ride["departureTime"],

            "driverId": ride["driverId"],
            "driverName": ride["driverName"],

            "status": ride["status"],
            "availableSeats": ride["availableSeats"],
            "passengersCount": ride["passengersCount"],

            "vehicleId": ride["vehicleId"],
            "vehicle":
                "${ride["vehicleMake"]} ${ride["vehicleModel"]} (${ride["vehicleYear"]})",

            "vehicleMake": ride["vehicleMake"],
            "vehicleModel": ride["vehicleModel"],
            "vehicleYear": ride["vehicleYear"],

            "pricePerSeat": ride["pricePerSeat"] ?? 0,
            "databaseBookings": ride["databaseBookings"] ?? [],
          };
        }).toList();
      } else {
        print("Get rides for user failed: ${response.statusCode}");
        print(response.body);
        return [];
      }
    } catch (e) {
      print("Get rides for user error: $e");
      return [];
    }
  }

  static Future<bool> cancelRide(int rideId) async {
    final url = Uri.parse('http://${Utils().ip}:5205/api/rides/$rideId/cancel');

    try {
      final response = await http
          .put(
            url,
            headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
            },
          )
          .timeout(const Duration(seconds: 5));

      if (response.statusCode == 200) {
        print("Ride cancelled successfully.");
        return true;
      }

      print("Cancel ride failed: ${response.statusCode}");
      print(response.body);
      return false;
    } catch (e) {
      print("Cancel ride error: $e");
      return false;
    }
  }

  static Future<bool> finishRide(int rideId) async {
    final url = Uri.parse('http://${Utils().ip}:5205/api/rides/$rideId/finish');

    try {
      final response = await http
          .put(
            url,
            headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
            },
          )
          .timeout(const Duration(seconds: 5));

      if (response.statusCode == 200) {
        print("Ride finished successfully.");
        return true;
      }

      print("Finish ride failed: ${response.statusCode}");
      print(response.body);
      return false;
    } catch (e) {
      print("Finish ride error: $e");
      return false;
    }
  }
}
