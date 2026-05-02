import 'dart:convert';
import 'package:http/http.dart' as http;

import '../entity/rating.dart';
import 'utils.dart';

class RatingUtils {
  static Future<bool> createRating({
    required int ratedUserId,
    required int ratedByUserId,
    required int rideId,
    required int score,
    String? comment,
  }) async {
    final url = Uri.parse('http://${Utils().ip}:5205/api/ratings/create');

    try {
      final response = await http
          .post(
            url,
            headers: {
              "Content-Type": "application/json",
              "Accept": "application/json",
            },
            body: jsonEncode({
              "ratedUserId": ratedUserId,
              "ratedByUserId": ratedByUserId,
              "rideId": rideId,
              "score": score,
              "comment": comment,
            }),
          )
          .timeout(const Duration(seconds: 5));

      if (response.statusCode == 200 || response.statusCode == 201) {
        return true;
      }

      print("Create rating failed: ${response.statusCode}");
      print(response.body);
      return false;
    } catch (e) {
      print("Create rating error: $e");
      return false;
    }
  }

  static Future<Rating?> getRatingByUserForRide({
    required int rideId,
    required int ratedByUserId,
  }) async {
    final url = Uri.parse(
      'http://${Utils().ip}:5205/api/ratings/by_user_for_ride/$rideId/$ratedByUserId',
    );

    try {
      final response = await http.get(url).timeout(const Duration(seconds: 5));

      if (response.statusCode == 200) {
        return Rating.fromJson(jsonDecode(response.body));
      }

      if (response.statusCode == 404) {
        return null;
      }

      print("Get user ride rating failed: ${response.statusCode}");
      print(response.body);
      return null;
    } catch (e) {
      print("Get user ride rating error: $e");
      return null;
    }
  }

  static Future<Map<String, dynamic>?> getRatingSummary(int userId) async {
    final url = Uri.parse('http://${Utils().ip}:5205/api/ratings/summary/$userId');

    try {
      final response = await http.get(url).timeout(const Duration(seconds: 5));

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      }

      print("Get rating summary failed: ${response.statusCode}");
      print(response.body);
      return null;
    } catch (e) {
      print("Get rating summary error: $e");
      return null;
    }
  }
}