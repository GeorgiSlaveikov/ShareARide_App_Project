// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';

// import '../infoPopupModals/ridePassengersModal.dart';

// class RideCard extends StatelessWidget {
//   final Map<String, dynamic> ride;
//   final bool isDriver;
//   final bool showUpcoming;
//   final VoidCallback? onCancel;
//   final VoidCallback? onFinish;

//   const RideCard({
//     super.key,
//     required this.ride,
//     required this.isDriver,
//     required this.showUpcoming,
//     required this.onCancel,
//     required this.onFinish,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return InkWell(
//       borderRadius: BorderRadius.circular(15),
//       onTap: isDriver
//           ? () => RidePassengersModal.show(
//                 context,
//                 ride,
//               )
//           : null,
//       child: buildCard(),
//     );
//   }

//   Widget buildCard() {
//     final departureDate = DateTime.parse(ride['departureTime'].toString());

//     final departureCity =
//         ride['departureCity'] ?? ride['departureCityName'] ?? "";
//     final destinationCity =
//         ride['destinationCity'] ?? ride['destinationCityName'] ?? "";

//     final vehicleText = ride['vehicle'] ??
//         "${ride['vehicleMake'] ?? ''} ${ride['vehicleModel'] ?? ''} (${ride['vehicleYear'] ?? ''})";

//     final price = ride['pricePerSeat'] ?? 0;
//     final passengersCount = ride['passengersCount'] ?? 0;
//     final availableSeats = ride['availableSeats'] ?? 0;

//     final rideId = ride['id'];
//     final status = ride['status'].toString();

//     final bool isCancelled =
//         status == "4" || status.toLowerCase() == "cancelled";

//     final bool isCompleted =
//         status == "3" || status.toLowerCase() == "finished";

//     return Card(
//       margin: const EdgeInsets.only(bottom: 16),
//       elevation: 2,
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(15),
//       ),
//       child: Column(
//         children: [
//           Padding(
//             padding: const EdgeInsets.all(12),
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 buildRoleBadge(),
//                 Row(
//                   children: [
//                     Text(
//                       price.toString(),
//                       style: const TextStyle(
//                         fontWeight: FontWeight.bold,
//                         color: Colors.green,
//                       ),
//                     ),
//                     const SizedBox(width: 6),
//                     const Icon(
//                       Icons.euro,
//                       size: 18,
//                       color: Colors.green,
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ),

//           ListTile(
//             title: Text(
//               "$departureCity → $destinationCity",
//               style: const TextStyle(
//                 fontWeight: FontWeight.bold,
//                 fontSize: 18,
//               ),
//             ),
//             subtitle: Text(
//               DateFormat('dd.MM.yyyy • HH:mm').format(departureDate),
//             ),
//           ),

//           const Divider(),

//           Padding(
//             padding: const EdgeInsets.all(12),
//             child: Row(
//               children: [
//                 const Icon(
//                   Icons.directions_car,
//                   size: 16,
//                   color: Colors.grey,
//                 ),
//                 const SizedBox(width: 8),
//                 Expanded(
//                   child: Text(
//                     vehicleText,
//                     overflow: TextOverflow.ellipsis,
//                   ),
//                 ),
//                 const SizedBox(width: 8),
//                 Text("$passengersCount заети"),
//                 const SizedBox(width: 8),
//                 Text(
//                   "$availableSeats свободни",
//                   style: TextStyle(
//                     color: Colors.grey.shade600,
//                   ),
//                 ),
//               ],
//             ),
//           ),

//           if (isCancelled || isCompleted)
//             buildStatusBanner(
//               isCancelled: isCancelled,
//               isCompleted: isCompleted,
//             ),

//           if (isDriver &&
//               showUpcoming &&
//               !isCancelled &&
//               !isCompleted &&
//               rideId != null)
//             buildDriverActions(),
//         ],
//       ),
//     );
//   }

//   Widget buildRoleBadge() {
//     return Container(
//       padding: const EdgeInsets.symmetric(
//         horizontal: 10,
//         vertical: 4,
//       ),
//       decoration: BoxDecoration(
//         color: isDriver
//             ? Colors.deepPurple.withOpacity(0.1)
//             : Colors.teal.withOpacity(0.1),
//         borderRadius: BorderRadius.circular(20),
//         border: Border.all(
//           color: isDriver ? Colors.deepPurple : Colors.teal,
//         ),
//       ),
//       child: Text(
//         isDriver ? "шофьор" : "пътник",
//         style: TextStyle(
//           fontSize: 10,
//           fontWeight: FontWeight.bold,
//           color: isDriver ? Colors.deepPurple : Colors.teal,
//         ),
//       ),
//     );
//   }

