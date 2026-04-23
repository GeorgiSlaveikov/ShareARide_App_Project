import 'package:flutter/material.dart';
import '../controllers/userUtils.dart';
import '../controllers/bookingUtils.dart';

class OfferCard extends StatefulWidget {
  final Map<String, dynamic> offer;
  final bool isMyOffer;
  const OfferCard({super.key, required this.offer, required this.isMyOffer});

  @override
  State<OfferCard> createState() => _OfferCardState();
}

class _OfferCardState extends State<OfferCard> {
  bool isOfferRequested = false;

  @override
  void initState() {
    super.initState();
    checkIfRequested();
  }

  void checkIfRequested() async {
    print('Offer card: ${widget.offer['id']}');
    var currentUserId = await UserUtils.getCurrentUserId();
    var bookings = await BookingUtils.getBookingsFromMe(currentUserId);
    var requestedOfferIds = bookings.map((b) => b.offerId).toList();
    print("Bookings for me: $requestedOfferIds");
    if (mounted && requestedOfferIds.contains(widget.offer['id'])) {
      print('requested offer found: ${widget.offer['id']} - setting state to requested true');
      setState(() {
        isOfferRequested = true;
      });
    }
  }

  void onRequestConfirm() {
    setState(() {
      isOfferRequested = true;
    });
  }

  String formatDateTime(String dateTimeStr) {
    var dt = DateTime.parse(dateTimeStr);
    var minuteStr = dt.minute < 10 ? "0${dt.minute}" : "${dt.minute}";
    return "${dt.day}-${dt.month}-${dt.year} at ${dt.hour}:$minuteStr";
  }

  @override
  Widget build(BuildContext context) {
    final offer = widget.offer;

    return Card(
      elevation: 3,
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "${offer['from']} → ${offer['to']}",
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 4),
                    Text(formatDateTime(offer['date']), style: TextStyle(color: Colors.grey[600])),
                  ],
                ),
                Text(
                  "\$${offer['price']}",
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.deepPurple),
                ),
              ],
            ),
            const Divider(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const CircleAvatar(radius: 12, child: Icon(Icons.person, size: 16)),
                        const SizedBox(width: 8),
                        Text(offer['driver'], style: const TextStyle(fontWeight: FontWeight.w500)),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Icon(Icons.airport_shuttle_rounded, size: 16, color: Colors.grey),
                        const SizedBox(width: 4),
                        Text("${offer['vehicle']['make']} ${offer['vehicle']['model']}", style: const TextStyle(color: Colors.grey)),
                      ],
                    ),
                    Row(
                      children: [
                        const Icon(Icons.event_seat, size: 16, color: Colors.grey),
                        const SizedBox(width: 4),
                        Text("${offer['seats']} seats left", style: const TextStyle(color: Colors.grey)),
                      ],
                    ),
                  ],
                ),
                !widget.isMyOffer ?
                ElevatedButton(
                  onPressed: isOfferRequested 
                      ? null
                      : () => showSeatSelectionDialog(offer),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurple,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  child: Text(isOfferRequested ? "Requested" : "Request"),
                ) : Container(),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                !widget.isMyOffer && isOfferRequested
                    ? Align(
                        alignment: Alignment.centerRight,
                        child: Text(
                          "Requested",
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.red[500],
                            fontStyle: FontStyle.italic,
                            fontWeight: FontWeight.bold
                          ),
                        ),
                      )
                    : Container(),
                Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    "Posted on: ${formatDateTime(offer['createdAt'])}",
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[500],
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ),
              ],
            ), 
          ],
        ),
      ),
    );
  }

  void showSeatSelectionDialog(Map<String, dynamic> offer) {
    int selectedSeats = 1;
    List<TextEditingController> nameControllers = [];

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) {
          return AlertDialog(
            title: const Text("Select Number of Seats"),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text("How many people are traveling?"),
                  const SizedBox(height: 15),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        onPressed: selectedSeats > 1 ? () => setDialogState(() {
                          selectedSeats--;
                          nameControllers.removeLast();
                        }) : null,
                        icon: const Icon(Icons.remove_circle_outline, color: Colors.deepPurple),
                      ),
                      Text(selectedSeats.toString(), style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                      IconButton(
                        onPressed: selectedSeats < 5 ? () => setDialogState(() {
                          selectedSeats++;
                          nameControllers.add(TextEditingController());
                        }) : null,
                        icon: const Icon(Icons.add_circle_outline, color: Colors.deepPurple),
                      ),
                    ],
                  ),
                  const Divider(),
                  buildPassengerNameCard("Passenger 1 (You)", isFixed: true),
                  ...List.generate(nameControllers.length, (index) => buildPassengerNameCard("Passenger ${index + 2}", controller: nameControllers[index])),
                ],
              ),
            ),
            actions: [
              TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancel")),
              ElevatedButton(
                onPressed: () {
                  List<String> allNames = ["You"];
                  allNames.addAll(nameControllers.map((c) => c.text.isEmpty ? "Guest" : c.text));
                  Navigator.pop(context);
                  showBookingDialog(offer, allNames);
                },
                child: const Text("Send Request"),
              ),
            ],
          );
        },
      ),
    );
  }

  void showBookingDialog(Map<String, dynamic> offer, List<String> allNames) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Confirm Request"),
        content: Text("Request seat from ${offer['from']} to ${offer['to']}?"),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancel")),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(context);
              var currentUserId = await UserUtils.getCurrentUserId();
              await BookingUtils.createBooking(offer["driverId"], currentUserId, offer["id"], allNames);
              onRequestConfirm();
              if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Booking successful!"), backgroundColor: Colors.green));
              }
            },
            child: const Text("Confirm"),
          ),
        ],
      ),
    );
  }

  Widget buildPassengerNameCard(String label, {bool isFixed = false, TextEditingController? controller}) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4),
      color: isFixed ? Colors.deepPurple.withOpacity(0.05) : Colors.white,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: isFixed
            ? ListTile(leading: const Icon(Icons.person, color: Colors.deepPurple), title: Text(label, style: const TextStyle(fontWeight: FontWeight.bold)))
            : TextField(controller: controller, decoration: InputDecoration(labelText: label, prefixIcon: const Icon(Icons.person_outline))),
      ),
    );
  }
}