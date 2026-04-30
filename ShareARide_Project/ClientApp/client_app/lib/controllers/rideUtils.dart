class RideUtils {
  static Future<List<Map<String, dynamic>>> getRidesForUser(int currentUserId) async {
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
        "departureTime": now.add(const Duration(days: 1, hours: 2)).toIso8601String(),
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
        "departureTime": now.subtract(const Duration(days: 10)).toIso8601String(),
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
        "departureTime": now.subtract(const Duration(days: 30)).toIso8601String(),
        "pricePerSeat": 25.0,
        "passengersCount": 2,
        "vehicle": "Audi A4 (Blue)",
        "status": "Completed",
      },
    ];
  }
}