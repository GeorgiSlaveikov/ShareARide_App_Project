import '../entity/vehicleMake.dart'; 
import '../entity/vehicle.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'utils.dart';

class VehicleUtils {

  static List<Vehicle> currentUserVehicles = [];

   static Future<Vehicle> getVehicle(int id) async {
    final url = Uri.parse('http://${Utils().ip}:5205/api/vehicles/$id');

    try {
      final response = await http.get(url).timeout(const Duration(seconds: 5));

      if (response.statusCode == 200) {
        var vehicle = jsonDecode(response.body);
        return Vehicle.fromJson(vehicle);
      }
    } catch (e) {
      print("API unreachable: $e");
      return Vehicle(id: id, make: VehicleMake.Unknown, model: '', year: 0, maxCapacity: 0, ownerId: 0);
    }
    return Vehicle(id: id, make: VehicleMake.Unknown, model: '', year: 0, maxCapacity: 0, ownerId: 0);
  }

  static Future<List<Vehicle>> getMyVehicles(int id) async {
    final url = Uri.parse('http://${Utils().ip}:5205/api/vehicles/my_vehicles/$id');

    try {
      final response = await http.get(url).timeout(const Duration(seconds: 5));

      if (response.statusCode == 200) {
        var vehicles = jsonDecode(response.body);
        var vehiclesList = (vehicles as List)
            .map((vehicle) => Vehicle.fromJson(vehicle))
            .toList();

  
        currentUserVehicles = vehiclesList;
        return vehiclesList;
      }
    } catch (e) {
      print("API unreachable: $e");
      return [];
    }
    return [];
  }
  
  static Future<bool> createVehicle(
    VehicleMake make,
    String model,
    int year,
    int maxCapacity,
    int ownerId,
  ) async {
    final url = Uri.parse('http://${Utils().ip}:5205/api/vehicles/create');

    try {
      final response = await http.post(
        url,
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
        },
        body: jsonEncode({
          "make": make.name,
          "model": model,
          "year": year,
          "maxCapacity": maxCapacity,
          "ownerId": ownerId,
        })
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        print('Vehicle created successfully!');
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

  static Future<bool> deleteVehicle(int id) async {
    final url = Uri.parse('http://${Utils().ip}:5205/api/vehicles/$id');

    try {
      final response = await http.delete(url);

      if (response.statusCode == 200 || response.statusCode == 204) {
        print('Vehicle deleted successfully!');
        return true;
      } else {
        print('Server Error: ${response.statusCode}');
        return false;
      }
    } catch (e) {
      print('Connection Error: $e');
      return false;
    }
  }

  static List<String> getModelsForMake(VehicleMake make) {
    switch (make) {
      case VehicleMake.Toyota:
        return ['Corolla', 'Camry', 'RAV4', 'Prius', 'Highlander', 'Tacoma', 'Yaris', 'Auris'];
      case VehicleMake.Honda:
        return ['Civic', 'Accord', 'CR-V', 'Pilot', 'Fit', 'HR-V', 'Odyssey'];
      case VehicleMake.Ford:
        return ['F-150', 'F-250', 'Mustang', 'Focus', 'Explorer', 'Escape', 'Fiesta', 'Ranger'];
      case VehicleMake.Chevrolet:
        return ['Silverado', 'Malibu', 'Equinox', 'Camaro', 'Corvette', 'Tahoe', 'Cruze', 'Impala'];
      case VehicleMake.Nissan:
        return ['Altima', 'Sentra', 'Rogue', '370Z', 'Pathfinder', 'Leaf', 'Maxima'];
      case VehicleMake.BMW:
        return ['3 Series', '5 Series', 'X3', 'X5', 'M3', 'M5', 'i3', 'i8'];
      case VehicleMake.MercedesBenz:
        return ['C-Class', 'E-Class', 'S-Class', 'GLC', 'GLE', 'CLA', 'AMG GT'];
      case VehicleMake.Audi:
        return ['A3', 'A4', 'A6', 'Q3', 'Q5', 'Q7', 'TT', 'R8'];
      case VehicleMake.Volkswagen:
        return ['Golf', 'Jetta', 'Passat', 'Tiguan', 'Polo', 'Arteon', 'Touareg'];
      case VehicleMake.Hyundai:
        return ['Elantra', 'Sonata', 'Tucson', 'Santa Fe', 'Kona', 'Ioniq', 'Accent'];
      case VehicleMake.Kia:
        return ['Sportage', 'Sorento', 'Optima', 'Rio', 'Stinger', 'Soul', 'Telluride'];
      case VehicleMake.Subaru:
        return ['Impreza', 'Outback', 'Forester', 'Crosstrek', 'Legacy', 'WRX', 'BRZ'];
      case VehicleMake.Mazda:
        return ['Mazda3', 'Mazda6', 'CX-3', 'CX-5', 'CX-9', 'MX-5 Miata'];
      case VehicleMake.Tesla:
        return ['Model S', 'Model 3', 'Model X', 'Model Y', 'Cybertruck', 'Roadster'];
      case VehicleMake.Jeep:
        return ['Wrangler', 'Grand Cherokee', 'Cherokee', 'Compass', 'Renegade', 'Gladiator'];
      case VehicleMake.Dodge:
        return ['Charger', 'Challenger', 'Durango', 'Journey', 'Grand Caravan', 'Ram 1500'];
      case VehicleMake.Lexus:
        return ['IS', 'ES', 'GS', 'LS', 'NX', 'RX', 'GX', 'LX', 'LC'];
      case VehicleMake.GMC:
        return ['Sierra', 'Acadia', 'Terrain', 'Yukon', 'Canyon', 'Savana'];
      case VehicleMake.Volvo:
        return ['S60', 'S90', 'V60', 'V90', 'XC40', 'XC60', 'XC90'];
      case VehicleMake.Porsche:
        return ['911', 'Cayenne', 'Macan', 'Panamera', '718 Boxster', '718 Cayman', 'Taycan'];
      case VehicleMake.Jaguar:
        return ['XE', 'XF', 'XJ', 'E-Pace', 'F-Pace', 'I-Pace', 'F-Type'];
      case VehicleMake.LandRover:
        return ['Range Rover', 'Range Rover Sport', 'Range Rover Velar', 'Evoque', 'Discovery', 'Defender'];
      case VehicleMake.Mitsubishi:
        return ['Lancer', 'Outlander', 'Eclipse Cross', 'ASX', 'Mirage', 'Pajero'];
      case VehicleMake.Fiat:
        return ['500', '500X', '500L', 'Panda', 'Tipo', '124 Spider'];
      case VehicleMake.AlfaRomeo:
        return ['Giulia', 'Stelvio', '4C Spider', 'Giulietta', 'Mito'];
      case VehicleMake.Unknown:
        return [];
    }
  }
}