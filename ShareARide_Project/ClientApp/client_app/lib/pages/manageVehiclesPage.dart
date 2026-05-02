// import 'package:client_app/controllers/vehicleUtils.dart';
// import 'package:client_app/entity/vehicle.dart';
// // import 'package:client_app/entity/vehicle.dart';
// import 'package:flutter/material.dart';
// import 'createVehiclePage.dart';
// import '../controllers/userUtils.dart';
// import '../entity/vehicleMake.dart';
// import '../controllers/offerUtils.dart';
// import '../widgets/vehicleCard.dart';

// import '../entity/offer.dart';

// class ManageVehiclesPage extends StatefulWidget {
//   const ManageVehiclesPage({super.key});

//   @override
//   State<ManageVehiclesPage> createState() => _ManageVehiclesPageState();
// }

// class _ManageVehiclesPageState extends State<ManageVehiclesPage> {
//   List<Vehicle> userVehicles = [];

//   void fetchMyVehicles() async {
//     var userId = await UserUtils.getCurrentUserId();
//     var vehicles = await VehicleUtils.getMyVehicles(userId);
//     // print(vehicles.first.vehiclePicturePath);
//     setState(() {
//       userVehicles = vehicles;
//     });
//   }

//   void addNewVehicle(dynamic vehicleData) async {
//     VehicleMake selectedMake = VehicleMake.values.firstWhere(
//       (e) => e.name == vehicleData['make'],
//       orElse: () => VehicleMake.Unknown,
//     );

//     var result = await VehicleUtils.createVehicle(
//       selectedMake,
//       vehicleData['model'],
//       vehicleData['year'],
//       vehicleData['maxCapacity'],
//       vehicleData['ownerId'],
//       vehicleData['vehiclePicture']
//     );

//     if (result) {
//       fetchMyVehicles();
//     }
//   }

//   void navigateAndRemoveVehicle(int index) async {
//     final userId = await UserUtils.getCurrentUserId();
//     var myOffers = await OfferUtils.getMyOffers(userId);
//     var vehicleIdToRemove = userVehicles[index].id!;

//     var dependentOffers = myOffers
//         .where((o) => o.vehicleId == vehicleIdToRemove)
//         .toList();

//     if (dependentOffers.isNotEmpty) {
//       List<Vehicle> otherVehicles = userVehicles
//           .where((v) => v.id != vehicleIdToRemove)
//           .toList();

//       if (otherVehicles.isEmpty) {
//         showMustCreateVehicleDialog(); // Case: No other cars
//       } else {
//         showReplaceVehicleDialog(
//           dependentOffers,
//           otherVehicles,
//           index,
//         ); // Case: Swap car
//       }
//     } else {
//       showStandardDeleteDialog(index); // Case: Clean delete
//     }
//   }

//   Future<bool> removeVehicle(int id) async {
//     var result = VehicleUtils.deleteVehicle(id);
//     return result;
//   }

//   Future<void> navigateAndAddVehicle() async {
//     final result = await Navigator.push(
//       context,
//       MaterialPageRoute(builder: (_) => const CreateVehiclePage()),
//     );

//     if (result != null && result is Map<String, dynamic>) {
//       setState(() async {
//         userVehicles.add(Vehicle(
//           make: Vehicle.parseMake(result['make']), 
//           model: result['model'], 
//           year: result['year'], 
//           maxCapacity: result['maxCapacity'], 
//           vehiclePicturePath: result['vehiclePicturePath'],
//           ownerId: await UserUtils.getCurrentUserId())
//         );
//       });

//       addNewVehicle(result);
//     }
//   }

//   @override
//   void initState() {
//     super.initState();
//     fetchMyVehicles();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.grey.shade50,
//       appBar: AppBar(
//         title: const Text("Моите превозни средства"),
//         backgroundColor: Colors.deepPurple,
//         foregroundColor: Colors.white,
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.add),
//             onPressed: () => Navigator.push(
//               context,
//               MaterialPageRoute(builder: (_) => const CreateVehiclePage()),
//             ),
//           ),
//         ],
//       ),
//       body: userVehicles.isEmpty
//           ? buildEmptyState()
//           : ListView.builder(
//               padding: const EdgeInsets.all(16),
//               itemCount: userVehicles.length,
//               itemBuilder: (context, index) {
//                 final vehicle = userVehicles[index];
//                 return VehicleCard(
//                   vehicle: vehicle, 
//                   index: index, 
//                   onDelete: () => navigateAndRemoveVehicle(index)
//                 );
//               },
//             ),
//       floatingActionButton: FloatingActionButton.extended(
//         onPressed: () => navigateAndAddVehicle(),
//         backgroundColor: Colors.deepPurple,
//         icon: const Icon(Icons.add, color: Colors.white),
//         label: const Text("Добавяне на превозно средство", style: TextStyle(color: Colors.white)),
//       ),
//     );
//   }

//   Widget buildEmptyState() {
//     return Center(
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Icon(Icons.car_rental, size: 80, color: Colors.grey.shade300),
//           const Text(
//             "Все още няма добавени превозни средства",
//             textAlign: TextAlign.center,
//             style: TextStyle(color: Colors.grey, fontSize: 18),
//           ),
//         ],
//       ),
//     );
//   }

//   void performDelete(int index) async {
//     var result = await removeVehicle(userVehicles[index].id!);
//     if (result) {
//       setState(() {
//         userVehicles.removeAt(index);
//       });
//       ScaffoldMessenger.of(
//         context,
//       ).showSnackBar(
//         const SnackBar(
//           content: Text("Превозното средство е премахнато"),
//           dismissDirection: DismissDirection.horizontal,
//           behavior: SnackBarBehavior.floating,
//           backgroundColor: Colors.red,
//         )
//       );
//     }
//   }

