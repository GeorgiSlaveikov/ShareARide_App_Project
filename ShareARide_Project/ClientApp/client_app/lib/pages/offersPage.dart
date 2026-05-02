import 'package:client_app/widgets/pageEmptyState.dart';
import 'package:flutter/material.dart';
import '../controllers/offerUtils.dart';
import '../controllers/userUtils.dart';
import '../entity/offer.dart';
import '../widgets/offerCard.dart';

class OffersPage extends StatefulWidget {
  const OffersPage({super.key});

  @override
  State<OffersPage> createState() => _OffersPageState();
}

class _OffersPageState extends State<OffersPage> {
  final searchController = TextEditingController();

  List<Offer> myOffers = [];
  List<Offer> otherOffers = [];

  List<Offer> allMyOffers = [];
  List<Offer> allOtherOffers = [];

  bool showMyOffers = false;

  @override
  void initState() {
    super.initState();
    fetchOtherOffers();
    fetchMyOffers();
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  Future<void> fetchMyOffers() async {
    final userId = await UserUtils.getCurrentUserId();
    final offers = await OfferUtils.getMyOffers(userId);

    offers.sort((a, b) {
      final bCreated = b.createdAt ?? DateTime.fromMillisecondsSinceEpoch(0);
      final aCreated = a.createdAt ?? DateTime.fromMillisecondsSinceEpoch(0);
      return bCreated.compareTo(aCreated);
    });

    if (!mounted) return;

    setState(() {
      allMyOffers = offers;
      myOffers = offers;
    });
  }

  Future<void> fetchOtherOffers() async {
    final userId = await UserUtils.getCurrentUserId();
    final offers = await OfferUtils.getOtherOffers(userId);

    offers.sort((a, b) {
      final bCreated = b.createdAt ?? DateTime.fromMillisecondsSinceEpoch(0);
      final aCreated = a.createdAt ?? DateTime.fromMillisecondsSinceEpoch(0);
      return bCreated.compareTo(aCreated);
    });

    if (!mounted) return;

    setState(() {
      allOtherOffers = offers;
      otherOffers = offers;
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
    final query = searchController.text.toLowerCase().trim();

    setState(() {
      if (showMyOffers) {
        if (query.isEmpty) {
          myOffers = allMyOffers;
        } else {
          myOffers = allMyOffers.where((offer) {
            return offer.departureCityName.toLowerCase().contains(query) ||
                offer.destinationCityName.toLowerCase().contains(query) ||
                offer.driverName.toLowerCase().contains(query) ||
                offer.vehicleMake.toLowerCase().contains(query) ||
                offer.vehicleModel.toLowerCase().contains(query);
          }).toList();
        }
      } else {
        if (query.isEmpty) {
          otherOffers = allOtherOffers;
        } else {
          otherOffers = allOtherOffers.where((offer) {
            return offer.departureCityName.toLowerCase().contains(query) ||
                offer.destinationCityName.toLowerCase().contains(query) ||
                offer.driverName.toLowerCase().contains(query) ||
                offer.vehicleMake.toLowerCase().contains(query) ||
                offer.vehicleModel.toLowerCase().contains(query);
          }).toList();
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final currentOffers = showMyOffers ? myOffers : otherOffers;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Публикувани оферти",
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
                      hintText: "Търсене по град, шофьор и др.",
                      prefixIcon: const Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      filled: true,
                      fillColor: Colors.white,
                    ),
                    onChanged: (_) => onSearch(),
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
                  label: "Други оферти",
                  isActive: !showMyOffers,
                  onTap: () {
                    setState(() {
                      showMyOffers = false;
                      searchController.clear();
                      otherOffers = allOtherOffers;
                    });
                  },
                ),
                const SizedBox(width: 8),
                buildTabButton(
                  label: "Моите оферти",
                  isActive: showMyOffers,
                  onTap: () {
                    setState(() {
                      showMyOffers = true;
                      searchController.clear();
                      myOffers = allMyOffers;
                    });
                  },
                ),
              ],
            ),
          ),

          Expanded(
            child: currentOffers.isEmpty
                ? pageEmptyState(
                    Icons.checklist_rtl_rounded,
                    Colors.grey.shade300,
                    "Няма оферти",
                    Colors.grey,
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(8.0),
                    itemCount: currentOffers.length,
                    itemBuilder: (context, index) {
                      final offer = currentOffers[index];

                      return OfferCard(
                        offer: offer,
                        isMyOffer: showMyOffers,
                        onOfferUpdate:
                            showMyOffers ? fetchMyOffers : fetchOtherOffers,
                      );
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
