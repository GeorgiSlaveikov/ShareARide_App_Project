// import 'package:flutter/material.dart';

// import '../controllers/userUtils.dart';
// import '../controllers/rideUtils.dart';
// import '../widgets/rideCard.dart';

// class RidesPage extends StatefulWidget {
//   const RidesPage({super.key});

//   @override
//   State<RidesPage> createState() => _RidesPageState();
// }

// class _RidesPageState extends State<RidesPage> {
//   List<Map<String, dynamic>> upcomingRides = [];
//   List<Map<String, dynamic>> pastRides = [];

//   bool isLoading = true;
//   bool showUpcoming = true;

//   int? currentUserId;

//   @override
//   void initState() {
//     super.initState();
//     loadRelatedRides();
//   }

//   Future<void> loadRelatedRides() async {
//     setState(() {
//       isLoading = true;
//     });

//     final userId = await UserUtils.getCurrentUserId();
//     final allRides = await RideUtils.getRidesForUser(userId);
//     final now = DateTime.now();

//     final upcoming = <Map<String, dynamic>>[];
//     final past = <Map<String, dynamic>>[];

//     for (final ride in allRides) {
//       final departureTimeRaw = ride['departureTime'];

//       if (departureTimeRaw == null) {
//         continue;
//       }

//       final departureTime = DateTime.tryParse(departureTimeRaw.toString());

//       if (departureTime == null) {
//         continue;
//       }

//       if (departureTime.isAfter(now)) {
//         upcoming.add(ride);
//       } else {
//         past.add(ride);
//       }
//     }

//     upcoming.sort((a, b) {
//       final aDate = DateTime.parse(a['departureTime'].toString());
//       final bDate = DateTime.parse(b['departureTime'].toString());

//       return aDate.compareTo(bDate);
//     });

//     past.sort((a, b) {
//       final aDate = DateTime.parse(a['departureTime'].toString());
//       final bDate = DateTime.parse(b['departureTime'].toString());

//       return bDate.compareTo(aDate);
//     });

//     if (!mounted) return;

//     setState(() {
//       currentUserId = userId;
//       upcomingRides = upcoming;
//       pastRides = past;
//       isLoading = false;
//     });
//   }

//   Future<void> refreshRides() async {
//     await loadRelatedRides();
//   }

//   void confirmCancelRide(int rideId) {
//     showDialog(
//       context: context,
//       builder: (ctx) => AlertDialog(
//         title: const Text("Отмяна на пътуване"),
//         content: const Text(
//           "Сигурни ли сте, че искате да отмените това пътуване?",
//         ),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(ctx),
//             child: const Text("Не"),
//           ),
//           ElevatedButton(
//             onPressed: () async {
//               Navigator.pop(ctx);

//               final success = await RideUtils.cancelRide(rideId);

//               if (!mounted) return;

//               if (success) {
//                 ScaffoldMessenger.of(context).showSnackBar(
//                   const SnackBar(
//                     content: Text("Пътуването е отменено."),
//                     backgroundColor: Colors.red,
//                     behavior: SnackBarBehavior.floating,
//                   ),
//                 );

//                 await loadRelatedRides();
//               } else {
//                 ScaffoldMessenger.of(context).showSnackBar(
//                   const SnackBar(
//                     content: Text("Неуспешна отмяна на пътуването."),
//                     backgroundColor: Colors.red,
//                     behavior: SnackBarBehavior.floating,
//                   ),
//                 );
//               }
//             },
//             style: ElevatedButton.styleFrom(
//               backgroundColor: Colors.red,
//               foregroundColor: Colors.white,
//             ),
//             child: const Text("Отмени"),
//           ),
//         ],
//       ),
//     );
//   }

//   void confirmFinishRide(int rideId) {
//     showDialog(
//       context: context,
//       builder: (ctx) => AlertDialog(
//         title: const Text("Завършване на пътуване"),
//         content: const Text(
//           "Сигурни ли сте, че искате да маркирате това пътуване като завършено?",
//         ),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(ctx),
//             child: const Text("Не"),
//           ),
//           ElevatedButton(
//             onPressed: () async {
//               Navigator.pop(ctx);

