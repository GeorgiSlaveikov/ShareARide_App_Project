import 'dart:convert';
import 'package:http/http.dart' as http;
import '../entity/city.dart';

import 'utils.dart';

class CityUtils {

  static Future<List<City>> getCities() async {
    final url = Uri.parse('http://${Utils().ip}:5205/api/cities');

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

  static Future<City> getCity(int id) async {
    final url = Uri.parse('http://${Utils().ip}:5205/api/cities/$id');

    try {
      final response = await http.get(url).timeout(const Duration(seconds: 5));
  
      if (response.statusCode == 200) {
        print("API is reachable!");
        print(response.body);
        var city = jsonDecode(response.body);
        return City.fromJson(city);
      }
    } catch (e) {
      print("API unreachable: $e");
      return City(id: id, name: "Unknown City");
    }
    return City(id: id, name: "Unknown City");
  }
}