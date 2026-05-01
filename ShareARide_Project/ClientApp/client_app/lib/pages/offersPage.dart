import 'package:client_app/widgets/pageEmptyState.dart';
import 'package:flutter/material.dart';
import '../controllers/offerUtils.dart';
import '../controllers/userUtils.dart';

import '../widgets/offerCard.dart';

class OffersPage extends StatefulWidget {
  const OffersPage({super.key});

  @override
  State<OffersPage> createState() => _OffersPageState();
}

class _OffersPageState extends State<OffersPage> {
  final searchController = TextEditingController();

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
        final fromCityName = offer.departureCityName;
        final toCityName = offer.destinationCityName;
        final driverName = offer.driverName;
        final vehicleMake = offer.vehicleMake;
        final vehicleModel = offer.vehicleModel;
        final vhicleYear = offer.vehicleYear;

        return {
          "id": offer.id,
          "from": fromCityName,
          "to": toCityName,
          "date": offer.departureTime.toString(),
          "driver": driverName,
          "driverId": offer.driverId,
          "price": offer.pricePerSeat.toStringAsFixed(2),
          "availableSeats": offer.availableSeats,
          "createdAt": offer.createdAt.toString(),
          "vehicle": {
            "make": vehicleMake,
            "model": vehicleModel,
            "year": vhicleYear,
          },
        };
      }).toList()
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
        final fromCityName = offer.departureCityName;
        final toCityName = offer.destinationCityName;
        final driverName = offer.driverName;
        final vehicleMake = offer.vehicleMake;
        final vehicleModel = offer.vehicleModel;
        final vhicleYear = offer.vehicleYear;

        return {
          "id": offer.id,
          "from": fromCityName,
          "to": toCityName,
          "date": offer.departureTime.toString(),
          "driver": driverName,
          "driverId": offer.driverId,
          "price": offer.pricePerSeat.toStringAsFixed(2),
          "availableSeats": offer.availableSeats,
          "createdAt": offer.createdAt.toString(),
          "vehicle": {
            "make": vehicleMake,
            "model": vehicleModel,
            "year": vhicleYear,
          },
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
    final currentOffers = showMyOffers ? myOffers : otherOffers;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Posted Offers",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
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
                buildTabButton(
                  label: "Other Offers",
                  isActive: !showMyOffers,
                  onTap: () {
                    setState(() => showMyOffers = false);
                  },
                ),
                const SizedBox(width: 8),
                buildTabButton(
                  label: "My Offers",
                  isActive: showMyOffers,
                  onTap: () {
                    setState(() => showMyOffers = true);
                  },
                ),
              ],
            ),
          ),
          Expanded(
            child: currentOffers.isEmpty ? 
            pageEmptyState(
              Icons.checklist_rtl_rounded, Colors.grey.shade300, "No offers", Colors.grey) : ListView.builder(
              padding: const EdgeInsets.all(8.0),
              itemCount: currentOffers.length,
              itemBuilder: (context, index) {
                final offer = currentOffers[index];
                return OfferCard(offer: offer, isMyOffer: showMyOffers);
              },
            ),
          ),
        ],
      ),
    );
  }
}

Widget buildTabButton({
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