//               final success = await RideUtils.finishRide(rideId);

//               if (!mounted) return;

//               if (success) {
//                 ScaffoldMessenger.of(context).showSnackBar(
//                   const SnackBar(
//                     content: Text("Пътуването е завършено."),
//                     backgroundColor: Colors.green,
//                     behavior: SnackBarBehavior.floating,
//                   ),
//                 );

//                 await loadRelatedRides();
//               } else {
//                 ScaffoldMessenger.of(context).showSnackBar(
//                   const SnackBar(
//                     content: Text("Неуспешно завършване на пътуването."),
//                     backgroundColor: Colors.red,
//                     behavior: SnackBarBehavior.floating,
//                   ),
//                 );
//               }
//             },
//             style: ElevatedButton.styleFrom(
//               backgroundColor: Colors.green,
//               foregroundColor: Colors.white,
//             ),
//             child: const Text("Завърши"),
//           ),
//         ],
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     final currentRides = showUpcoming ? upcomingRides : pastRides;

//     return Scaffold(
//       appBar: AppBar(
//         title: const Text(
//           "Моите пътувания",
//           style: TextStyle(fontWeight: FontWeight.bold),
//         ),
//         backgroundColor: Colors.deepPurple,
//         foregroundColor: Colors.white,
//         elevation: 0,
//       ),
//       body: Column(
//         children: [
//           Container(
//             color: Colors.deepPurple.withOpacity(0.1),
//             padding: const EdgeInsets.symmetric(
//               horizontal: 16,
//               vertical: 12,
//             ),
//             child: Row(
//               children: [
//                 buildTabButton(
//                   label: "Предстоящи",
//                   isActive: showUpcoming,
//                   onTap: () {
//                     setState(() {
//                       showUpcoming = true;
//                     });
//                   },
//                 ),
//                 const SizedBox(width: 8),
//                 buildTabButton(
//                   label: "Минали пътувания",
//                   isActive: !showUpcoming,
//                   onTap: () {
//                     setState(() {
//                       showUpcoming = false;
//                     });
//                   },
//                 ),
//               ],
//             ),
//           ),
//           Expanded(
//             child: isLoading
//                 ? const Center(
//                     child: CircularProgressIndicator(
//                       color: Colors.deepPurple,
//                     ),
//                   )
//                 : RefreshIndicator(
//                     onRefresh: refreshRides,
//                     child: currentRides.isEmpty
//                         ? ListView(
//                             physics: const AlwaysScrollableScrollPhysics(),
//                             children: [
//                               SizedBox(
//                                 height:
//                                     MediaQuery.of(context).size.height * 0.65,
//                                 child: buildEmptyState(),
//                               ),
//                             ],
//                           )
//                         : ListView.builder(
//                             physics: const AlwaysScrollableScrollPhysics(),
//                             padding: const EdgeInsets.all(16),
//                             itemCount: currentRides.length,
//                             itemBuilder: (context, index) {
//                               final ride = currentRides[index];

//                               final bool isDriver =
//                                   ride['driverId'] == currentUserId;

//                               final rideId = ride['id'];

