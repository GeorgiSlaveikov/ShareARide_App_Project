import 'package:flutter/material.dart';

import '../controllers/userUtils.dart';
import '../controllers/bookingUtils.dart';

import '../infoPopupModals/userDetailModal.dart';
import '../widgets/rideMapPreview.dart';
import '../entity/city.dart';
import '../controllers/notificationService.dart';

import '../pages/editOfferPage.dart';
import '../entity/offer.dart';

class OfferCard extends StatefulWidget {
  final Offer offer;
  final bool isMyOffer;
  final VoidCallback onOfferUpdate;

  const OfferCard({
    super.key,
    required this.offer,
    required this.isMyOffer,
    required this.onOfferUpdate,
  });

  @override
  State<OfferCard> createState() => _OfferCardState();
}

class _OfferCardState extends State<OfferCard> {
  bool isOfferRequested = false;
  bool canRequestAgain = false;

  String bookingStatusLabel = "";
  Color bookingStatusColor = Colors.orange;
  IconData bookingStatusIcon = Icons.watch_later_outlined;

  @override
  void initState() {
    super.initState();
    checkIfRequested();
  }

  Future<void> checkIfRequested() async {
    final currentUserId = await UserUtils.getCurrentUserId();
    final bookings = await BookingUtils.getBookingsFromMe(currentUserId);

    if (!mounted) return;

    final matchingBookings = bookings
        .where((b) => b.offerId.toString() == widget.offer.id.toString())
        .toList();

    if (matchingBookings.isEmpty) {
      setState(() {
        isOfferRequested = false;
        canRequestAgain = false;
        bookingStatusLabel = "";
      });
      return;
    }

    final booking = matchingBookings.first;
    final status = booking.status.toString().toLowerCase();

    setState(() {
      isOfferRequested = true;
      canRequestAgain = false;

      if (status == "0" || status.contains("pending")) {
        bookingStatusLabel = "Изчакване на отговор";
        bookingStatusColor = const Color.fromARGB(255, 245, 143, 47);
        bookingStatusIcon = Icons.watch_later_outlined;
      } else if (status == "1" || status.contains("accepted")) {
        bookingStatusLabel = "Заявката е приета";
        bookingStatusColor = Colors.green;
        bookingStatusIcon = Icons.check_circle_outline;
      } else if (status == "2" || status.contains("rejected")) {
        bookingStatusLabel = "Заявката е отхвърлена";
        bookingStatusColor = Colors.red;
        bookingStatusIcon = Icons.cancel_outlined;

        // Change this to false if you do NOT want rejected users to request again.
        canRequestAgain = true;
      } else {
        bookingStatusLabel = "Заявено";
        bookingStatusColor = Colors.grey;
        bookingStatusIcon = Icons.info_outline;
      }
    });
  }

  void onRequestConfirm() {
    setState(() {
      isOfferRequested = true;
      canRequestAgain = false;
      bookingStatusLabel = "Изчакване на отговор";
      bookingStatusColor = const Color.fromARGB(255, 245, 143, 47);
      bookingStatusIcon = Icons.watch_later_outlined;
    });
  }

  String formatDateTime(String dateTimeStr) {
    final dt = DateTime.parse(dateTimeStr);
    final minuteStr = dt.minute < 10 ? "0${dt.minute}" : "${dt.minute}";
    return "${dt.day}-${dt.month}-${dt.year} at ${dt.hour}:$minuteStr";
  }