//   // Popup 1: Standard Confirmation
//   void showStandardDeleteDialog(int index) {
//     showDialog(
//       context: context,
//       builder: (ctx) => AlertDialog(
//         title: const Text("Премахване на превозно средство"),
//         content: Text(
//           "Сигурни ли сте, че искате да премахнете ${userVehicles[index].make} ${userVehicles[index].model}?",
//         ),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(ctx),
//             child: const Text("Отказ"),
//           ),
//           ElevatedButton(
//             onPressed: () {
//               Navigator.pop(ctx);
//               performDelete(index);
//             },
//             style: ElevatedButton.styleFrom(
//               backgroundColor: Colors.red,
//               foregroundColor: Colors.white,
//             ),
//             child: const Text("Премахване"),
//           ),
//         ],
//       ),
//     );
//   }

//   // Popup 2: Must Add New Vehicle
//   void showMustCreateVehicleDialog() {
//     showDialog(
//       context: context,
//       builder: (ctx) => AlertDialog(
//         title: const Text("Необходимо действие"),
//         content: const Text(
//           "Имате активни оферти, използващи това превозно средство. Трябва да добавите ново превозно средство, преди да можете да премахнете това.",
//         ),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(ctx),
//             child: const Text("Отказ"),
//           ),
//           ElevatedButton(
//             onPressed: () {
//               Navigator.pop(ctx);
//               navigateAndAddVehicle();
//             },
//             child: const Text("Добавяне на ново превозно средство"),
//           ),
//           ElevatedButton(
//             onPressed: () {
//               Navigator.pop(ctx);
//               navigateAndAddVehicle();
//             },
//             child: const Text("Отказ от офертата"),
//           ),
//         ],
//       ),
//     );
//   }

//   // Popup 3: Select Replacement from Dropdown
//   void showReplaceVehicleDialog(
//     List<Offer> dependentOffers,
//     List<Vehicle> otherVehicles,
//     int index,
//   ) {
//     int? selectedVehicleId = otherVehicles.first.id;

//     showDialog(
//       context: context,
//       builder: (ctx) => StatefulBuilder(
//         builder: (context, setDialogState) => AlertDialog(
//           title: const Text("Премести оферта"),
//           content: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               Text(
//                 "Имате ${dependentOffers.length} оферта(и), използваща(и) това превозно средство. Изберете заместващо:",
//               ),
//               const SizedBox(height: 15),
//               DropdownButton<int>(
//                 value: selectedVehicleId,
//                 isExpanded: true,
//                 items: otherVehicles
//                     .map(
//                       (v) => DropdownMenuItem<int>(
//                         value: v.id,
//                         child: Text("${v.make.name} ${v.model}"),
//                       ),
//                     )
//                     .toList(),
//                 onChanged: (val) =>
//                     setDialogState(() => selectedVehicleId = val),
//               ),
//             ],
//           ),
//           actions: [
//             TextButton(
//               onPressed: () => Navigator.pop(ctx),
//               child: const Text("Отказ"),
//             ),
//             ElevatedButton(
//               onPressed: () async {
//                 for (var offer in dependentOffers) {
//                   await OfferUtils.updateOfferVehicle(
//                     offer.id!,
//                     selectedVehicleId!,
//                   );
//                 }
//                 Navigator.pop(ctx);
//                 performDelete(index);
//               },
//               child: const Text("Замяна и премахване"),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'package:client_app/controllers/vehicleUtils.dart';
import 'package:client_app/entity/vehicle.dart';
import 'package:flutter/material.dart';

import 'createVehiclePage.dart';
import '../controllers/userUtils.dart';
import '../entity/vehicleMake.dart';
import '../controllers/offerUtils.dart';
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

  void navigateAndRemoveVehicle(int index) async {
    final userId = await UserUtils.getCurrentUserId();
    final myOffers = await OfferUtils.getMyOffers(userId);
    final vehicleIdToRemove = userVehicles[index].id!;

    final dependentOffers = myOffers
        .where((o) => o.vehicleId == vehicleIdToRemove)
        .toList();

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

  Future<bool> removeVehicle(int id) async {
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
          : ListView.builder(
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
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.car_rental, size: 80, color: Colors.grey.shade300),
          const Text(
            "Все още няма добавени превозни средства",
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.grey, fontSize: 18),
          ),
        ],
      ),
    );
  }

  void performDelete(int index) async {
    final result = await removeVehicle(userVehicles[index].id!);

    if (result) {
      setState(() {
        userVehicles.removeAt(index);
      });

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Превозното средство е премахнато"),
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
        title: const Text("Премахване на превозно средство"),
        content: Text(
          "Сигурни ли сте, че искате да премахнете ${userVehicles[index].make.name} ${userVehicles[index].model}?",
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
      builder: (ctx) => AlertDialog(
        title: const Text("Необходимо действие"),
        content: const Text(
          "Имате активни оферти, използващи това превозно средство. Трябва да добавите ново превозно средство, преди да можете да премахнете това.",
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text("Отказ"),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              navigateAndAddVehicle();
            },
            child: const Text("Добавяне на ново превозно средство"),
          ),
        ],
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
          title: const Text("Премести оферта"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Имате ${dependentOffers.length} оферта(и), използваща(и) това превозно средство. Изберете заместващо:",
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

                Navigator.pop(ctx);
                performDelete(index);
              },
              child: const Text("Замяна и премахване"),
            ),
          ],
        ),
      ),
    );
  }
}