//                               return RideCard(
//                                 ride: ride,
//                                 isDriver: isDriver,
//                                 showUpcoming: showUpcoming,
//                                 onCancel: rideId == null
//                                     ? null
//                                     : () => confirmCancelRide(rideId),
//                                 onFinish: rideId == null
//                                     ? null
//                                     : () => confirmFinishRide(rideId),
//                               );
//                             },
//                           ),
//                   ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget buildTabButton({
//     required String label,
//     required bool isActive,
//     required VoidCallback onTap,
//   }) {
//     return Expanded(
//       child: GestureDetector(
//         onTap: onTap,
//         child: AnimatedContainer(
//           duration: const Duration(milliseconds: 200),
//           padding: const EdgeInsets.symmetric(vertical: 12),
//           decoration: BoxDecoration(
//             color: isActive ? Colors.deepPurple : Colors.white,
//             borderRadius: BorderRadius.circular(10),
//             border: Border.all(color: Colors.deepPurple),
//             boxShadow: isActive
//                 ? const [
//                     BoxShadow(
//                       color: Colors.black12,
//                       blurRadius: 4,
//                       offset: Offset(0, 2),
//                     ),
//                   ]
//                 : [],
//           ),
//           child: Text(
//             label,
//             textAlign: TextAlign.center,
//             style: TextStyle(
//               color: isActive ? Colors.white : Colors.deepPurple,
//               fontWeight: FontWeight.bold,
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   Widget buildEmptyState() {
//     return Center(
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Icon(
//             Icons.directions_car_filled_outlined,
//             size: 80,
//             color: Colors.grey.shade300,
//           ),
//           const SizedBox(height: 16),
//           Text(
//             "Няма ${showUpcoming ? 'предстоящи' : 'минали'} намерени пътувания",
//             textAlign: TextAlign.center,
//             style: const TextStyle(
//               color: Colors.grey,
//               fontSize: 16,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';

import '../controllers/userUtils.dart';
import '../controllers/rideUtils.dart';
import '../widgets/rideCard.dart';

class RidesPage extends StatefulWidget {
  const RidesPage({super.key});

  @override
  State<RidesPage> createState() => _RidesPageState();
}

class _RidesPageState extends State<RidesPage> {
  List<Map<String, dynamic>> upcomingRides = [];
  List<Map<String, dynamic>> pastRides = [];

  bool isLoading = true;
  bool showUpcoming = true;

  int? currentUserId;

  @override
  void initState() {
    super.initState();
    loadRelatedRides();
  }

  Future<void> loadRelatedRides() async {
    if (!mounted) return;

    setState(() {
      isLoading = true;
    });

    final userId = await UserUtils.getCurrentUserId();
    final allRides = await RideUtils.getRidesForUser(userId);

    final now = DateTime.now();

    final upcoming = <Map<String, dynamic>>[];
    final past = <Map<String, dynamic>>[];

    for (final ride in allRides) {
      final departureTimeRaw = ride['departureTime'];

      if (departureTimeRaw == null) {
        continue;
      }

      final departureTime = DateTime.tryParse(departureTimeRaw.toString());

      if (departureTime == null) {
        continue;
      }

      final status = ride['status'].toString().toLowerCase();

      final bool isFinished =
          status == "3" ||
          status == "finished" ||
          status.contains("finished") ||
          status.contains("завършено");

      final bool isCancelled =
          status == "4" ||
          status == "cancelled" ||
          status.contains("cancelled") ||
          status.contains("отменено");

      if (isFinished || isCancelled) {
        past.add(ride);
      } else if (departureTime.isAfter(now)) {
        upcoming.add(ride);
      } else {
        past.add(ride);
      }
    }

    // Newest/latest departure time first.
    upcoming.sort((a, b) {
      final aDate = DateTime.parse(a['departureTime'].toString());
      final bDate = DateTime.parse(b['departureTime'].toString());

      return bDate.compareTo(aDate);
    });

    // Most recent past ride first.
    past.sort((a, b) {
      final aDate = DateTime.parse(a['departureTime'].toString());
      final bDate = DateTime.parse(b['departureTime'].toString());

      return bDate.compareTo(aDate);
    });

    if (!mounted) return;

    setState(() {
      currentUserId = userId;
      upcomingRides = upcoming;
      pastRides = past;
      isLoading = false;
    });
  }

  Future<void> refreshRides() async {
    await loadRelatedRides();
  }

  void confirmCancelRide(int rideId) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Отмяна на пътуване"),
        content: const Text(
          "Сигурни ли сте, че искате да отмените това пътуване?",
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text("Не"),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(ctx);

              final success = await RideUtils.cancelRide(rideId);

              if (!mounted) return;

              if (success) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("Пътуването е отменено."),
                    backgroundColor: Colors.red,
                    behavior: SnackBarBehavior.floating,
                  ),
                );

                await loadRelatedRides();
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("Неуспешна отмяна на пътуването."),
                    backgroundColor: Colors.red,
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text("Отмени"),
          ),
        ],
      ),
    );
  }

  void confirmFinishRide(int rideId) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Завършване на пътуване"),
        content: const Text(
          "Сигурни ли сте, че искате да маркирате това пътуване като завършено?",
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text("Не"),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(ctx);

              final success = await RideUtils.finishRide(rideId);

              if (!mounted) return;

              if (success) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("Пътуването е завършено."),
                    backgroundColor: Colors.green,
                    behavior: SnackBarBehavior.floating,
                  ),
                );

                await loadRelatedRides();
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("Неуспешно завършване на пътуването."),
                    backgroundColor: Colors.red,
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              foregroundColor: Colors.white,
            ),
            child: const Text("Завърши"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final currentRides = showUpcoming ? upcomingRides : pastRides;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Моите пътувания",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Column(
        children: [
          Container(
            color: Colors.deepPurple.withOpacity(0.1),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: [
                buildTabButton(
                  label: "Предстоящи",
                  isActive: showUpcoming,
                  onTap: () {
                    setState(() {
                      showUpcoming = true;
                    });
                  },
                ),
                const SizedBox(width: 8),
                buildTabButton(
                  label: "Минали пътувания",
                  isActive: !showUpcoming,
                  onTap: () {
                    setState(() {
                      showUpcoming = false;
                    });
                  },
                ),
              ],
            ),
          ),
          Expanded(
            child: isLoading
                ? const Center(
                    child: CircularProgressIndicator(color: Colors.deepPurple),
                  )
                : RefreshIndicator(
                    onRefresh: refreshRides,
                    child: currentRides.isEmpty
                        ? ListView(
                            physics: const AlwaysScrollableScrollPhysics(),
                            children: [
                              SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.65,
                                child: buildEmptyState(),
                              ),
                            ],
                          )
                        : ListView.builder(
                            physics: const AlwaysScrollableScrollPhysics(),
                            padding: const EdgeInsets.all(16),
                            itemCount: currentRides.length,
                            itemBuilder: (context, index) {
                              final ride = currentRides[index];

                              final bool isDriver =
                                  ride['driverId'] == currentUserId;

                              final rideId = ride['id'];

                              // return RideCard(
                              //   ride: ride,
                              //   isDriver: isDriver,
                              //   showUpcoming: showUpcoming,
                              //   onCancel: rideId == null
                              //       ? null
                              //       : () => confirmCancelRide(rideId),
                              //   onFinish: rideId == null
                              //       ? null
                              //       : () => confirmFinishRide(rideId),
                              // );
                              return RideCard(
                                ride: ride,
                                isDriver: isDriver,
                                showUpcoming: showUpcoming,
                                currentUserId: currentUserId,
                                onCancel: rideId == null
                                    ? null
                                    : () => confirmCancelRide(rideId),
                                onFinish: rideId == null
                                    ? null
                                    : () => confirmFinishRide(rideId),
                                onRatingChanged: refreshRides,
                              );
                            },
                          ),
                  ),
          ),
        ],
      ),
    );
  }

  Widget buildTabButton({
    required String label,
    required bool isActive,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isActive ? Colors.deepPurple : Colors.white,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.deepPurple),
            boxShadow: isActive
                ? const [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 4,
                      offset: Offset(0, 2),
                    ),
                  ]
                : [],
          ),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: isActive ? Colors.white : Colors.deepPurple,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  Widget buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.directions_car_filled_outlined,
            size: 80,
            color: Colors.grey.shade300,
          ),
          const SizedBox(height: 16),
          Text(
            "Няма ${showUpcoming ? 'предстоящи' : 'минали'} намерени пътувания",
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.grey, fontSize: 16),
          ),
        ],
      ),
    );
  }
}