  @override
  Widget build(BuildContext context) {
    final offer = widget.offer;

    final bool shouldDisableRequestButton =
        offer.availableSeats <= 0 || (isOfferRequested && !canRequestAgain);

    return Card(
      elevation: 3,
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            buildHeader(offer),
            const Divider(height: 24),
            buildOfferInfoAndAction(offer, shouldDisableRequestButton),
            const SizedBox(height: 12),
            buildFooter(offer),
          ],
        ),
      ),
    );
  }

  Widget buildHeader(Offer offer) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "${offer.departureCityName} → ${offer.destinationCityName}",
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 4),
              Text(
                formatDateTime(offer.departureTime.toString()),
                style: TextStyle(color: Colors.grey[600]),
              ),
            ],
          ),
        ),
        const SizedBox(width: 12),
        Row(
          children: [
            Text(
              "${offer.pricePerSeat.toStringAsFixed(2)}",
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.deepPurple,
              ),
            ),
            const SizedBox(width: 4),
            Icon(Icons.euro, size: 20, color: Colors.deepPurple),
          ],
        ),
      ],
    );
  }

  Widget buildOfferInfoAndAction(Offer offer, bool shouldDisableRequestButton) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              buildDriverRow(offer),
              const SizedBox(height: 8),
              buildVehicleRow(offer),
              buildSeatsRow(offer),
              const SizedBox(height: 8),
              buildMapButton(offer),
            ],
          ),
        ),
        const SizedBox(width: 12),
        widget.isMyOffer
            ? buildEditButton(offer)
            : buildRequestButton(offer, shouldDisableRequestButton),
      ],
    );
  }

  Widget buildDriverRow(Offer offer) {
  final bool showPhone =
      !widget.isMyOffer && offer.driverPhoneNumber.trim().isNotEmpty;

  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          InkWell(
            borderRadius: BorderRadius.circular(20),
            onTap: () async {
              final user = await UserUtils.getUser(offer.driverId);

              if (!mounted) return;

              if (user != null) {
                UserDetailModal.show(context, user);
              }
            },
            child: const CircleAvatar(
              radius: 13,
              backgroundColor: Colors.deepPurple,
              child: Icon(
                Icons.person,
                size: 16,
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Flexible(
            child: Text(
              widget.isMyOffer ? "${offer.driverName} [Вие]" : offer.driverName,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),

      if (showPhone) ...[
        const SizedBox(height: 4),
        Padding(
          padding: const EdgeInsets.only(left: 34),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.phone_outlined,
                size: 14,
                color: Colors.grey.shade600,
              ),
              const SizedBox(width: 4),
              Flexible(
                child: Text(
                  offer.driverPhoneNumber,
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey.shade700,
                    fontWeight: FontWeight.w400,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ],
    ],
  );
}

  Widget buildVehicleRow(Offer offer) {
    return Row(
      children: [
        const Icon(Icons.airport_shuttle_rounded, size: 16, color: Colors.grey),
        const SizedBox(width: 4),
        Flexible(
          child: Text(
            "${offer.vehicleMake} ${offer.vehicleModel}",
            style: const TextStyle(color: Colors.grey),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Widget buildSeatsRow(Offer offer) {
    return Row(
      children: [
        const Icon(Icons.event_seat, size: 16, color: Colors.grey),
        const SizedBox(width: 4),
        Text(
          "${offer.availableSeats} свободни места",
          style: TextStyle(
            color: offer.availableSeats <= 0 ? Colors.red : Colors.grey,
          ),
        ),
      ],
    );
  }

  Widget buildMapButton(Offer offer) {
    return InkWell(
      onTap: () => showMapDialog(offer),
      child: const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.map_outlined, size: 16, color: Colors.deepPurple),
          SizedBox(width: 4),
          Text(
            "Виж карта",
            style: TextStyle(
              color: Colors.deepPurple,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget buildRequestButton(Offer offer, bool shouldDisableRequestButton) {
    String buttonText = "Заяви";

    if (isOfferRequested && !canRequestAgain) {
      buttonText = "Заявено";
    }

    if (canRequestAgain) {
      buttonText = "Заяви отново";
    }

    return ElevatedButton(
      onPressed: shouldDisableRequestButton
          ? null
          : () => showSeatSelectionDialog(offer),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
        disabledBackgroundColor: Colors.grey.shade300,
        disabledForegroundColor: Colors.grey.shade700,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
      child: Text(buttonText),
    );
  }

  Widget buildEditButton(Offer offer) {
    return ElevatedButton.icon(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => EditOfferPage(
              offer: offer,
              onOfferUpdated: widget.onOfferUpdate,
            ),
          ),
        );
      },
      icon: const Icon(Icons.edit_note, size: 20),
      label: const Text("Редактирай"),
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF673AB7),
        foregroundColor: Colors.white,
        elevation: 0,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),
    );
  }

  Widget buildFooter(Offer offer) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        !widget.isMyOffer && isOfferRequested
            ? Flexible(
                child: Row(
                  children: [
                    Icon(
                      bookingStatusIcon,
                      size: 16,
                      color: bookingStatusColor,
                    ),
                    const SizedBox(width: 4),
                    Flexible(
                      child: Text(
                        bookingStatusLabel,
                        style: TextStyle(
                          fontSize: 13,
                          color: bookingStatusColor,
                          fontStyle: FontStyle.italic,
                          fontWeight: FontWeight.bold,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              )
            : const SizedBox(),
        const SizedBox(width: 8),
        Flexible(
          child: Align(
            alignment: Alignment.centerRight,
            child: Text(
              offer.createdAt != null
                  ? "Качено на ${formatDateTime(offer.createdAt.toString())}"
                  : "",
              style: TextStyle(
                fontSize: 13,
                color: Colors.grey[500],
                fontStyle: FontStyle.italic,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ),
      ],
    );
  }

  void showMapDialog(Offer offer) {
    final City? departureCity = offer.departureCity;
    final City? destinationCity = offer.destinationCity;

    if (departureCity == null || destinationCity == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Липсват данни за картата."),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    if (!departureCity.hasCoordinates || !destinationCity.hasCoordinates) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Липсват координати за градовете."),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("${departureCity.name} → ${destinationCity.name}"),
          content: SizedBox(
            width: double.maxFinite,
            child: RideMapPreview(
              departureCity: departureCity,
              destinationCity: destinationCity,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Затвори"),
            ),
          ],
        );
      },
    );
  }

  void showSeatSelectionDialog(Offer offer) {
    int selectedSeats = 1;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) {
          return AlertDialog(
            title: const Text("Избери брой места"),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text("Колко човека пътуват?"),
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
                      onPressed: selectedSeats < offer.availableSeats
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
                child: const Text("Откажи"),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  showBookingDialog(offer, selectedSeats);
                },
                child: const Text("Напред"),
              ),
            ],
          );
        },
      ),
    );
  }

  void showBookingDialog(Offer offer, int bookedSeats) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Потвърди заявката"),
        content: Text(
          bookedSeats == 1
              ? "Заявка за $bookedSeats място от ${offer.departureCityName} до ${offer.destinationCityName}?"
              : "Заявка за $bookedSeats места от ${offer.departureCityName} до ${offer.destinationCityName}?",
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Откажи"),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(context);

              final currentUserId = await UserUtils.getCurrentUserId();

              final success = await BookingUtils.createBooking(
                offer.driverId,
                currentUserId,
                offer.id!,
                bookedSeats,
              );

              if (success) {
                onRequestConfirm();

                final DateTime departureTime = DateTime.parse(
                  offer.departureTime.toString(),
                );

                await NotificationService.scheduleRideReminder(
                  notificationId: offer.id!,
                  departureTime: departureTime,
                );

                if (!mounted) return;

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text(
                      "Заявката е изпратена успешно! Напомнянето е създадено.",
                    ),
                    backgroundColor: Colors.green,
                    behavior: SnackBarBehavior.floating,
                    dismissDirection: DismissDirection.horizontal,
                  ),
                );

                // Optional refresh from parent.
                widget.onOfferUpdate();
              } else {
                if (!mounted) return;

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("Неуспешно създаване на заявка."),
                    backgroundColor: Colors.red,
                    behavior: SnackBarBehavior.floating,
                    dismissDirection: DismissDirection.horizontal,
                  ),
                );
              }
            },
            child: const Text("Потвърди"),
          ),
        ],
      ),
    );
  }
}
