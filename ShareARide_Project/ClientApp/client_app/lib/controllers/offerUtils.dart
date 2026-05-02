import 'dart:convert';
// import 'package:client_app/entity/offerStatus.dart';
import 'package:http/http.dart' as http;
// import '../entity/user.dart';
import '../entity/offer.dart';

import 'utils.dart';

class OfferUtils {
  static Future<List<Offer>> getOffers() async {
    final url = Uri.parse('http://${Utils().ip}:5205/api/offers');

    try {
      final response = await http.get(url).timeout(const Duration(seconds: 5));

      if (response.statusCode == 200) {
        var offers = jsonDecode(response.body);
        var offersList = (offers as List)
            .map((offer) => Offer.fromJson(offer))
            .toList();
        return offersList;
      }
    } catch (e) {
      print("API unreachable: $e");
      return [];
    }
    return [];
  }

  static Future<List<Offer>> getOtherOffers(int id) async {
    final url = Uri.parse(
      'http://${Utils().ip}:5205/api/offers/other_offers/$id',
    );

    try {
      final response = await http.get(url).timeout(const Duration(seconds: 5));

      if (response.statusCode == 200) {
        var offers = jsonDecode(response.body);
        var offersList = (offers as List)
            .map((offer) => Offer.fromJson(offer))
            .toList();
        return offersList;
      }
    } catch (e) {
      print("API unreachable: $e");
      return [];
    }
    return [];
  }

  static Future<List<Offer>> getMyOffers(int id) async {
    final url = Uri.parse('http://${Utils().ip}:5205/api/offers/my_offers/$id');

    try {
      final response = await http.get(url).timeout(const Duration(seconds: 5));

      if (response.statusCode == 200) {
        var offers = jsonDecode(response.body);
        var offersList = (offers as List)
            .map((offer) => Offer.fromJson(offer))
            .toList();
        return offersList;
      }
    } catch (e) {
      print("API unreachable: $e");
      return [];
    }
    return [];
  }

  static Future<Offer?> getOffer(int id) async {
    final url = Uri.parse('http://${Utils().ip}:5205/api/offers/$id');

    try {
      final response = await http.get(url).timeout(const Duration(seconds: 5));

      if (response.statusCode == 200) {
        var offer = jsonDecode(response.body);
        return Offer.fromJson(offer);
      }
    } catch (e) {
      print("API unreachable: $e");
      return null;
    }
    return null;
  }

  static Future<Offer?> createOffer(
  int driverId,
  int vehicleId,
  String departureTime,
  int departureCityId,
  int destinationCityId,
  double pricePerSeat,
  int availableSeats,
) async {
  final url = Uri.parse('http://${Utils().ip}:5205/api/offers/create');

  try {
    final response = await http
        .post(
          url,
          headers: {
            "Content-Type": "application/json",
            "Accept": "application/json",
          },
          body: jsonEncode({
            "driverId": driverId,
            "vehicleId": vehicleId,
            "departureTime": departureTime,
            "departureCityId": departureCityId,
            "destinationCityId": destinationCityId,
            "pricePerSeat": pricePerSeat,
            "availableSeats": availableSeats,
          }),
        )
        .timeout(const Duration(seconds: 5));

    if (response.statusCode == 200 || response.statusCode == 201) {
      final decoded = jsonDecode(response.body);
      final offer = Offer.fromJson(decoded);

      print('Offer created successfully!');
      print(offer);

      return offer;
    } else {
      print('Create offer failed: ${response.statusCode}');
      print(response.body);
      return null;
    }
  } catch (e) {
    print('Create offer error: $e');
    return null;
  }
}

static Future<bool> updateOffer({
  required int offerId,
  required int vehicleId,
  required String departureTime,
  required int departureCityId,
  required int destinationCityId,
  required double pricePerSeat,
  required int availableSeats,
}) async {
  final url = Uri.parse('http://${Utils().ip}:5205/api/offers/update');

  try {
    final response = await http
        .put(
          url,
          headers: {
            "Content-Type": "application/json",
            "Accept": "application/json",
          },
          body: jsonEncode({
            "offerId": offerId,
            "vehicleId": vehicleId,
            "departureTime": departureTime,
            "departureCityId": departureCityId,
            "destinationCityId": destinationCityId,
            "pricePerSeat": pricePerSeat,
            "availableSeats": availableSeats,
          }),
        )
        .timeout(const Duration(seconds: 5));

    if (response.statusCode == 200) {
      print("Offer updated successfully!");
      return true;
    } else {
      print("Update offer failed: ${response.statusCode}");
      print(response.body);
      return false;
    }
  } catch (e) {
    print("Update offer error: $e");
    return false;
  }
}

  static Future<bool> updateOfferVehicle(int offerId, int newVehicleId) async {
    final url = Uri.parse(
      'http://${Utils().ip}:5205/api/offers/update_vehicle',
    );
    try {
      final response = await http
          .put(
            url,
            headers: {"Content-Type": "application/json"},
            body: jsonEncode({"offerId": offerId, "vehicleId": newVehicleId}),
          )
          .timeout(const Duration(seconds: 5));

      return response.statusCode == 200;
    } catch (e) {
      print("Update Error: $e");
      return false;
    }
  }
}
