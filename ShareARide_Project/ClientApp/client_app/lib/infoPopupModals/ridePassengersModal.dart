import 'package:flutter/material.dart';

import '../controllers/userUtils.dart';
import '../controllers/utils.dart';
import '../entity/user.dart';

class RidePassengersModal extends StatefulWidget {
  final Map<String, dynamic> ride;

  const RidePassengersModal({super.key, required this.ride});

  static void show(BuildContext context, Map<String, dynamic> ride) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => RidePassengersModal(ride: ride),
    );
  }

  @override
  State<RidePassengersModal> createState() => _RidePassengersModalState();
}

class _RidePassengersModalState extends State<RidePassengersModal> {
  bool isLoading = true;
  List<Map<String, dynamic>> passengers = [];

  @override
  void initState() {
    super.initState();
    loadPassengers();
  }

  Future<void> loadPassengers() async {
    final bookingsRaw = widget.ride['databaseBookings'];

    print(bookingsRaw);

    if (bookingsRaw == null || bookingsRaw is! List) {
      if (!mounted) return;

      setState(() {
        passengers = [];
        isLoading = false;
      });

      return;
    }

    final acceptedBookings = bookingsRaw.where((booking) {
      final status = booking['status'].toString();

      return status == "1" || status.toLowerCase() == "accepted";
    }).toList();

    final loadedPassengers = <Map<String, dynamic>>[];

    for (final booking in acceptedBookings) {
      final passengerId = booking['requesterId'];

      if (passengerId == null) {
        continue;
      }

      final User? user = await UserUtils.getUser(passengerId);

      if (user == null) {
        continue;
      }

      loadedPassengers.add({
        "user": user,
        "bookedSeats": booking['bookedSeats'] ?? 0,
      });
    }

    if (!mounted) return;

    setState(() {
      passengers = loadedPassengers;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final departureCity =
        widget.ride['departureCity'] ?? widget.ride['departureCityName'] ?? "";
    final destinationCity =
        widget.ride['destinationCity'] ??
        widget.ride['destinationCityName'] ??
        "";

    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.85,
      ),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40,
            height: 5,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(10),
            ),
          ),

          const SizedBox(height: 20),

          const Text(
            "Пътници",
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),

          const SizedBox(height: 6),

          Text(
            "$departureCity → $destinationCity",
            style: TextStyle(color: Colors.grey.shade600, fontSize: 15),
          ),

          const Divider(height: 30),

          if (isLoading)
            const Padding(
              padding: EdgeInsets.all(30),
              child: CircularProgressIndicator(color: Colors.deepPurple),
            )
          else if (passengers.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 40),
              child: Column(
                children: [
                  Icon(
                    Icons.people_outline,
                    size: 70,
                    color: Colors.grey.shade300,
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    "Все още няма приети пътници",
                    style: TextStyle(color: Colors.grey, fontSize: 16),
                  ),
                ],
              ),
            )
          else
            Flexible(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: passengers.length,
                itemBuilder: (context, index) {
                  final passengerData = passengers[index];
                  final User user = passengerData['user'];
                  final int bookedSeats = passengerData['bookedSeats'];

                  return buildPassengerTile(user, bookedSeats);
                },
              ),
            ),

          const SizedBox(height: 20),

          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurple,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.symmetric(vertical: 15),
              ),
              child: const Text("Затвори"),
            ),
          ),

          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget buildPassengerTile(User user, int bookedSeats) {
    final hasImage =
        user.profilePicturePath != null && user.profilePicturePath!.isNotEmpty;

    final fullImageUrl = hasImage
        ? "http://${Utils().ip}:5205${user.profilePicturePath}"
        : "";

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 28,
            backgroundColor: Colors.grey.shade200,
            backgroundImage: hasImage ? NetworkImage(fullImageUrl) : null,
            child: !hasImage
                ? Icon(Icons.person, color: Colors.grey.shade500, size: 30)
                : null,
          ),

          const SizedBox(width: 14),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "${user.firstName} ${user.lastName}",
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  "${user.age} години",
                  style: TextStyle(color: Colors.grey.shade600),
                ),
              ],
            ),
          ),

          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.deepPurple.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              "$bookedSeats места",
              style: const TextStyle(
                color: Colors.deepPurple,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
