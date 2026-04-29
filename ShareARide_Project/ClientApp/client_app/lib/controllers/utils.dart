import 'package:http/http.dart' as http;

class Utils {
  var ip = '192.168.0.6';

   static Future<bool> checkConnection() async {
    final url = Uri.parse('http://${Utils().ip}:5205/api/base/check');

    try {
      final response = await http.get(url).timeout(const Duration(seconds: 5));

      if (response.statusCode == 200 || response.statusCode == 201) {
        print("API is reachable!");
        return true;
      }
    } catch (e) {
      print("API unreachable: $e");
      return false;
    }
    return false;
  }
}