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
        print("API is reachable!");
        print(response.body);
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
        })
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        // print("Offer created successfully!");
        // var offer = jsonDecode(response.body);
        // var offer = Offer(
         
        // );

        // print(
        //   'Login Success! Welcome ${userData['username']} - ${userData['firstName']} - ${userData['lastName']}',
        // );
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
}
