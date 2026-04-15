import 'package:client_app/controllers/cityUtils.dart';
// import 'package:client_app/entity/booking.dart';
import 'package:flutter/material.dart';
import '../controllers/bookingUtils.dart';
import '../controllers/userUtils.dart';
import '../controllers/offerUtils.dart';

class RequestsPage extends StatefulWidget {
  const RequestsPage({super.key});

  @override
  State<RequestsPage> createState() => _RequestsPageState();
}

class _RequestsPageState extends State<RequestsPage> {
  // Dummy data representing incoming requests for YOUR posted rides
  // List<Map<String, dynamic>> incomingRequests = [
  //   {
  //     "passengerName": "Ivan Georgiev",
  //     "rating": 4.8,
  //     "trip": "Sofia → Plovdiv",
  //     "date": "Tomorrow, 09:00",
  //     "seats": 1,
  //   },
  //   {
  //     "passengerName": "Maria Petrova",
  //     "rating": 5.0,
  //     "trip": "Sofia → Varna",
  //     "date": "Friday, 14:30",
  //     "seats": 2,
  //   },
  // ];

  @override
  void initState() {
    super.initState();
    fetchBookingsForMe();
  }

  List<Map<String, dynamic>> incomingRequests = [];

  void fetchBookingsForMe() async {
    var offers = await BookingUtils.getBookingsForMe(
      UserUtils.getCurrentUserId(),
    );
    var mappedOffers = await Future.wait(
      offers.map((offer) async {
        // Fetch city data asynchronously for each ID

        // final requestedForUser = await UserUtils.getUser(offer.requestedForId);
        final requestorUser = await UserUtils.getUser(offer.requestorId);
        final offerObject = await OfferUtils.getOffer(offer.offerId);
        print("'Requested For' User:");
        print(requestorUser);

        var firstName = requestorUser?.firstName.toString();
        var lastName = requestorUser?.lastName.toString();

        final fromCity = await CityUtils.getCity(offerObject.departureCityId);
        final toCity = await CityUtils.getCity(offerObject.destinationCityId);

        return {
          "requestedForId": offer.requestedForId,
          "requestorFullName": "${firstName ?? ''} ${lastName ?? ''}",
          "offerId": offer.offerId,
          "passengers": offer.passengers,
          "rating": 5.0,
          "trip": "${fromCity.name} → ${toCity.name}",
          "date": offerObject.departureTime.toString(),
          "seats": offer.passengers.length,
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
          ? _buildEmptyState()
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: incomingRequests.length,
              itemBuilder: (context, index) {
                final req = incomingRequests[index];
                return _buildRequestCard(req, index);
              },
            ),
    );
  }

  Widget _buildRequestCard(Map<String, dynamic> req, int index) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Column(
        children: [
          ListTile(
            leading: const CircleAvatar(child: Icon(Icons.person)),
            title: Text(
              req['requestorFullName'] ?? "Unknown User",
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
                    onPressed: () => _handleRequest(index, false),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.red,
                    ),
                    child: const Text("Reject"),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => _handleRequest(index, true),
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

  void _handleRequest(int index, bool accepted) {
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

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.checklist_rtl_rounded,
            size: 80,
            color: Colors.grey.shade300,
          ),
          const SizedBox(height: 16),
          const Text(
            "No pending requests",
            style: TextStyle(fontSize: 18, color: Colors.grey),
          ),
        ],
      ),
    );
  }
}
