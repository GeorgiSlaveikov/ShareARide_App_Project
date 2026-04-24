// import 'package:client_app/entity/user.dart';
import '../widgets/pendingRequestsPreview.dart';
import 'package:flutter/material.dart';
import '../controllers/userUtils.dart';
// import 'requestsPage.dart';
import 'createOfferPage.dart';
import 'offersPage.dart';
import 'manageVehiclesPage.dart';
import '../main.dart';
import '../controllers/utils.dart';

class DashboardPage extends StatelessWidget {
  final Function(int) onFindOffer;
  const DashboardPage({super.key, required this.onFindOffer});

  @override
  Widget build(BuildContext context) {
    final user = UserUtils.currentUser;

    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      body: CustomScrollView(
        slivers: [
          // --- STICKY APP BAR ---
          SliverAppBar(
            expandedHeight: 240,
            floating: false,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                "Welcome back, ${user?.firstName ?? 'Traveler'}",
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              background: Stack(
                fit: StackFit.expand,
                children: [
                  // 1. The Gradient Background
                  Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Colors.deepPurple, Colors.indigo],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                  ),
                  // 2. The Profile Image (Centered)
                  Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        buildProfilePicture(user?.profilePicturePath),
                        const SizedBox(height: 45), // Space for the title below
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // --- PENDING REQUESTS ---
                  PendingRequestsPreview(context: context),

                  const SizedBox(height: 30),
                  const Text(
                    "Quick Actions",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),

                  // --- UPDATED QUICK ACTIONS ROW ---
                  Row(
                    children: [
                      buildActionCard(
                        context,
                        "Create Offer",
                        Icons.add_circle_outline,
                        () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) =>
                                CreateOfferPage(onOfferCreated: () {}),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      buildActionCard(
                        context,
                        "Find Offer",
                        Icons.search,
                        () => Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const OffersPage()),
                        ),
                      ),
                      const SizedBox(width: 10),
                      buildActionCard(
                        context,
                        "My Garage",
                        Icons.garage_outlined,
                        () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const ManageVehiclesPage(),
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 30),
                  const Text(
                    "Your Activity",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 15),

                  // --- STATS GRID ---
                  Row(
                    children: [
                      buildStatCard(
                        "Total Trips",
                        "12",
                        Icons.route,
                        Colors.blue,
                      ),
                      const SizedBox(width: 15),
                      buildStatCard(
                        "Saved",
                        "\$140",
                        Icons.savings,
                        Colors.green,
                      ),
                    ],
                  ),
                  const SizedBox(height: 15),
                  Row(
                    children: [
                      buildStatCard("CO2 Saved", "4kg", Icons.eco, Colors.teal),
                      const SizedBox(width: 15),
                      buildStatCard("Rating", "4.9", Icons.star, Colors.orange),
                    ],
                  ),

                  const SizedBox(height: 30),
                  const Text(
                    "Travel Info",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: const ListTile(
                      leading: Icon(
                        Icons.notifications_active,
                        color: Colors.deepPurple,
                      ),
                      title: Text("Next trip in 2 days"),
                      subtitle: Text("Sofia to Plovdiv at 09:00"),
                      trailing: Icon(Icons.arrow_forward_ios, size: 14),
                    ),
                  ),
                  const SizedBox(height: 30),
                  const Text(
                    "Account Actions",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    // clipBehavior ensures the ripple effect stays inside the rounded corners
                    clipBehavior: Clip.antiAlias,
                    child: InkWell(
                      onTap: () {
                        UserUtils.logout();
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const MyApp(),
                          ),
                          (route) =>
                              false, // This clears the entire navigation history
                        );
                      },
                      child: const ListTile(
                        leading: Icon(Icons.logout, color: Colors.deepPurple),
                        title: Text("Logout"),
                        subtitle: Text("Sign out of your account"),
                        trailing: Icon(Icons.arrow_forward_ios, size: 14),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // --- COMPONENT: QUICK ACTION CARD ---
  Widget buildActionCard(
    BuildContext context,
    String title,
    IconData icon,
    VoidCallback onTap,
  ) {
    return Expanded(
      child: Card(
        elevation: 2,
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        child: InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 4),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(icon, color: Colors.deepPurple, size: 28),
                const SizedBox(height: 8),
                Text(
                  title,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // --- COMPONENT: STAT CARD ---
  Widget buildStatCard(String title, String value, IconData icon, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: color),
            const SizedBox(height: 10),
            Text(
              value,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            Text(
              title,
              style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildProfilePicture(String? path) {
    final String fullImageUrl = "http://${Utils().ip}:5205$path";

    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white, width: 3),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.2), blurRadius: 10),
        ],
      ),
      child: CircleAvatar(
        radius: 40,
        backgroundColor: Colors.grey.shade200,
        backgroundImage: (path != null && path.isNotEmpty)
            ? NetworkImage(fullImageUrl)
            : null,
        child: (path == null || path.isEmpty)
            ? const Icon(Icons.person, size: 40, color: Colors.grey)
            : null,
      ),
    );
  }
}
