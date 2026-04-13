import 'package:flutter/material.dart';
import '../controllers/offerUtils.dart';
import '../controllers/cityUtils.dart';
import '../controllers/userUtils.dart';

class BookedOffersPage extends StatefulWidget {
  const BookedOffersPage({super.key});

  @override
  State<BookedOffersPage> createState() => _BookedOffersPageState();
}

class _BookedOffersPageState extends State<BookedOffersPage> {
  // Replace this with your actual API call for booked offers
  Future<List<Map<String, dynamic>>> fetchBookedOffers() async {
    // For now, we use the same getOffers but you should filter by UserID in the future
    var offers = await OfferUtils.getOffers(); 
    
    return await Future.wait(offers.map((offer) async {
      final fromCity = await CityUtils.getCity(offer.departureCityId);
      final toCity = await CityUtils.getCity(offer.destinationCityId);
      final driver = await UserUtils.getUser(offer.driverId);

      return {
        "from": fromCity.name,
        "to": toCity.name,
        "date": offer.departureTime,
        "driver": driver?.username ?? "Unknown",
        "price": offer.pricePerSeat.toStringAsFixed(2),
      };
    }).toList());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: const Text("My Booked Rides", style: TextStyle(fontWeight: FontWeight.bold)),
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
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: fetchBookedOffers(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator(color: Colors.deepPurple));
          } else if (snapshot.hasError || snapshot.data == null || snapshot.data!.isEmpty) {
            return _buildEmptyState();
          }

          final bookedRides = snapshot.data!;

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: bookedRides.length,
            itemBuilder: (context, index) {
              final ride = bookedRides[index];
              return _buildBookingCard(ride);
            },
          );
        },
      ),
    );
  }

  Widget _buildBookingCard(Map<String, dynamic> ride) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(ride['date'].toString().split(' ')[0], // Shows Date
                        style: const TextStyle(color: Colors.grey, fontWeight: FontWeight.w500)),
                    const SizedBox(height: 4),
                    Text("${ride['from']} → ${ride['to']}",
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.green.shade100,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Text("CONFIRMED", 
                    style: TextStyle(color: Colors.green, fontSize: 12, fontWeight: FontWeight.bold)),
                ),
              ],
            ),
            const Divider(height: 30),
            Row(
              children: [
                const CircleAvatar(
                  backgroundColor: Colors.deepPurple,
                  child: Icon(Icons.person, color: Colors.white),
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Driver", style: TextStyle(color: Colors.grey, fontSize: 12)),
                    Text(ride['driver'], style: const TextStyle(fontWeight: FontWeight.w600)),
                  ],
                ),
                const Spacer(),
                Text("\$${ride['price']}", 
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.deepPurple)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.directions_car_filled_outlined, size: 80, color: Colors.grey.shade300),
          const SizedBox(height: 16),
          const Text("No bookings found", style: TextStyle(fontSize: 18, color: Colors.grey)),
          const SizedBox(height: 8),
          const Text("Try booking a ride from the Offers tab!", style: TextStyle(color: Colors.grey)),
        ],
      ),
    );
  }
}