// import 'package:client_app/controllers/cityUtils.dart';
// import 'package:client_app/entity/booking.dart';
import 'package:flutter/material.dart';
import '../controllers/bookingUtils.dart';
import '../controllers/userUtils.dart';
// import '../controllers/offerUtils.dart';

import '../widgets/pageEmptyState.dart';

class RequestsPage extends StatefulWidget {
  const RequestsPage({super.key});

  @override
  State<RequestsPage> createState() => _RequestsPageState();
}

class _RequestsPageState extends State<RequestsPage> {
  @override
  void initState() {
    super.initState();
    fetchBookingsForMe();
  }

  List<Map<String, dynamic>> incomingRequests = [];

  void fetchBookingsForMe() async {
    var currentUserId = UserUtils.getCurrentUserId();
    var bookings = await BookingUtils.getBookingsForMe(currentUserId);
    var mappedOffers = await Future.wait(
      bookings.map((booking) async {
        return {
          "requestedForId": booking.requestedForId,
          "requesterFullName": booking.requesterName,
          "offerId": booking.offerId,
          "rating": 5.0,
          "trip": "${booking.departureCityName} → ${booking.destinationCityName}",
          "date": booking.departureTime,
          "seats": booking.bookedSeats,
        };
      }).toList(),
    );

    setState(() {
      incomingRequests = mappedOffers;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: const Text(
          "Booking Requests",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: false,
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: incomingRequests.isEmpty
          ? pageEmptyState(
            Icons.checklist_rtl_rounded, 
            Colors.grey.shade300, 
            "No pending requests", 
            Colors.grey
          )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: incomingRequests.length,
              itemBuilder: (context, index) {
                final req = incomingRequests[index];
                return buildRequestCard(req, index);
              },
            ),
    );
  }

  Widget buildRequestCard(Map<String, dynamic> req, int index) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Column(
        children: [
          ListTile(
            leading: const CircleAvatar(child: Icon(Icons.person)),
            title: Text(
              req['requesterFullName'] ?? "Unknown User",
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Row(
              children: [
                const Icon(Icons.star, color: Colors.orange, size: 16),
                Text(" ${req['rating']} Passenger Rating"),
              ],
            ),
            trailing: Text(
              "${req['seats']} Seat(s)",
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          const Divider(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                const Icon(Icons.info_outline, size: 16, color: Colors.grey),
                const SizedBox(width: 8),
                Text("Wants to join your ${req['trip']} trip"),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => handleRequest(index, false),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.red,
                    ),
                    child: const Text("Reject"),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => handleRequest(index, true),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                    ),
                    child: const Text("Accept"),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void handleRequest(int index, bool accepted) {
    // Logic to call your API to Update Status to 'Accepted' or 'Rejected'
    setState(() {
      incomingRequests.removeAt(index);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(accepted ? "Passenger accepted!" : "Request declined."),
        backgroundColor: accepted ? Colors.green : Colors.red,
      ),
    );
  }

  // Widget buildEmptyState() {
  //   return Center(
  //     child: Column(
  //       mainAxisAlignment: MainAxisAlignment.center,
  //       children: [
  //         Icon(
  //           Icons.checklist_rtl_rounded,
  //           size: 80,
  //           color: Colors.grey.shade300,
  //         ),
  //         const SizedBox(height: 16),
  //         const Text(
  //           "No pending requests",
  //           style: TextStyle(fontSize: 18, color: Colors.grey),
  //         ),
  //       ],
  //     ),
  //   );
  // }
}
