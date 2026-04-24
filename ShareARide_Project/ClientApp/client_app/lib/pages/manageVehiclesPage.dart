import 'package:client_app/controllers/vehicleUtils.dart';
// import 'package:client_app/entity/vehicle.dart';
import 'package:flutter/material.dart';
import 'createVehiclePage.dart';
import '../controllers/userUtils.dart';
import '../entity/vehicleMake.dart';
import '../controllers/offerUtils.dart';

import '../entity/offer.dart';

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

  void navigateAndRemoveVehicle(int index) async {
    final userId = await UserUtils.getCurrentUserId();
    var myOffers = await OfferUtils.getMyOffers(userId);
    var vehicleIdToRemove = userVehicles[index]['id'];

    var dependentOffers = myOffers
        .where((o) => o.vehicleId == vehicleIdToRemove)
        .toList();

    if (dependentOffers.isNotEmpty) {
      List<Map<String, dynamic>> otherVehicles = userVehicles
          .where((v) => v['id'] != vehicleIdToRemove)
          .toList();

      if (otherVehicles.isEmpty) {
        showMustCreateVehicleDialog(); // Case: No other cars
      } else {
        showReplaceVehicleDialog(
          dependentOffers,
          otherVehicles,
          index,
        ); // Case: Swap car
      }
    } else {
      showStandardDeleteDialog(index); // Case: Clean delete
    }
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
          ? buildEmptyState()
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

  Widget buildEmptyState() {
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

  void performDelete(int index) async {
    var result = await removeVehicle(userVehicles[index]['id']);
    if (result) {
      setState(() {
        userVehicles.removeAt(index);
      });
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(
        const SnackBar(
          content: Text("Vehicle removed"),
          dismissDirection: DismissDirection.horizontal,
          behavior: SnackBarBehavior.floating,
        )
      );
    }
  }

  // Popup 1: Standard Confirmation
  void showStandardDeleteDialog(int index) {
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
            onPressed: () {
              Navigator.pop(ctx);
              performDelete(index);
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

  // Popup 2: Must Add New Vehicle
  void showMustCreateVehicleDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Action Required"),
        content: const Text(
          "You have active offers using this vehicle. You must add a new vehicle before you can remove this one.",
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              navigateAndAddVehicle();
            },
            child: const Text("Add New Vehicle"),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              navigateAndAddVehicle();
            },
            child: const Text("Cancel Offer"),
          ),
        ],
      ),
    );
  }

  // Popup 3: Select Replacement from Dropdown
  void showReplaceVehicleDialog(
    List<Offer> dependentOffers,
    List<Map<String, dynamic>> otherVehicles,
    int index,
  ) {
    int? selectedVehicleId = otherVehicles.first['id'];

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: const Text("Transfer Offers"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "You have ${dependentOffers.length} offer(s) using this vehicle. Select a replacement:",
              ),
              const SizedBox(height: 15),
              DropdownButton<int>(
                value: selectedVehicleId,
                isExpanded: true,
                items: otherVehicles
                    .map(
                      (v) => DropdownMenuItem<int>(
                        value: v['id'],
                        child: Text("${v['make']} ${v['model']}"),
                      ),
                    )
                    .toList(),
                onChanged: (val) =>
                    setDialogState(() => selectedVehicleId = val),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () async {
                for (var offer in dependentOffers) {
                  await OfferUtils.updateOfferVehicle(
                    offer.id!,
                    selectedVehicleId!,
                  );
                }
                Navigator.pop(ctx);
                performDelete(index);
              },
              child: const Text("Replace & Remove"),
            ),
          ],
        ),
      ),
    );
  }
}
