import 'dart:convert';
import 'package:http/http.dart' as http;
import '../entity/city.dart';

class CityUtils {

  static Future<List<City>> getCities() async {
    final url = Uri.parse('http://192.168.0.6:5205/api/cities');

    try {
      final response = await http.get(url).timeout(const Duration(seconds: 5));
  
      if (response.statusCode == 200) {
        print("API is reachable!");
        print(response.body);
        var cities = jsonDecode(response.body);
        var citiesList = (cities as List).map((city) => City.fromJson(city)).toList();
        return citiesList;
      }
    } catch (e) {
      print("API unreachable: $e");
      return [];
    }
    return [];
  }
}