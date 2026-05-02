import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../controllers/userUtils.dart';
import '../controllers/rideUtils.dart';

import '../infoPopupModals/ridePassengersModal.dart';

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

      if (departureTime.isAfter(now)) {
        upcoming.add(ride);
      } else {
        past.add(ride);
      }
    }

    upcoming.sort((a, b) {
      final aDate = DateTime.parse(a['departureTime'].toString());
      final bDate = DateTime.parse(b['departureTime'].toString());

      // Soonest upcoming ride first
      return aDate.compareTo(bDate);
    });

    past.sort((a, b) {
      final aDate = DateTime.parse(a['departureTime'].toString());
      final bDate = DateTime.parse(b['departureTime'].toString());

      // Most recent past ride first
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
                            children: [
                              SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.65,
                                child: buildEmptyState(),
                              ),
                            ],
                          )
                        : ListView.builder(
                            padding: const EdgeInsets.all(16),
                            itemCount: currentRides.length,
                            itemBuilder: (context, index) {
                              final ride = currentRides[index];

                              final bool isDriver =
                                  ride['driverId'] == currentUserId;

                              // return buildRideCard(ride, isDriver);
                              return InkWell(
                                borderRadius: BorderRadius.circular(15),
                                onTap: isDriver
                                    ? () => RidePassengersModal.show(
                                        context,
                                        ride,
                                      )
                                    : null,
                                child: buildRideCard(ride, isDriver),
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

  Widget buildRideCard(Map<String, dynamic> ride, bool isDriver) {
    final departureDate = DateTime.parse(ride['departureTime'].toString());

    final departureCity =
        ride['departureCity'] ?? ride['departureCityName'] ?? "";
    final destinationCity =
        ride['destinationCity'] ?? ride['destinationCityName'] ?? "";

    final vehicleText =
        ride['vehicle'] ??
        "${ride['vehicleMake'] ?? ''} ${ride['vehicleModel'] ?? ''} (${ride['vehicleYear'] ?? ''})";

    final price = ride['pricePerSeat'] ?? 0;
    final passengersCount = ride['passengersCount'] ?? 0;
    final availableSeats = ride['availableSeats'] ?? 0;

    final rideId = ride['id'];
    final status = ride['status'].toString();

    final bool isCancelled =
        status == "2" || status.toLowerCase() == "cancelled";
    final bool isCompleted =
        status == "3" || status.toLowerCase() == "completed";

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: isDriver
                        ? Colors.deepPurple.withOpacity(0.1)
                        : Colors.teal.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: isDriver ? Colors.deepPurple : Colors.teal,
                    ),
                  ),
                  child: Text(
                    isDriver ? "шофьор" : "пътник",
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: isDriver ? Colors.deepPurple : Colors.teal,
                    ),
                  ),
                ),
                Row(
                  children: [
                    Text(
                      price.toString(),
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                      ),
                    ),
                    const SizedBox(width: 6),
                    const Icon(Icons.euro, size: 18, color: Colors.green),
                  ],
                ),
              ],
            ),
          ),

          ListTile(
            title: Text(
              "$departureCity → $destinationCity",
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            subtitle: Text(
              DateFormat('dd.MM.yyyy • HH:mm').format(departureDate),
            ),
          ),

          const Divider(),

          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                const Icon(Icons.directions_car, size: 16, color: Colors.grey),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(vehicleText, overflow: TextOverflow.ellipsis),
                ),
                const SizedBox(width: 8),
                Text("$passengersCount заети"),
                const SizedBox(width: 8),
                Text(
                  "$availableSeats свободни",
                  style: TextStyle(color: Colors.grey.shade600),
                ),
              ],
            ),
          ),

          if (isCancelled || isCompleted)
            Padding(
              padding: const EdgeInsets.only(left: 12, right: 12, bottom: 12),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                  color: isCancelled
                      ? Colors.red.withOpacity(0.08)
                      : Colors.green.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: isCancelled ? Colors.red : Colors.green,
                  ),
                ),
                child: Text(
                  isCancelled ? "Отменено пътуване" : "Завършено пътуване",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: isCancelled ? Colors.red : Colors.green,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),

          if (isDriver && showUpcoming && !isCancelled && !isCompleted)
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: rideId == null
                          ? null
                          : () => confirmCancelRide(rideId),
                      icon: const Icon(Icons.cancel_outlined),
                      label: const Text("Отмени"),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.red,
                        side: const BorderSide(color: Colors.red),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: rideId == null
                          ? null
                          : () => confirmFinishRide(rideId),
                      icon: const Icon(Icons.check_circle_outline),
                      label: const Text("Завърши"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        foregroundColor: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
