import 'package:client_app/controllers/vehicleUtils.dart';
import 'package:client_app/entity/vehicle.dart';
import 'package:flutter/material.dart';
import 'createVehiclePage.dart';
import '../controllers/userUtils.dart';
import '../entity/vehicleMake.dart';
import '../controllers/offerUtils.dart';
import '../widgets/pageEmptyState.dart';
import '../widgets/vehicleCard.dart';
import '../infoPopupModals/vehicleDetailsModal.dart';
import '../entity/offer.dart';

class ManageVehiclesPage extends StatefulWidget {
  const ManageVehiclesPage({super.key});

  @override
  State<ManageVehiclesPage> createState() => _ManageVehiclesPageState();
}

class _ManageVehiclesPageState extends State<ManageVehiclesPage> {
  // CHANGED: Use the Class type instead of Map
  List<Vehicle> userVehicles = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchMyVehicles();
  }

  void fetchMyVehicles() async {
    setState(() => isLoading = true);
    try {
      final userId = await UserUtils.getCurrentUserId();
      // Assuming getMyVehicles already returns List<Vehicle>
      final vehicles = await VehicleUtils.getMyVehicles(userId);
      // print(vehicles);
      
      setState(() {
        userVehicles = vehicles;
        isLoading = false;
      });
    } catch (e) {
      setState(() => isLoading = false);
      print("Error fetching vehicles: $e");
    }
  }

  void addNewVehicle(dynamic vehicleData) async {
    // Map the string/dynamic data from form back to Object for the API call
    VehicleMake selectedMake = VehicleMake.values.firstWhere(
      (e) => e.name == vehicleData['make'],
      orElse: () => VehicleMake.Unknown,
    );

    final userId = await UserUtils.getCurrentUserId();

    var result = await VehicleUtils.createVehicle(
      selectedMake,
      vehicleData['model'],
      vehicleData['year'],
      vehicleData['maxCapacity'],
      userId,
      vehicleData['vehiclePicture'], 
    );

    if (result) {
      fetchMyVehicles(); // Refresh list from server to get the new ID
    }
  }

  void navigateAndRemoveVehicle(int index) async {
    final userId = await UserUtils.getCurrentUserId();
    final myOffers = await OfferUtils.getMyOffers(userId);
    final vehicleToRemove = userVehicles[index];

    // Filter offers using the object ID
    var dependentOffers = myOffers
        .where((o) => o.vehicleId == vehicleToRemove.id)
        .toList();

    if (dependentOffers.isNotEmpty) {
      List<Vehicle> otherVehicles = userVehicles
          .where((v) => v.id != vehicleToRemove.id)
          .toList();

      if (otherVehicles.isEmpty) {
        showMustCreateVehicleDialog();
      } else {
        showReplaceVehicleDialog(dependentOffers, otherVehicles, index);
      }
    } else {
      showStandardDeleteDialog(index);
    }
  }

  Future<void> navigateAndAddVehicle() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const CreateVehiclePage()),
    );

    if (result != null && result is Map<String, dynamic>) {
      addNewVehicle(result);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: const Text("My Vehicles"),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
      ),
      body: isLoading 
          ? const Center(child: CircularProgressIndicator())
          : userVehicles.isEmpty
              ? pageEmptyState(
                  Icons.car_rental,
                  Colors.grey.shade300,
                  "No vehicles added yet",
                  Colors.grey,
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: userVehicles.length,
                  itemBuilder: (context, index) {
                    final vehicle = userVehicles[index];
                    // print(vehicle);
                    return VehicleCard(
                      vehicle: vehicle, 
                      onTap: () {
                        // print(vehicle);
                        VehicleDetailModal.show(
                          context,
                          vehicle,
                          () => {}, // Placeholder for edit photo
                        );
                      },
                      onDelete: () => navigateAndRemoveVehicle(index),
                    );
                  },
                ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: navigateAndAddVehicle,
        backgroundColor: Colors.deepPurple,
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text("Add Vehicle", style: TextStyle(color: Colors.white)),
      ),
    );
  }

  // --- POPUPS UPDATED TO USE OBJECT PROPERTIES ---

  void showStandardDeleteDialog(int index) {
    final vehicle = userVehicles[index];
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Remove Vehicle"),
        content: Text("Are you sure you want to remove the ${vehicle.make.name} ${vehicle.model}?"),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text("Cancel")),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              performDelete(index);
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red, foregroundColor: Colors.white),
            child: const Text("Remove"),
          ),
        ],
      ),
    );
  }

  void performDelete(int index) async {
    var result = await VehicleUtils.deleteVehicle(userVehicles[index].id!);
    if (result) {
      setState(() => userVehicles.removeAt(index));
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Vehicle removed"),
          backgroundColor: Colors.red,
          dismissDirection: DismissDirection.horizontal,
        ),
      );
    }
  }

  void showReplaceVehicleDialog(
    List<Offer> dependentOffers,
    List<Vehicle> otherVehicles,
    int index,
  ) {
    int? selectedVehicleId = otherVehicles.first.id;

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: const Text("Transfer Offers"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text("Select a replacement for ${dependentOffers.length} offer(s):"),
              const SizedBox(height: 15),
              DropdownButton<int>(
                value: selectedVehicleId,
                isExpanded: true,
                items: otherVehicles.map((v) => DropdownMenuItem<int>(
                  value: v.id,
                  child: Text("${v.make.name} ${v.model}"),
                )).toList(),
                onChanged: (val) => setDialogState(() => selectedVehicleId = val),
              ),
            ],
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(ctx), child: const Text("Cancel")),
            ElevatedButton(
              onPressed: () async {
                for (var offer in dependentOffers) {
                  await OfferUtils.updateOfferVehicle(offer.id!, selectedVehicleId!);
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

  void showMustCreateVehicleDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Action Required"),
        content: const Text("Active offers exist. Please add a new vehicle before removing this one."),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text("Cancel")),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              navigateAndAddVehicle();
            },
            child: const Text("Add New Vehicle"),
          ),
        ],
      ),
    );
  }
}