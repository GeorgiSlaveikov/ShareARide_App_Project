import 'dart:convert';
import 'package:http/http.dart' as http;
import '../entity/user.dart';

import 'utils.dart';
import 'dart:io';

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
          profilePicturePath: userData['profilePicturePath'],
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

  static Future<bool> Register(
    String username,
    String firstName,
    String lastName,
    String phoneNumber,
    String email,
    String birthDate,
    int age,
    int cityId,
    int sex,
    String password,
    File? imageFile,
  ) async {
    final url = Uri.parse('http://${Utils().ip}:5205/api/users/register');

    // try {
    //   final response = await http.post(
    //     url,
    //     headers: {
    //       "Content-Type": "application/json",
    //       "Accept": "application/json",
    //     },
    //     body: jsonEncode(
    //       {
    //         "username": username, 
    //         "firstName": firstName, 
    //         "lastName": lastName,
    //         "phoneNumber": phoneNumber,
    //         "email": email,
    //         "birthDate": birthDate,
    //         "age": age,
    //         "sex": sex,
    //         "password": password,
    //         "homeCity": {
    //           "id": cityId,
    //           "name": "Haskovo",
    //         }  
    //       }
    //     ),
    //   );

    //   if (response.statusCode == 200 || response.statusCode == 201) {
    //     // Success: The .NET API returns the User object
    //     var userData = jsonDecode(response.body);
    //     var loggedInUser = User(
    //       username: userData['username'],
    //       firstName: userData['firstName'],
    //       lastName: userData['lastName'],
    //       age: userData['age'],
    //       email: userData['email'],
    //     );

    //     currentUser = loggedInUser;

    //     print(
    //       'Login Success! Welcome ${userData['username']} - ${userData['firstName']} - ${userData['lastName']}',
    //     );
    //     return true;
    //     // TODO: Save userData['id'] to SharedPreferences here
    //   } else if (response.statusCode == 401) {
    //     print('Error: Invalid credentials');
    //     return false;
    //   } else {
    //     print('Server Error: ${response.statusCode}');
    //     return false;
    //   }
    // } catch (e) {
    //   print('Connection Error: $e');
    //   return false;
    // }
    try {
      // 2. Create a MultipartRequest instead of a standard post
      var request = http.MultipartRequest('POST', url);

      // 3. Add text fields (Note: All values must be converted to Strings)
      request.fields['username'] = username;
      request.fields['firstName'] = firstName;
      request.fields['lastName'] = lastName;
      request.fields['phoneNumber'] = phoneNumber;
      request.fields['email'] = email;
      request.fields['birthDate'] = birthDate;
      request.fields['age'] = age.toString();
      request.fields['sex'] = sex.toString();
      request.fields['password'] = password;
      
      // Because your .NET model expects "HomeCity.Id" from the form
      request.fields['HomeCity.id'] = cityId.toString();
      request.fields['HomeCity.name'] = 'Haskovo';

      // 4. Attach the image file if it exists
      if (imageFile != null) {
        request.files.add(
          await http.MultipartFile.fromPath(
            'ProfilePicture', // MUST match the IFormFile property name in your C# User class
            imageFile.path,
          ),
        );
      }

      // 5. Send the request
      var streamedResponse = await request.send();
      
      // 6. Convert streamed response to a standard response to read the body
      var response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200 || response.statusCode == 201) {
        var userData = jsonDecode(response.body);
        
        currentUser = User(
          username: userData['username'],
          firstName: userData['firstName'],
          lastName: userData['lastName'],
          age: userData['age'],
          email: userData['email'],
          profilePicturePath: userData['profilePicturePath']
        );

        print('Registration Success! Welcome ${userData['username']}');
        return true;
      } else {
        print('Server Error: ${response.statusCode} - ${response.body}');
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