//   Widget buildStatusBanner({
//     required bool isCancelled,
//     required bool isCompleted,
//   }) {
//     return Padding(
//       padding: const EdgeInsets.only(
//         left: 12,
//         right: 12,
//         bottom: 12,
//       ),
//       child: Container(
//         width: double.infinity,
//         padding: const EdgeInsets.symmetric(vertical: 10),
//         decoration: BoxDecoration(
//           color: isCancelled
//               ? Colors.red.withOpacity(0.08)
//               : Colors.green.withOpacity(0.08),
//           borderRadius: BorderRadius.circular(10),
//           border: Border.all(
//             color: isCancelled ? Colors.red : Colors.green,
//           ),
//         ),
//         child: Text(
//           isCancelled ? "Отменено пътуване" : "Завършено пътуване",
//           textAlign: TextAlign.center,
//           style: TextStyle(
//             color: isCancelled ? Colors.red : Colors.green,
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//       ),
//     );
//   }

//   Widget buildDriverActions() {
//     return Padding(
//       padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
//       child: Row(
//         children: [
//           Expanded(
//             child: OutlinedButton.icon(
//               onPressed: onCancel,
//               icon: const Icon(Icons.cancel_outlined),
//               label: const Text("Отмени"),
//               style: OutlinedButton.styleFrom(
//                 foregroundColor: Colors.red,
//                 side: const BorderSide(color: Colors.red),
//               ),
//             ),
//           ),
//           const SizedBox(width: 10),
//           Expanded(
//             child: ElevatedButton.icon(
//               onPressed: onFinish,
//               icon: const Icon(Icons.check_circle_outline),
//               label: const Text("Завърши"),
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: Colors.green,
//                 foregroundColor: Colors.white,
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }


import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../controllers/ratingUtils.dart';
import '../entity/rating.dart';
import '../infoPopupModals/ridePassengersModal.dart';

class RideCard extends StatefulWidget {
  final Map<String, dynamic> ride;
  final bool isDriver;
  final bool showUpcoming;
  final int? currentUserId;
  final VoidCallback? onCancel;
  final VoidCallback? onFinish;
  final VoidCallback? onRatingChanged;

  const RideCard({
    super.key,
    required this.ride,
    required this.isDriver,
    required this.showUpcoming,
    required this.currentUserId,
    required this.onCancel,
    required this.onFinish,
    this.onRatingChanged,
  });

  @override
  State<RideCard> createState() => _RideCardState();
}

class _RideCardState extends State<RideCard> {
  bool isLoadingRating = false;
  bool hasRated = false;

  int selectedRating = 0;
  int existingRating = 0;

  double driverAverageRating = 0;
  int driverRatingsCount = 0;

  @override
  void initState() {
    super.initState();
    loadRatingInfo();
  }

