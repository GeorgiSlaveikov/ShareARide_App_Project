import 'package:flutter/material.dart';
import '../controllers/userUtils.dart';
import '../controllers/bookingUtils.dart';
import '../infoPopupModals/userDetailsModal.dart';

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
    // print('Offer card: ${widget.offer['id']}');
    // var currentUserId = await UserUtils.getCurrentUserId();
    // var bookings = await BookingUtils.getBookingsFromMe(currentUserId);
    // var requestedOfferIds = bookings.map((b) => b.offerId).toList();
    // print("Bookings for me: $requestedOfferIds");
    // if (mounted && requestedOfferIds.contains(widget.offer['id'])) {
    //   print(
    //     'requested offer found: ${widget.offer['id']} - setting state to requested true',
    //   );
    //   setState(() {
    //     isOfferRequested = true;
    //   });
    // }
    var currentUserId = await UserUtils.getCurrentUserId();
    // Ensure this utility is actually hitting your API and returning List<Booking>
    var bookings = await BookingUtils.getBookingsFromMe(currentUserId);

    // LOG THIS: See if the list is empty or if IDs are different types
    print(
      "DEBUG: Checking Offer ID ${widget.offer['id']} against user bookings: ${bookings.map((b) => b.offerId).toList()}",
    );

    if (mounted) {
      // Use .any to be safe with object comparison
      bool exists = bookings.any(
        (b) => b.offerId.toString() == widget.offer['id'].toString(),
      );

      if (exists) {
        setState(() {
          isOfferRequested = true;
        });
      }
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
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      formatDateTime(offer['date']),
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                  ],
                ),
                Text(
                  "\$${offer['price']}",
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.deepPurple,
                  ),
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
                        InkWell(
                          onTap: () async {
                            var user = await UserUtils.getUser(offer['driverId']);
                            // UserDetailModal.show(context, {
                            //   "fullName":
                            //       "${user?.firstName} ${user?.lastName}",
                            //   "username": user?.username,
                            //   "email": user?.email,
                            //   "age": user?.age,
                            //   "phoneNumber": user?.phoneNumber,
                            // });
                            UserDetailModal.show(context, user!);
                          },
                          child: const CircleAvatar(
                            radius: 12,
                            child: Icon(Icons.person, size: 16),
                          ),
                        ),
                        const SizedBox(width: 8),
                        widget.isMyOffer
                            ? Text(
                                "${offer['driver']} [You]",
                                style: const TextStyle(
                                  fontWeight: FontWeight.w500,
                                ),
                              )
                            : Text(
                                offer['driver'],
                                style: const TextStyle(
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Icon(
                          Icons.airport_shuttle_rounded,
                          size: 16,
                          color: Colors.grey,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          "${offer['vehicle']['make']} ${offer['vehicle']['model']}",
                          style: const TextStyle(color: Colors.grey),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        const Icon(
                          Icons.event_seat,
                          size: 16,
                          color: Colors.grey,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          "${offer['availableSeats']} seats left",
                          style: const TextStyle(color: Colors.grey),
                        ),
                      ],
                    ),
                  ],
                ),
                !widget.isMyOffer
                    ? ElevatedButton(
                        onPressed: isOfferRequested
                            ? null
                            : () => showSeatSelectionDialog(offer),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.deepPurple,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: Text(isOfferRequested ? "Requested" : "Request"),
                      )
                    : ElevatedButton.icon(
                        onPressed: () {},
                        icon: const Icon(Icons.edit_note, size: 20),
                        label: const Text("Edit Offer"),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(
                            0xFF673AB7,
                          ), // Deep Orange
                          foregroundColor: Colors.white,
                          elevation: 0, // Flat looks better on these cards
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 10,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                              20,
                            ), // Pill shape fits your card style
                          ),
                        ),
                      ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                !widget.isMyOffer && isOfferRequested
                    ? Align(
                        alignment: Alignment.centerRight,
                        child: Row(
                          children: [
                            Icon(
                              Icons.watch_later_outlined,
                              size: 16,
                              color: const Color.fromARGB(255, 245, 143, 47),
                            ),
                            const SizedBox(width: 4),
                            Text(
                              "Waiting for response",
                              style: TextStyle(
                                fontSize: 13,
                                color: const Color.fromARGB(255, 245, 143, 47),
                                fontStyle: FontStyle.italic,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      )
                    : Container(),
                Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    "Posted on ${formatDateTime(offer['createdAt'])}",
                    style: TextStyle(
                      fontSize: 13,
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

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) {
          return AlertDialog(
            title: const Text("Select Number of Seats"),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text("How many people are traveling?"),
                const SizedBox(height: 15),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      onPressed: selectedSeats > 1
                          ? () => setDialogState(() => selectedSeats--)
                          : null,
                      icon: const Icon(
                        Icons.remove_circle_outline,
                        color: Colors.deepPurple,
                      ),
                      iconSize: 25,
                    ),
                    const SizedBox(width: 5),
                    Text(
                      selectedSeats.toString(),
                      style: const TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(width: 5),
                    IconButton(
                      onPressed:
                          selectedSeats <
                              int.parse(offer['availableSeats'].toString())
                          ? () => setDialogState(() => selectedSeats++)
                          : null,
                      icon: const Icon(
                        Icons.add_circle_outline,
                        color: Colors.deepPurple,
                      ),
                      iconSize: 25,
                    ),
                  ],
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("Cancel"),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context); // Close seat picker
                  showBookingDialog(
                    offer,
                    selectedSeats,
                  ); // Pass seats to next dialog
                },
                child: const Text("Next"),
              ),
            ],
          );
        },
      ),
    );
  }

  void showBookingDialog(Map<String, dynamic> offer, int bookedSeats) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Confirm Request"),
        content: Text(
          "Request $bookedSeats seat(s) from ${offer['from']} to ${offer['to']}?\n",
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(context);

              var currentUserId = await UserUtils.getCurrentUserId();
              bool success = await BookingUtils.createBooking(
                offer["driverId"],
                currentUserId,
                offer["id"],
              );

              if (success) {
                onRequestConfirm();
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Booking successful!"),
                      backgroundColor: Colors.green,
                      behavior: SnackBarBehavior.floating,
                      dismissDirection: DismissDirection.horizontal,
                    ),
                  );
                }
              } else {
                // Handle error (400 or connection)
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Failed to create booking."),
                      backgroundColor: Colors.red,
                      behavior: SnackBarBehavior.floating,
                      dismissDirection: DismissDirection.horizontal,
                    ),
                  );
                }
              }
            },
            child: const Text("Confirm"),
          ),
        ],
      ),
    );
  }
}
