import 'package:client_app/controllers/vehicleUtils.dart';
import 'package:client_app/entity/vehicle.dart';
import 'package:flutter/material.dart';
import 'createVehiclePage.dart';
import '../controllers/userUtils.dart';
import '../entity/vehicleMake.dart';
import '../controllers/offerUtils.dart';
import '../controllers/rideUtils.dart';
import '../widgets/vehicleCard.dart';
import '../entity/offer.dart';

class ManageVehiclesPage extends StatefulWidget {
  const ManageVehiclesPage({super.key});

  @override
  State<ManageVehiclesPage> createState() => _ManageVehiclesPageState();
}

class _ManageVehiclesPageState extends State<ManageVehiclesPage> {
  List<Vehicle> userVehicles = [];

  Future<void> fetchMyVehicles() async {
    final userId = await UserUtils.getCurrentUserId();
    final vehicles = await VehicleUtils.getMyVehicles(userId);

    if (!mounted) return;

    setState(() {
      userVehicles = vehicles;
    });
  }

  Future<void> addNewVehicle(Map<String, dynamic> vehicleData) async {
    final selectedMake = VehicleMake.values.firstWhere(
      (e) => e.name == vehicleData['make'],
      orElse: () => VehicleMake.Unknown,
    );

    final userId = await UserUtils.getCurrentUserId();

    final result = await VehicleUtils.createVehicle(
      selectedMake,
      vehicleData['model'],
      vehicleData['year'],
      vehicleData['maxCapacity'],
      userId,
      vehicleData['vehiclePicture'],
    );

    if (result) {
      await fetchMyVehicles();

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Превозното средство е създадено успешно!"),
          dismissDirection: DismissDirection.horizontal,
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  Future<void> navigateAndAddVehicle() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const CreateVehiclePage()),
    );

