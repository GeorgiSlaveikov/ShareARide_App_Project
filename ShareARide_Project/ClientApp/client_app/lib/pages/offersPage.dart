// import 'package:client_app/controllers/cityUtils.dart';
import 'package:client_app/pages/createOfferPage.dart';
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

  @override
  void initState() {
    super.initState();
    fetchOffers();
  }

  void fetchOffers() async {
    var offers = await OfferUtils.getOffers();
    var mappedOffers = await Future.wait(
      offers.map((offer) async {
        // Fetch city data asynchronously for each ID
        final fromCity = await CityUtils.getCity(offer.departureCityId);
        final toCity = await CityUtils.getCity(offer.destinationCityId);
        final driver = await UserUtils.getUser(offer.driverId);

        return {
          "from": fromCity.name,
          "to": toCity.name,
          "date": offer.departureTime.toString(),
          "driver": "${driver?.firstName} ${driver?.lastName}",
          "price": offer.pricePerSeat.toStringAsFixed(2),
          "seats": 3,
        };
      }).toList(),
    );

    setState(() {
      travelOffers = mappedOffers;
    });
  }

  void refresh( ) {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Posted Offers", style: TextStyle(fontWeight: FontWeight.bold)),
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
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => CreateOfferPage(onOfferCreated: refresh,)),
          );
        },
        backgroundColor: Colors.deepPurple,
        child: const Icon(Icons.add, color: Colors.white),
      ),
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

          // 2. Travel Offers List
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(8.0),
              itemCount: travelOffers.length,
              itemBuilder: (context, index) {
                final offer = travelOffers[index];
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
                        _showBookingDialog(offer);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.deepPurple,
                        foregroundColor: Colors.white,
                      ),
                      child: const Text("Book"),
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

  void _showBookingDialog(Map<String, dynamic> offer) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Confirm Booking"),
        content: Text(
          "Do you want to book a seat from ${offer['from']} to ${offer['to']}?",
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
                const SnackBar(content: Text("Booking successful!")),
              );
            },
            child: const Text("Confirm"),
          ),
        ],
      ),
    );
  }
}
