import 'package:client_app/controllers/vehicleUtils.dart';
// import 'package:client_app/entity/vehicle.dart';
import 'package:flutter/material.dart';
import 'createVehiclePage.dart';
import '../controllers/userUtils.dart';
import '../entity/vehicleMake.dart'; // Path to your Enum

class ManageVehiclesPage extends StatefulWidget {
  const ManageVehiclesPage({super.key});

  @override
  State<ManageVehiclesPage> createState() => _ManageVehiclesPageState();
}

class _ManageVehiclesPageState extends State<ManageVehiclesPage> {
  List<Map<String, dynamic>> userVehicles = [];

  void fetchMyVehicles() async {
    var userId = await UserUtils.getCurrentUserId();
    var vehicles = await VehicleUtils.getMyVehicles(userId);
    var mappedVehicles = await Future.wait(
      vehicles.map((vehicle) async {
        print(
          "Vehicle from API: ${vehicle.make.name} ${vehicle.model} (${vehicle.year}) - Seats: ${vehicle.maxCapacity}",
        );
        return {
          "id": vehicle.id,
          "make": vehicle.make.name,
          "model": vehicle.model,
          "year": vehicle.year,
          "maxCapacity": vehicle.maxCapacity,
        };
      }).toList(),
    );

    setState(() {
      userVehicles = mappedVehicles;
    });
  }

  void addNewVehicle(dynamic vehicleData) async {
    VehicleMake selectedMake = VehicleMake.values.firstWhere(
      (e) => e.name == vehicleData['make'],
      orElse: () => VehicleMake.Unknown,
    );

    var result = await VehicleUtils.createVehicle(
      selectedMake,
      vehicleData['model'],
      vehicleData['year'],
      vehicleData['maxCapacity'],
      UserUtils.getCurrentUserId(),
    );

    if (result) {
      fetchMyVehicles();
    }
  }

  void navigateAndRemoveVehicle(int index) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Remove Vehicle"),
        content: Text(
          "Are you sure you want to remove the ${userVehicles[index]['make']} ${userVehicles[index]['model']}?",
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () async {
              var result = await removeVehicle(userVehicles[index]['id']);
              if (result) {
                fetchMyVehicles();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Vehicle removed")),
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Failed to remove vehicle")),
                );
              }
              setState(() {
                userVehicles.removeAt(index);
              });
              Navigator.pop(ctx);
              
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text("Remove"),
          ),
        ],
      ),
    );
  }

  Future<bool> removeVehicle(int id) async {
    var result = VehicleUtils.deleteVehicle(id);
    return result;
  }

  Future<void> navigateAndAddVehicle() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const CreateVehiclePage()),
    );

    if (result != null && result is Map<String, dynamic>) {
      setState(() {
        userVehicles.add(result);
      });

      addNewVehicle(result);
    }
  }

  @override
  void initState() {
    super.initState();
    fetchMyVehicles();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: const Text("My Vehicles"),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const CreateVehiclePage()),
            ),
          ),
        ],
      ),
      body: userVehicles.isEmpty
          ? _buildEmptyState()
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: userVehicles.length,
              itemBuilder: (context, index) {
                final vehicle = userVehicles[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: ListTile(
                    leading: const CircleAvatar(
                      backgroundColor: Colors.deepPurple,
                      child: Icon(Icons.directions_car, color: Colors.white),
                    ),
                    title: Text("${vehicle['make']} ${vehicle['model']}"),
                    subtitle: Text(
                      "${vehicle['year']} • ${vehicle['maxCapacity']} Seats",
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete_outline, color: Colors.red),
                      onPressed: () => navigateAndRemoveVehicle(index),
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => navigateAndAddVehicle(),
        backgroundColor: Colors.deepPurple,
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text("Add Vehicle", style: TextStyle(color: Colors.white)),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.car_rental, size: 80, color: Colors.grey.shade300),
          const Text(
            "No vehicles added yet",
            style: TextStyle(color: Colors.grey, fontSize: 18),
          ),
        ],
      ),
    );
  }
}
