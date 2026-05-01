import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../controllers/userUtils.dart';
import '../controllers/rideUtils.dart';

class RidesPage extends StatefulWidget {
  const RidesPage({super.key});

  @override
  State<RidesPage> createState() => _RidesPageState();
}

class _RidesPageState extends State<RidesPage> {
  List<Map<String, dynamic>> upcomingRides = [];
  List<Map<String, dynamic>> pastRides = [];
  bool isLoading = true;
  bool showUpcoming = true; // State toggle: true = Upcoming, false = Past
  int? currentUserId;

  @override
  void initState() {
    super.initState();
    _loadRides();
  }

  Future<void> _loadRides() async {
    setState(() => isLoading = true);
    currentUserId = await UserUtils.getCurrentUserId();
    
    final allRides = await RideUtils.getRidesForUser(currentUserId!);
    final now = DateTime.now();

    setState(() {
      upcomingRides = allRides.where((r) => 
        DateTime.parse(r['departureTime']).isAfter(now)).toList();
      pastRides = allRides.where((r) => 
        DateTime.parse(r['departureTime']).isBefore(now)).toList();
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Determine which list to show based on our toggle
    final currentRides = showUpcoming ? upcomingRides : pastRides;

    return Scaffold(
      appBar: AppBar(
        title: const Text("My Rides", style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Column(
        children: [
          // CUSTOM TAB SELECTOR (Matching your OffersPage style)
          Container(
            color: Colors.deepPurple.withOpacity(0.1),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: [
                buildTabButton(
                  label: "Upcoming",
                  isActive: showUpcoming,
                  onTap: () => setState(() => showUpcoming = true),
                ),
                const SizedBox(width: 8),
                buildTabButton(
                  label: "Past Rides",
                  isActive: !showUpcoming,
                  onTap: () => setState(() => showUpcoming = false),
                ),
              ],
            ),
          ),

          // LIST AREA
          Expanded(
            child: isLoading
                ? const Center(child: CircularProgressIndicator())
                : currentRides.isEmpty
                    ? _buildEmptyState()
                    : ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: currentRides.length,
                        itemBuilder: (context, index) {
                          final ride = currentRides[index];
                          final bool isDriver = ride['driverId'] == currentUserId;
                          return _buildRideCard(ride, isDriver);
                        },
                      ),
          ),
        ],
      ),
    );
  }

  // REUSABLE TAB BUTTON (Matches your OffersPage style)
  Widget buildTabButton({
    required String label,
    required bool isActive,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isActive ? Colors.deepPurple : Colors.white,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.deepPurple),
            boxShadow: isActive 
              ? [BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2))]
              : [],
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

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.directions_car_filled_outlined, size: 80, color: Colors.grey.shade300),
          const SizedBox(height: 16),
          Text("No ${showUpcoming ? 'upcoming' : 'past'} rides found", 
            style: const TextStyle(color: Colors.grey, fontSize: 16)),
        ],
      ),
    );
  }

  // Keep your existing _buildRideCard method here...
  Widget _buildRideCard(Map<String, dynamic> ride, bool isDriver) {
     // ... (The code from the previous response)
     final departureDate = DateTime.parse(ride['departureTime']);
     return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: isDriver ? Colors.deepPurple.withOpacity(0.1) : Colors.teal.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: isDriver ? Colors.deepPurple : Colors.teal),
                  ),
                  child: Text(
                    isDriver ? "DRIVING" : "PASSENGER",
                    style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: isDriver ? Colors.deepPurple : Colors.teal),
                  ),
                ),
                Text("${ride['pricePerSeat']} BGN", style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.green)),
              ],
            ),
          ),
          ListTile(
            title: Text("${ride['departureCity']} → ${ride['destinationCity']}", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            subtitle: Text(DateFormat('MMM dd, yyyy • HH:mm').format(departureDate)),
          ),
          const Divider(),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                const Icon(Icons.directions_car, size: 16, color: Colors.grey),
                const SizedBox(width: 8),
                Text(ride['vehicle'] ?? "Vehicle Info"),
                const Spacer(),
                Text("${ride['passengersCount']} occupied"),
              ],
            ),
          ),
        ],
      ),
    );
  }
}