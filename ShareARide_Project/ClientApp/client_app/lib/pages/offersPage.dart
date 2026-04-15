// import 'package:client_app/controllers/cityUtils.dart';
// import 'package:client_app/pages/createOfferPage.dart';
import 'package:client_app/controllers/bookingUtils.dart';
import 'package:flutter/material.dart';

import '../controllers/offerUtils.dart';
import '../controllers/cityUtils.dart';
import '../controllers/userUtils.dart';

class OffersPage extends StatefulWidget {
  const OffersPage({super.key});

  @override
  State<OffersPage> createState() => _OffersPageState();
}

class _OffersPageState extends State<OffersPage> {
  var travelOffers = [];
  var myOffers = [];
  var otherOffers = [];

  bool _showMyOffers = false;

  @override
  void initState() {
    super.initState();
    fetchOtherOffers();
    fetchMyOffers();
  }

  void fetchMyOffers() async {
    var offers = await OfferUtils.getMyOffers(UserUtils.getCurrentUserId());
    var mappedOffers = await Future.wait(
      offers.map((offer) async {
        // Fetch city data asynchronously for each ID
        final fromCity = await CityUtils.getCity(offer.departureCityId);
        final toCity = await CityUtils.getCity(offer.destinationCityId);
        final driver = await UserUtils.getUser(offer.driverId);

        return {
          "id": offer.id,
          "from": fromCity.name,
          "to": toCity.name,
          "date": offer.departureTime.toString(),
          "driver": "${driver?.firstName} ${driver?.lastName}",
          "driverId": offer.driverId,
          "price": offer.pricePerSeat.toStringAsFixed(2),
          "seats": 3,
        };
      }).toList(),
    );

    setState(() {
      myOffers = mappedOffers;
    });
  }

  void fetchOtherOffers() async {
    var offers = await OfferUtils.getOtherOffers(UserUtils.getCurrentUserId());
    var mappedOffers = await Future.wait(
      offers.map((offer) async {
        // Fetch city data asynchronously for each ID
        final fromCity = await CityUtils.getCity(offer.departureCityId);
        final toCity = await CityUtils.getCity(offer.destinationCityId);
        final driver = await UserUtils.getUser(offer.driverId);

        return {
          "id": offer.id,
          "from": fromCity.name,
          "to": toCity.name,
          "date": offer.departureTime.toString(),
          "driver": "${driver?.firstName} ${driver?.lastName}",
          "driverId": offer.driverId,
          "price": offer.pricePerSeat.toStringAsFixed(2),
          "seats": 3,
        };
      }).toList(),
    );

    setState(() {
      otherOffers = mappedOffers;
    });
  }

