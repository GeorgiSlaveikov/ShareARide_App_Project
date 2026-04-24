import 'package:flutter/material.dart';

import '../controllers/offerUtils.dart';
import '../controllers/cityUtils.dart';
import '../controllers/userUtils.dart';
import '../controllers/vehicleUtils.dart';
// import '../controllers/bookingUtils.dart';
import '../widgets/offerCard.dart';

class OffersPage extends StatefulWidget {
  const OffersPage({super.key});

  @override
  State<OffersPage> createState() => _OffersPageState();
}

class _OffersPageState extends State<OffersPage> {
  final searchController = TextEditingController();

  var travelOffers = [];
  var myOffers = [];
  var otherOffers = [];

  bool showMyOffers = false;

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
        final vehicle = await VehicleUtils.getVehicle(offer.vehicleId);

        return {
          "id": offer.id,
          "from": fromCity.name,
          "to": toCity.name,
          "date": offer.departureTime.toString(),
          "driver": "${driver?.firstName} ${driver?.lastName}",
          "driverId": offer.driverId,
          "price": offer.pricePerSeat.toStringAsFixed(2),
          "createdAt": offer.createdAt.toString(),
          "vehicle": {
            "make": vehicle.make.name,
            "model": vehicle.model,
            "year": vehicle.year,
          },
          "seats": 3,
        };
      }).toList(),
    );

    mappedOffers.sort((a, b) {
      return (DateTime.parse(
        b['createdAt'].toString(),
      )).compareTo(DateTime.parse(a['createdAt'].toString()));
    });

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
        final vehicle = await VehicleUtils.getVehicle(offer.vehicleId);

        return {
          "id": offer.id,
          "from": fromCity.name,
          "to": toCity.name,
          "date": offer.departureTime.toString(),
          "driver": "${driver?.firstName} ${driver?.lastName}",
          "driverId": offer.driverId,
          "price": offer.pricePerSeat.toStringAsFixed(2),
          "createdAt": offer.createdAt.toString(),
          "vehicle": {
            "make": vehicle.make.name,
            "model": vehicle.model,
            "year": vehicle.year,
          },
          "seats": 3,
        };
      }).toList(),
    );

    mappedOffers.sort((a, b) {
      return (DateTime.parse(
        b['createdAt'].toString(),
      )).compareTo(DateTime.parse(a['createdAt'].toString()));
    });

    setState(() {
      otherOffers = mappedOffers;
    });
  }

  void refresh() {
    if (showMyOffers) {
      fetchMyOffers();
    } else {
      fetchOtherOffers();
    }
  }

  void onSearch() {
    String query = searchController.text.toLowerCase();
    if (query.isEmpty) {
      refresh();
      return;
    }
    setState(() {
      if (showMyOffers) {
        myOffers = myOffers
            .where(
              (offer) =>
                  offer['from'].toLowerCase().contains(query) ||
                  offer['to'].toLowerCase().contains(query) ||
                  offer['driver'].toLowerCase().contains(query)
            )
            .toList();
      } else {
        otherOffers = otherOffers
            .where(
              (offer) =>
                  offer['from'].toLowerCase().contains(query) ||
                  offer['to'].toLowerCase().contains(query) ||
                  offer['driver'].toLowerCase().contains(query)
            )
            .toList();
      }
    });
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
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16.0),
            color: Colors.deepPurple.withOpacity(0.1),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: searchController,
                    decoration: InputDecoration(
                      hintText: "Search by city, driver, etc.",
                      prefixIcon: const Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      filled: true,
                      fillColor: Colors.white,
                    ),
                    onChanged: (value) => onSearch(),
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
                  isActive: !showMyOffers,
                  onTap: () {
                    setState(() => showMyOffers = false);
                    //  fetchOtherOffers();
                  },
                ),
                const SizedBox(width: 8),
                _buildTabButton(
                  label: "My Offers",
                  isActive: showMyOffers,
                  onTap: () {
                    setState(() => showMyOffers = true);
                    // fetchMyOffers();
                  },
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(8.0),
              itemCount: showMyOffers ? myOffers.length : otherOffers.length,
              itemBuilder: (context, index) {
                final offer = showMyOffers
                    ? myOffers[index]
                    : otherOffers[index];
                return OfferCard(offer: offer, isMyOffer: showMyOffers);
              },
            ),
          ),
        ],
      ),
    );
  }
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
