import 'dart:convert';
import 'package:http/http.dart' as http;
import '../entity/user.dart';

import 'utils.dart';

class UserUtils {
  static User? currentUser;
  static Future<bool> checkConnection() async {
    final url = Uri.parse('http://${Utils().ip}:5205/api/users/check');

    try {
      final response = await http.get(url).timeout(const Duration(seconds: 5));

      if (response.statusCode == 200) {
        print("API is reachable!");
        return true;
      }
    } catch (e) {
      print("API unreachable: $e");
      return false;
    }
    return false;
  }

  static Future<bool> Login(String username, String password) async {
    final url = Uri.parse('http://${Utils().ip}:5205/api/users/login');

    try {
      final response = await http.post(
        url,
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
        },
        body: jsonEncode({"username": username, "password": password}),
      );

      if (response.statusCode == 200) {
        // Success: The .NET API returns the User object
        var userData = jsonDecode(response.body);
        var loggedInUser = User(
          id: userData['id'],
          username: userData['username'],
          firstName: userData['firstName'],
          lastName: userData['lastName'],
          age: userData['age'],
          email: userData['email'],
        );

        currentUser = loggedInUser;

        print(
          'Login Success! Welcome ${userData['username']} - ${userData['firstName']} - ${userData['lastName']}',
        );
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

  static Future<bool> Register(
    String username,
    String firstName,
    String lastName,
    String email,
    String birthDate,
    int age,
    int cityId,
    int sex,
    String password,
  ) async {
    final url = Uri.parse('http://${Utils().ip}:5205/api/users/register');

    try {
      final response = await http.post(
        url,
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
        },
        body: jsonEncode(
          {
            "username": username, 
            "firstName": firstName, 
            "lastName": lastName,
            "email": email,
            "birthDate": birthDate,
            "age": age,
            "sex": sex,
            "password": password,
            "homeCity": {
              "id": cityId,
              "name": "Haskovo",
            }  
          }
        ),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        // Success: The .NET API returns the User object
        var userData = jsonDecode(response.body);
        var loggedInUser = User(
          username: userData['username'],
          firstName: userData['firstName'],
          lastName: userData['lastName'],
          age: userData['age'],
          email: userData['email'],
        );

        currentUser = loggedInUser;

        print(
          'Login Success! Welcome ${userData['username']} - ${userData['firstName']} - ${userData['lastName']}',
        );
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

   static Future<User?> getUser(int id) async {
    final url = Uri.parse('http://${Utils().ip}:5205/api/users/$id');

    try {
      final response = await http.get(url).timeout(const Duration(seconds: 5));

      if (response.statusCode == 200 || response.statusCode == 201) {
        print("API is reachable!");
        var userData = jsonDecode(response.body);
        return User(
          username: userData['username'],
          firstName: userData['firstName'],
          lastName: userData['lastName'],
          age: userData['age'],
          email: userData['email']
        );
      }
    } catch (e) {
      print("API unreachable: $e");
      return null;
    }
    return null;
  }

  static int getCurrentUserId() {
    return currentUser != null ? currentUser!.id ?? -1 : -1;
  }
}