    if (result != null && result is Map<String, dynamic>) {
      await addNewVehicle(result);
    }
  }

  Future<void> navigateAndRemoveVehicle(int index) async {
    final userId = await UserUtils.getCurrentUserId();
    final myOffers = await OfferUtils.getMyOffers(userId);
    final myRides = await RideUtils.getRidesForUser(userId);

    final vehicleIdToRemove = userVehicles[index].id!;

    final dependentOffers = myOffers.where((offer) {
      final bool usesThisVehicle = offer.vehicleId == vehicleIdToRemove;

      final bool offerIsActive =
          offer.status.index == 0 ||
          offer.status.toString().toLowerCase().contains("active");

      final relatedRides = myRides.where((ride) {
        return ride['offerId'].toString() == offer.id.toString();
      }).toList();

      final bool hasNoRide = relatedRides.isEmpty;

      final bool hasUnfinishedRide = relatedRides.any((ride) {
        final status = ride['status'].toString().toLowerCase();

        final bool isFinished =
            status == "3" || status.contains("finished");

        final bool isCancelled =
            status == "4" || status.contains("cancelled");

        return !isFinished && !isCancelled;
      });

      return usesThisVehicle &&
          offerIsActive &&
          (hasNoRide || hasUnfinishedRide);
    }).toList();

    if (dependentOffers.isNotEmpty) {
      final otherVehicles = userVehicles
          .where((v) => v.id != vehicleIdToRemove)
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

 Future<Map<String, dynamic>> removeVehicle(int id) async {
  return await VehicleUtils.deleteVehicle(id);
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
        title: const Text("Моите превозни средства"),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: navigateAndAddVehicle,
          ),
        ],
      ),
      body: userVehicles.isEmpty
          ? buildEmptyState()
          : RefreshIndicator(
              color: Colors.deepPurple,
              onRefresh: fetchMyVehicles,
              child: ListView.builder(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.all(16),
                itemCount: userVehicles.length,
                itemBuilder: (context, index) {
                  final vehicle = userVehicles[index];

                  return VehicleCard(
                    vehicle: vehicle,
                    index: index,
                    onDelete: () => navigateAndRemoveVehicle(index),
                  );
                },
              ),
            ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: navigateAndAddVehicle,
        backgroundColor: Colors.deepPurple,
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text(
          "Добавяне на превозно средство",
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }

  Widget buildEmptyState() {
    return RefreshIndicator(
      color: Colors.deepPurple,
      onRefresh: fetchMyVehicles,
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.75,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.car_rental,
                    size: 80,
                    color: Colors.grey.shade300,
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    "Все още няма добавени превозни средства",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 18,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void performDelete(int index) async {
  final vehicleId = userVehicles[index].id;

  if (vehicleId == null) return;

  final result = await removeVehicle(vehicleId);

  if (!mounted) return;

  final bool success = result["success"] == true;
  final bool archived = result["archived"] == true;
  final String message = result["message"] ?? "Възникна грешка.";

  if (success) {
    await fetchMyVehicles();

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          archived
              ? "Превозното средство е архивирано."
              : "Превозното средство е премахнато.",
        ),
        dismissDirection: DismissDirection.horizontal,
        behavior: SnackBarBehavior.floating,
        backgroundColor: archived ? Colors.orange : Colors.red,
      ),
    );
  } else {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        dismissDirection: DismissDirection.horizontal,
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.red,
      ),
    );
  }
}

  void showStandardDeleteDialog(int index) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
        ),
        title: const Text("Премахване на превозно средство"),
        content: Text(
          "Сигурни ли сте, че искате да премахнете "
          "${userVehicles[index].make.name} ${userVehicles[index].model}?",
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text("Отказ"),
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
            child: const Text("Премахване"),
          ),
        ],
      ),
    );
  }

  void showMustCreateVehicleDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 24, 24, 18),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 72,
                height: 72,
                decoration: BoxDecoration(
                  color: Colors.orange.withOpacity(0.12),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.warning_amber_rounded,
                  size: 42,
                  color: Colors.orange,
                ),
              ),

              const SizedBox(height: 18),

              const Text(
                "Не можете да премахнете това превозно средство",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 12),

              Text(
                "Това превозно средство се използва в активна оферта, "
                "която все още не е приключила. За да го премахнете, "
                "първо трябва да добавите друго превозно средство, "
                "което да замести текущото.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 15,
                  height: 1.45,
                  color: Colors.grey.shade700,
                ),
              ),

              const SizedBox(height: 22),

              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Colors.deepPurple.withOpacity(0.06),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: Colors.deepPurple.withOpacity(0.15),
                  ),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.info_outline,
                      color: Colors.deepPurple,
                      size: 22,
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        "След като добавите ново превозно средство, "
                        "ще можете да преместите офертите към него.",
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.grey.shade800,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(ctx),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.grey.shade700,
                        side: BorderSide(color: Colors.grey.shade300),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      child: const Text(
                        "Отказ",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),

                  const SizedBox(width: 12),

                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Navigator.pop(ctx);
                        navigateAndAddVehicle();
                      },
                      icon: const Icon(Icons.add),
                      label: const Text("Добави"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.deepPurple,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
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
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
          title: const Text("Премести офертите"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Имате ${dependentOffers.length} активна оферта(и), "
                "използваща(и) това превозно средство. "
                "Изберете заместващо превозно средство:",
              ),
              const SizedBox(height: 15),
              DropdownButton<int>(
                value: selectedVehicleId,
                isExpanded: true,
                items: otherVehicles
                    .map(
                      (v) => DropdownMenuItem<int>(
                        value: v.id,
                        child: Text("${v.make.name} ${v.model}"),
                      ),
                    )
                    .toList(),
                onChanged: (val) {
                  setDialogState(() {
                    selectedVehicleId = val;
                  });
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text("Отказ"),
            ),
            ElevatedButton(
              onPressed: () async {
                if (selectedVehicleId == null) return;

                for (final offer in dependentOffers) {
                  await OfferUtils.updateOfferVehicle(
                    offer.id!,
                    selectedVehicleId!,
                  );
                }

                if (!mounted) return;

                Navigator.pop(ctx);
                performDelete(index);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurple,
                foregroundColor: Colors.white,
              ),
              child: const Text("Замяна и премахване"),
            ),
          ],
        ),
      ),
    );
  }
}