// // import 'package:client_app/controllers/cityUtils.dart';
// // import 'package:client_app/entity/booking.dart';
// import 'package:flutter/material.dart';
// import '../controllers/bookingUtils.dart';
// import '../controllers/userUtils.dart';
// // import '../controllers/offerUtils.dart';

// import '../widgets/pageEmptyState.dart';

// import '../widgets/userDetails.dart';

// class RequestsPage extends StatefulWidget {
//   const RequestsPage({super.key});

//   @override
//   State<RequestsPage> createState() => _RequestsPageState();
// }

// class _RequestsPageState extends State<RequestsPage> {
//   @override
//   void initState() {
//     super.initState();
//     fetchBookingsForMe();
//   }

//   List<Map<String, dynamic>> incomingRequests = [];

//   void fetchBookingsForMe() async {
//     var currentUserId = UserUtils.getCurrentUserId();
//     var bookings = await BookingUtils.getBookingsForMe(currentUserId);
//     var mappedOffers = await Future.wait(
//       bookings.map((booking) async {
//         return {
//           "requestedForId": booking.requestedForId,
//           "requesterFullName": booking.requesterName,
//           "requesterId": booking.requesterId,
//           "offerId": booking.offerId,
//           "age": 18,
//           "trip":
//               "${booking.departureCityName} → ${booking.destinationCityName}",
//           "date": booking.departureTime,
//           "seats": booking.bookedSeats,
//         };
//       }).toList(),
//     );

//     setState(() {
//       incomingRequests = mappedOffers;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.grey.shade50,
//       appBar: AppBar(
//         title: const Text(
//           "Заявки за резервация",
//           style: TextStyle(fontWeight: FontWeight.bold),
//         ),
//         centerTitle: false,
//         backgroundColor: Colors.deepPurple,
//         foregroundColor: Colors.white,
//         elevation: 0,
//       ),
//       body: incomingRequests.isEmpty
//           ? pageEmptyState(
//               Icons.checklist_rtl_rounded,
//               Colors.grey.shade300,
//               "Няма заявки",
//               Colors.grey,
//             )
//           : ListView.builder(
//               padding: const EdgeInsets.all(16),
//               itemCount: incomingRequests.length,
//               itemBuilder: (context, index) {
//                 final req = incomingRequests[index];
//                 return buildRequestCard(req, index, context);
//               },
//             ),
//     );
//   }

//   Widget buildRequestCard(
//     Map<String, dynamic> req,
//     int index,
//     BuildContext context,
//   ) {
//     return Card(
//       margin: const EdgeInsets.only(bottom: 16),
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
//       child: Column(
//         children: [
//           ListTile(
//             leading: InkWell(
//               onTap: () async {
//                 var user = await UserUtils.getUser(req['requesterId']);
//                 UserDetailModal.show(context, user!);
//               },
//               child: const CircleAvatar(child: Icon(Icons.person)),
//             ),
//             title: Text(
//               req['requesterFullName'] ?? "Неизвестен потребител",
//               style: const TextStyle(fontWeight: FontWeight.bold),
//             ),
//             subtitle: Text(" ${req['age']} години"),
//             trailing: Text(
//               "${req['seats']} Места",
//               style: const TextStyle(fontWeight: FontWeight.bold),
//             ),
//           ),
//           const Divider(),
//           Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Row(
//                   children: [
//                     const Icon(Icons.info_outline, size: 16, color: Colors.grey),
//                     const SizedBox(width: 8),
//                     Text("Иска да се присъедини към вашето пътувне"),
//                   ],
//                 ),
//                 Text("${req['trip']}"),
//               ],
//             ),
//           ),
//           Padding(
//             padding: const EdgeInsets.all(12),
//             child: Row(
//               children: [
//                 Expanded(
//                   child: OutlinedButton(
//                     onPressed: () => handleRequest(index, false),
//                     style: OutlinedButton.styleFrom(
//                       foregroundColor: Colors.red,
//                     ),
//                     child: const Text("Отхвърляне"),
//                   ),
//                 ),
//                 const SizedBox(width: 12),
//                 Expanded(
//                   child: ElevatedButton(
//                     onPressed: () => handleRequest(index, true),
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: Colors.green,
//                       foregroundColor: Colors.white,
//                     ),
//                     child: const Text("Приемане"),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   void handleRequest(int index, bool accepted) {
//     // Logic to call your API to Update Status to 'Accepted' or 'Rejected'
//     setState(() {
//       incomingRequests.removeAt(index);
//     });

//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         content: Text(accepted ? "Пътникът е приет!" : "Заявката е отхвърлена."),
//         backgroundColor: accepted ? Colors.green : Colors.red,
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';

import '../controllers/bookingUtils.dart';
import '../controllers/userUtils.dart';
import '../widgets/pageEmptyState.dart';
import '../widgets/requestCard.dart';

class RequestsPage extends StatefulWidget {
  const RequestsPage({super.key});

  @override
  State<RequestsPage> createState() => _RequestsPageState();
}

class _RequestsPageState extends State<RequestsPage> {
  List<Map<String, dynamic>> incomingRequests = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchBookingsForMe();
  }
  
  Future<void> fetchBookingsForMe() async {
  setState(() {
    isLoading = true;
  });

  final currentUserId = await UserUtils.getCurrentUserId();
  final bookings = await BookingUtils.getBookingsForMe(currentUserId);

  final mappedRequests = await Future.wait(
    bookings.map((booking) async {
      final requester = await UserUtils.getUser(booking.requesterId);

      return {
        "id": booking.id,
        "requestedForId": booking.requestedForId,
        "requesterFullName": booking.requesterName,
        "requesterId": booking.requesterId,
        "offerId": booking.offerId,
        "age": requester!.age,
        "trip": "${booking.departureCityName} → ${booking.destinationCityName}",
        "date": booking.departureTime,
        "seats": booking.bookedSeats,
      };
    }).toList(),
  );

  if (!mounted) return;

  setState(() {
    incomingRequests = mappedRequests;
    isLoading = false;
  });
}

  Future<void> refreshRequests() async {
    await fetchBookingsForMe();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: const Text(
          "Заявки за резервация",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: false,
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(color: Colors.deepPurple),
            )
          : RefreshIndicator(
              onRefresh: refreshRequests,
              child: incomingRequests.isEmpty
                  ? ListView(
                      children: [
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.75,
                          child: pageEmptyState(
                            Icons.checklist_rtl_rounded,
                            Colors.grey.shade300,
                            "Няма заявки",
                            Colors.grey,
                          ),
                        ),
                      ],
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: incomingRequests.length,
                      itemBuilder: (context, index) {
                        final request = incomingRequests[index];

                        return RequestCard(
                          request: request,
                          onChanged: fetchBookingsForMe,
                        );
                      },
                    ),
            ),
    );
  }
}