  void refresh() {
    if (_showMyOffers) {
      fetchMyOffers();
    } else {
      fetchOtherOffers();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Posted Offers",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () {
              // Profile logic
            },
          ),
        ],
      ),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () {
      //     Navigator.push(
      //       context,
      //       MaterialPageRoute(builder: (context) => CreateOfferPage(onOfferCreated: refresh,)),
      //     );
      //   },
      //   backgroundColor: Colors.deepPurple,
      //   child: const Icon(Icons.add, color: Colors.white),
      // ),
      body: Column(
        children: [
          // 1. Search Section
          Container(
            padding: const EdgeInsets.all(16.0),
            color: Colors.deepPurple.withOpacity(0.1),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: "Where to?",
                      prefixIcon: const Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      filled: true,
                      fillColor: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),

          Container(
            color: Colors.deepPurple.withOpacity(0.1),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                _buildTabButton(
                  label: "Other Offers",
                  isActive: !_showMyOffers,
                  onTap: () {
                    setState(() => _showMyOffers = false);
                    //  fetchOtherOffers();
                  },
                ),
                const SizedBox(width: 8),
                _buildTabButton(
                  label: "My Offers",
                  isActive: _showMyOffers,
                  onTap: () {
                    setState(() => _showMyOffers = true);
                    // fetchMyOffers();
                  },
                ),
              ],
            ),
          ),

          // 2. Travel Offers List
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(8.0),
              itemCount: _showMyOffers ? myOffers.length : otherOffers.length,
              itemBuilder: (context, index) {
                final offer = _showMyOffers
                    ? myOffers[index]
                    : otherOffers[index];
                return _buildTravelCard(offer);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTravelCard(Map<String, dynamic> offer) {
    return Card(
      elevation: 3,
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
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
                      offer['date'],
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
              children: [
                Row(
                  children: [
                    const CircleAvatar(
                      radius: 12,
                      child: Icon(Icons.person, size: 16),
                    ),
                    const SizedBox(width: 8),
                    Text(offer['driver']),
                  ],
                ),
                Row(
                  children: [
                    const Icon(Icons.event_seat, size: 16, color: Colors.grey),
                    const SizedBox(width: 4),
                    Text("${offer['seats']} seats left"),
                    const SizedBox(width: 12),
                    ElevatedButton(
                      onPressed: () {
                        // _showBookingDialog(offer);
                        _showSeatSelectionDialog(offer);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.deepPurple,
                        foregroundColor: Colors.white,
                      ),
                      child: const Text("Request"),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showSeatSelectionDialog(Map<String, dynamic> offer) {
  int selectedSeats = 1;
  // Controller for the current user is fixed as "You"
  // We maintain a list for the others
  List<TextEditingController> nameControllers = [];

  showDialog(
    context: context,
    builder: (context) => StatefulBuilder(
      builder: (context, setDialogState) {
        return AlertDialog(
          title: const Text("Select Number of Seats"),
          content: SingleChildScrollView( // Added scroll view in case of many seats
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text("How many people are traveling?"),
                const SizedBox(height: 15),
                
                // 1. The Counter Row
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      onPressed: selectedSeats > 1
                          ? () {
                              setDialogState(() {
                                selectedSeats--;
                                nameControllers.removeLast();
                              });
                            }
                          : null,
                      icon: const Icon(Icons.remove_circle_outline, color: Colors.deepPurple),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey.shade300),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        selectedSeats.toString(),
                        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    ),
                    IconButton(
                      onPressed: selectedSeats < 5
                          ? () {
                              setDialogState(() {
                                selectedSeats++;
                                nameControllers.add(TextEditingController());
                              });
                            }
                          : null,
                      icon: const Icon(Icons.add_circle_outline, color: Colors.deepPurple),
                    ),
                  ],
                ),
                
                const SizedBox(height: 20),
                const Divider(),
                const SizedBox(height: 10),

                // 2. Dynamic Name List
                // The first seat is always the current user
                _buildPassengerNameCard("Passenger 1 (You)", isFixed: true),

                // Generating text fields for the rest of the seats
                ...List.generate(nameControllers.length, (index) {
                  return _buildPassengerNameCard(
                    "Passenger ${index + 2}", 
                    controller: nameControllers[index]
                  );
                }),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () {
                // Collect all names to pass to the next dialog
                List<String> allNames = ["You"];
                allNames.addAll(nameControllers.map((c) => c.text.isEmpty ? "Guest" : c.text));

                Navigator.pop(context);
                _showBookingDialog(offer, allNames);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurple,
                foregroundColor: Colors.white,
              ),
              child: const Text("Send Request"),
            ),
          ],
        );
      },
    ),
  );
}

// Helper widget to build the name inputs
Widget _buildPassengerNameCard(String label, {bool isFixed = false, TextEditingController? controller}) {
  return Card(
    margin: const EdgeInsets.symmetric(vertical: 4),
    color: isFixed ? Colors.deepPurple.withOpacity(0.05) : Colors.white,
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: isFixed
          ? ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(Icons.person, color: Colors.deepPurple),
              title: Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
            )
          : TextField(
              controller: controller,
              decoration: InputDecoration(
                labelText: label,
                prefixIcon: const Icon(Icons.person_outline),
                border: const UnderlineInputBorder(),
              ),
            ),
    ),
  );
}

  void _showBookingDialog(Map<String, dynamic> offer, List<String> allNames) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Confirm Request"),
        content: Text(
          "Do you want to request a seat from ${offer['from']} to ${offer['to']} on ${formatDateTime(offer['date'])}?",
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("Booking successful!"),
                  behavior: SnackBarBehavior.floating,
                  backgroundColor: Colors.green,
                  dismissDirection: DismissDirection.horizontal,
                ),
              );
              BookingUtils.createBooking(
                offer["driverId"],
                UserUtils.getCurrentUserId(), 
                offer["id"], 
                allNames,
              );
            },
            child: const Text("Confirm"),
          ),
        ],
      ),
    );
  }
}

String formatDateTime(String dateTimeStr) {
  var day = DateTime.parse(dateTimeStr).day;
  var month = DateTime.parse(dateTimeStr).month;
  var year = DateTime.parse(dateTimeStr).year;
  var hour = DateTime.parse(dateTimeStr).hour;
  var minute = DateTime.parse(dateTimeStr).minute;
  var minuteStr;

  if (minute < 10) {
    minuteStr = "0${minute.toString()}";
  } else {
    minuteStr = minute.toString();
  }

  var formatedDate = "$day-$month-$year on $hour:$minuteStr";
  return formatedDate;
}

Widget _buildTabButton({
  required String label,
  required bool isActive,
  required VoidCallback onTap,
}) {
  return Expanded(
    child: GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: isActive ? Colors.deepPurple : Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.deepPurple),
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
