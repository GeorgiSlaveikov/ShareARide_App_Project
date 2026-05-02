import 'dart:convert';
import 'package:http/http.dart' as http;
import '../entity/user.dart';

import 'utils.dart';
import 'dart:io';

class UserUtils {
  static User? currentUser;

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
        var userData = jsonDecode(response.body);
        var loggedInUser = User(
          id: userData['id'],
          username: userData['userName'],
          firstName: userData['firstName'],
          lastName: userData['lastName'],
          age: userData['age'],
          email: userData['email'],
          phoneNumber: userData['phoneNumber'],
          tripsCount: userData['tripsCount'],
          rating: userData['rating'],
          profilePicturePath: userData['profilePicturePath']
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

  static void logout() {
    currentUser = null;
  }

  static Future<Map<String, dynamic>> Register(
  String username,
  String firstName,
  String lastName,
  String phoneNumber,
  String email,
  String birthDate,
  int age,
  int sex,
  String password,
  File? imageFile,
) async {
  final url = Uri.parse('http://${Utils().ip}:5205/api/users/register');

  try {
    var request = http.MultipartRequest('POST', url);

    request.fields['username'] = username;
    request.fields['firstName'] = firstName;
    request.fields['lastName'] = lastName;
    request.fields['phoneNumber'] = phoneNumber;
    request.fields['email'] = email;
    request.fields['birthDate'] = birthDate;
    request.fields['age'] = age.toString();
    request.fields['sex'] = sex.toString();
    request.fields['password'] = password;

    if (imageFile != null) {
      request.files.add(
        await http.MultipartFile.fromPath(
          'ProfilePicture', 
          imageFile.path,
        ),
      );
    }
   
    var streamedResponse = await request.send();
    var response = await http.Response.fromStream(streamedResponse);

    if (response.statusCode == 200 || response.statusCode == 201) {
      print(response.body);
      var responseBodyObj = jsonDecode(response.body);
      return {'success': true, 'message': responseBodyObj['message']};
    } else {
      return {
        'success': false, 
        'message': response.body.isNotEmpty ? response.body : 'An unknown error occurred'
      };
    }
  } catch (e) {
    print(e);
    return {'success': false, 'message': 'Cannot connect to server. Check your internet.'};
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
          id: userData['id'],
          username: userData['userName'],
          firstName: userData['firstName'],
          lastName: userData['lastName'],
          age: userData['age'],
          email: userData['email'],
          phoneNumber: userData['phoneNumber'],
          tripsCount: userData['tripsCount'],
          rating: userData['rating'],
          profilePicturePath: userData['profilePicturePath']
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
