import 'package:client_app/controllers/bookingUtils.dart';
import 'package:client_app/controllers/userUtils.dart';
import 'package:flutter/material.dart';
import '../pages/requestsPage.dart';

// import '../widgets/pendingRequestsPreview.dart';

class PendingRequestsPreview extends StatefulWidget {
  final BuildContext context;
  const PendingRequestsPreview({super.key, required this.context});

  @override
  State<PendingRequestsPreview> createState() => _PendingRequestsPreviewState();
}

class _PendingRequestsPreviewState extends State<PendingRequestsPreview> {
  int requestCount = 0;
  String firstWaitingUserName = '';

  void fetchBookingRequestsForCurrentUser() async {
    var currentUserId = UserUtils.getCurrentUserId();

    var bookings = await BookingUtils.getBookingsForMe(currentUserId);

    if (bookings.isEmpty) {
      return;
    }

    var count = bookings.length;
    var name = bookings[0].requesterName;

    setState(() {
      requestCount = count;
      firstWaitingUserName = name;
    });  
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchBookingRequestsForCurrentUser();
  }

  @override
  Widget build(BuildContext context) {
    return requestCount > 0 ? Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              "Pending Requests",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            if (requestCount > 0)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  "$requestCount New",
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
          ],
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.deepPurple.withOpacity(0.05),
            borderRadius: BorderRadius.circular(15),
            border: Border.all(color: Colors.deepPurple.withOpacity(0.1)),
          ),
          child: Row(
            children: [
              const CircleAvatar(
                backgroundColor: Colors.deepPurple,
                child: Icon(Icons.people, color: Colors.white),
              ),
              const SizedBox(width: 15),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    requestCount-1 > 0 ? Text(
                      "$firstWaitingUserName and ${requestCount-1} other",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ) : Text(
                      firstWaitingUserName,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      "want to join your trip",
                      style: TextStyle(fontSize: 13, color: Colors.black54),
                    ),
                  ],
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const RequestsPage()),
                  );
                },
                child: const Text("View All"),
              ),
            ],
          ),
        ),
      ],
    ) : Container();
  }
}