  @override
  void didUpdateWidget(covariant RideCard oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.ride['id'] != widget.ride['id'] ||
        oldWidget.ride['status'] != widget.ride['status']) {
      loadRatingInfo();
    }
  }

  Future<void> loadRatingInfo() async {
    final rideId = widget.ride['id'];
    final driverId = widget.ride['driverId'];
    final currentUserId = widget.currentUserId;

    if (rideId == null || driverId == null || currentUserId == null) {
      return;
    }

    if (!isFinishedRide()) {
      return;
    }

    if (!mounted) return;

    setState(() {
      isLoadingRating = true;
    });

    if (widget.isDriver) {
      final summary = await RatingUtils.getRatingSummary(driverId);

      if (!mounted) return;

      setState(() {
        driverAverageRating = (summary?['rating'] as num?)?.toDouble() ?? 0;
        driverRatingsCount = summary?['ratingsCount'] ?? 0;
        isLoadingRating = false;
      });

      return;
    }

    final Rating? rating = await RatingUtils.getRatingByUserForRide(
      rideId: rideId,
      ratedByUserId: currentUserId,
    );

    if (!mounted) return;

    setState(() {
      hasRated = rating != null;
      existingRating = rating?.score ?? 0;
      selectedRating = rating?.score ?? 0;
      isLoadingRating = false;
    });
  }

  bool isCancelledRide() {
    final status = widget.ride['status'].toString().toLowerCase();

    return status == "4" || status == "cancelled";
  }

  bool isFinishedRide() {
    final status = widget.ride['status'].toString().toLowerCase();

    return status == "3" || status == "finished";
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(15),
      onTap: widget.isDriver
          ? () => RidePassengersModal.show(
                context,
                widget.ride,
              )
          : null,
      child: buildCard(context),
    );
  }

  Widget buildCard(BuildContext context) {
    final departureDate = DateTime.parse(widget.ride['departureTime'].toString());

    final departureCity =
        widget.ride['departureCity'] ?? widget.ride['departureCityName'] ?? "";
    final destinationCity =
        widget.ride['destinationCity'] ?? widget.ride['destinationCityName'] ?? "";

    final vehicleText = widget.ride['vehicle'] ??
        "${widget.ride['vehicleMake'] ?? ''} ${widget.ride['vehicleModel'] ?? ''} (${widget.ride['vehicleYear'] ?? ''})";

    final price = widget.ride['pricePerSeat'] ?? 0;
    final passengersCount = widget.ride['passengersCount'] ?? 0;
    final availableSeats = widget.ride['availableSeats'] ?? 0;

    final rideId = widget.ride['id'];

    final bool isCancelled = isCancelledRide();
    final bool isCompleted = isFinishedRide();

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                buildRoleBadge(),
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
                    const Icon(
                      Icons.euro,
                      size: 18,
                      color: Colors.green,
                    ),
                  ],
                ),
              ],
            ),
          ),

          ListTile(
            title: Text(
              "$departureCity → $destinationCity",
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
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
                const Icon(
                  Icons.directions_car,
                  size: 16,
                  color: Colors.grey,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    vehicleText,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(width: 8),
                Text("$passengersCount заети"),
                const SizedBox(width: 8),
                Text(
                  "$availableSeats свободни",
                  style: TextStyle(
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ),

          if (isCancelled || isCompleted)
            buildStatusBanner(
              isCancelled: isCancelled,
              isCompleted: isCompleted,
            ),

          if (widget.isDriver &&
              widget.showUpcoming &&
              !isCancelled &&
              !isCompleted &&
              rideId != null)
            buildDriverActions(),

          if (isCompleted && widget.isDriver) buildDriverRatingInfo(),

          if (isCompleted && !widget.isDriver) buildPassengerRatingSection(),
        ],
      ),
    );
  }

  Widget buildRoleBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 4,
      ),
      decoration: BoxDecoration(
        color: widget.isDriver
            ? Colors.deepPurple.withOpacity(0.1)
            : Colors.teal.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: widget.isDriver ? Colors.deepPurple : Colors.teal,
        ),
      ),
      child: Text(
        widget.isDriver ? "шофьор" : "пътник",
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.bold,
          color: widget.isDriver ? Colors.deepPurple : Colors.teal,
        ),
      ),
    );
  }

  Widget buildStatusBanner({
    required bool isCancelled,
    required bool isCompleted,
  }) {
    return Padding(
      padding: const EdgeInsets.only(
        left: 12,
        right: 12,
        bottom: 12,
      ),
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
    );
  }

  Widget buildDriverActions() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
      child: Row(
        children: [
          Expanded(
            child: OutlinedButton.icon(
              onPressed: widget.onCancel,
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
              onPressed: widget.onFinish,
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
    );
  }

  Widget buildDriverRatingInfo() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.amber.withOpacity(0.08),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.amber.shade300),
        ),
        child: isLoadingRating
            ? const Center(
                child: SizedBox(
                  height: 22,
                  width: 22,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Оценка за това пътуване",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      buildReadonlyStars(driverAverageRating.round()),
                      const SizedBox(width: 8),
                      Text(
                        driverRatingsCount == 0
                            ? "Все още няма оценки"
                            : "${driverAverageRating.toStringAsFixed(1)} / 5",
                        style: TextStyle(
                          color: Colors.grey.shade700,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
      ),
    );
  }

  Widget buildPassengerRatingSection() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.deepPurple.withOpacity(0.06),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.deepPurple.withOpacity(0.25)),
        ),
        child: isLoadingRating
            ? const Center(
                child: SizedBox(
                  height: 22,
                  width: 22,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
              )
            : hasRated
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Вече оценихте шофьора",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          buildReadonlyStars(existingRating),
                          const SizedBox(width: 8),
                          Text(
                            "$existingRating / 5",
                            style: TextStyle(
                              color: Colors.grey.shade700,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ],
                  )
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Оценете шофьора",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          buildEditableStars(),
                          const Spacer(),
                          ElevatedButton(
                            onPressed: selectedRating == 0
                                ? null
                                : submitRating,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.deepPurple,
                              foregroundColor: Colors.white,
                            ),
                            child: const Text("Изпрати"),
                          ),
                        ],
                      ),
                    ],
                  ),
      ),
    );
  }

  Widget buildEditableStars() {
    return Row(
      children: List.generate(5, (index) {
        final starValue = index + 1;

        return InkWell(
          onTap: () {
            setState(() {
              selectedRating = starValue;
            });
          },
          child: Padding(
            padding: const EdgeInsets.only(right: 3),
            child: Icon(
              starValue <= selectedRating
                  ? Icons.star_rounded
                  : Icons.star_border_rounded,
              color: Colors.amber,
              size: 30,
            ),
          ),
        );
      }),
    );
  }

  Widget buildReadonlyStars(int rating) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (index) {
        final starValue = index + 1;

        return Icon(
          starValue <= rating
              ? Icons.star_rounded
              : Icons.star_border_rounded,
          color: Colors.amber,
          size: 22,
        );
      }),
    );
  }

  Future<void> submitRating() async {
    final rideId = widget.ride['id'];
    final driverId = widget.ride['driverId'];
    final currentUserId = widget.currentUserId;

    if (rideId == null || driverId == null || currentUserId == null) {
      return;
    }

    setState(() {
      isLoadingRating = true;
    });

    final success = await RatingUtils.createRating(
      ratedUserId: driverId,
      ratedByUserId: currentUserId,
      rideId: rideId,
      score: selectedRating,
    );

    if (!mounted) return;

    if (success) {
      setState(() {
        hasRated = true;
        existingRating = selectedRating;
        isLoadingRating = false;
      });

      widget.onRatingChanged?.call();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Оценката е изпратена успешно."),
          backgroundColor: Colors.green,
          behavior: SnackBarBehavior.floating,
        ),
      );
    } else {
      setState(() {
        isLoadingRating = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Неуспешно изпращане на оценката."),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }
}