import 'dart:convert';
import 'package:client_app/entity/offerStatus.dart';
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
        // print("API is reachable!");
        // print(response.body);
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

  static Future<Offer> getOffer(int id) async {
    final url = Uri.parse('http://${Utils().ip}:5205/api/offers/$id');

    try {
      final response = await http.get(url).timeout(const Duration(seconds: 5));

      if (response.statusCode == 200) {
        // print("API is reachable!");
        // print(response.body);
        var offer = jsonDecode(response.body);
        return Offer.fromJson(offer);
      }
    } catch (e) {
      print("API unreachable: $e");
      return Offer(
        id: id,
        driverId: 0,
        vehicleId: 0,
        departureTime: DateTime.now(),
        departureCityId: 0,
        destinationCityId: 0,
        pricePerSeat: 0.0,
        status: OfferStatus.Active,
      );
    }
    return Offer(
      id: id,
      driverId: 0,
      vehicleId: 0,
      departureTime: DateTime.now(),
      departureCityId: 0,
      destinationCityId: 0,
      pricePerSeat: 0.0,
      status: OfferStatus.Active,
    );
  }

  static Future<bool> createOffer(
    int driverId,
    int vehicleId,
    String departureTime,
    int departureCityId,
    int destinationCityId,
    double pricePerSeat,
  ) async {
    final url = Uri.parse('http://${Utils().ip}:5205/api/offers/create');

    try {
      final response = await http.post(
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
        }),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        print('Offer created successfully!');
        return true;
        // TODO: Save userData['id'] to SharedPreferences here
      } else if (response.statusCode == 401) {
        print('Error: Invalid credentials');
        return false;
      } else {
        print('Server Error: ${response.statusCode}');
        return false;
      }
    } catch (e) {
      print('Connection Error: $e');
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
