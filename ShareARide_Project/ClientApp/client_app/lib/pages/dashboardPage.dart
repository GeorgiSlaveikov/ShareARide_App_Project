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
import '../infoPopupModals/userDetailsModal.dart';

// class DashboardPage extends StatelessWidget {
//   final Function(int) onFindOffer;
//   const DashboardPage({super.key, required this.onFindOffer});

//   @override
//   Widget build(BuildContext context) {
//     final user = UserUtils.currentUser;

//     return Scaffold(
//       backgroundColor: Colors.grey.shade50,
//       body: CustomScrollView(
//         slivers: [
//           // --- STICKY APP BAR ---
//           SliverAppBar(
//             expandedHeight: 240,
//             floating: false,
//             pinned: true,
//             flexibleSpace: FlexibleSpaceBar(
//               title: Text(
//                 "Welcome back, ${user?.firstName ?? 'Traveler'}",
//                 style: const TextStyle(
//                   color: Colors.white,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//               background: Stack(
//                 fit: StackFit.expand,
//                 children: [
//                   // 1. The Gradient Background
//                   Container(
//                     decoration: const BoxDecoration(
//                       gradient: LinearGradient(
//                         colors: [Colors.deepPurple, Colors.indigo],
//                         begin: Alignment.topLeft,
//                         end: Alignment.bottomRight,
//                       ),
//                     ),
//                   ),
//                   // 2. The Profile Image (Centered)
//                   Center(
//                     child: Column(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         buildProfilePicture(user?.profilePicturePath),
//                         const SizedBox(height: 45), // Space for the title below
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),

//           SliverToBoxAdapter(
//             child: Padding(
//               padding: const EdgeInsets.all(20.0),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   // --- PENDING REQUESTS ---
//                   PendingRequestsPreview(context: context),

//                   const SizedBox(height: 30),
//                   const Text(
//                     "Quick Actions",
//                     style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//                   ),
//                   const SizedBox(height: 12),

//                   // --- UPDATED QUICK ACTIONS ROW ---
//                   Row(
//                     children: [
//                       buildActionCard(
//                         context,
//                         "Create Offer",
//                         Icons.add_circle_outline,
//                         () => Navigator.push(
//                           context,
//                           MaterialPageRoute(
//                             builder: (_) =>
//                                 CreateOfferPage(onOfferCreated: () {}),
//                           ),
//                         ),
//                       ),
//                       const SizedBox(width: 10),
//                       buildActionCard(
//                         context,
//                         "Find Offer",
//                         Icons.search,
//                         () => Navigator.push(
//                           context,
//                           MaterialPageRoute(builder: (_) => const OffersPage()),
//                         ),
//                       ),
//                       const SizedBox(width: 10),
//                       buildActionCard(
//                         context,
//                         "My Garage",
//                         Icons.garage_outlined,
//                         () => Navigator.push(
//                           context,
//                           MaterialPageRoute(
//                             builder: (_) => const ManageVehiclesPage(),
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),

//                   const SizedBox(height: 30),
//                   const Text(
//                     "Your Activity",
//                     style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//                   ),
//                   const SizedBox(height: 15),

//                   // --- STATS GRID ---
//                   Row(
//                     children: [
//                       buildStatCard(
//                         "Total Trips",
//                         "12",
//                         Icons.route,
//                         Colors.blue,
//                       ),
//                       const SizedBox(width: 15),
//                        buildStatCard(
//                         "Rating",
//                         "4.9",
//                         Icons.star,
//                         Colors.orange
//                       ),
//                     ],
//                   ),

//                   const SizedBox(height: 30),
//                   const Text(
//                     "Travel Info",
//                     style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//                   ),
//                   const SizedBox(height: 10),
//                   Card(
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(15),
//                     ),
//                     child: const ListTile(
//                       leading: Icon(
//                         Icons.notifications_active,
//                         color: Colors.deepPurple,
//                       ),
//                       title: Text("Next trip in 2 days"),
//                       subtitle: Text("Sofia to Plovdiv at 09:00"),
//                       trailing: Icon(Icons.arrow_forward_ios, size: 14),
//                     ),
//                   ),
//                   const SizedBox(height: 30),
//                   const Text(
//                     "Account Actions",
//                     style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//                   ),
//                   const SizedBox(height: 10),
//                   Card(
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(15),
//                     ),
//                     // clipBehavior ensures the ripple effect stays inside the rounded corners
//                     clipBehavior: Clip.antiAlias,
//                     child: InkWell(
//                       onTap: () {
//                         UserUtils.logout();
//                         Navigator.pushAndRemoveUntil(
//                           context,
//                           MaterialPageRoute(
//                             builder: (context) => const MyApp(),
//                           ),
//                           (route) =>
//                               false, // This clears the entire navigation history
//                         );
//                       },
//                       child: const ListTile(
//                         leading: Icon(Icons.logout, color: Colors.deepPurple),
//                         title: Text("Logout"),
//                         subtitle: Text("Sign out of your account"),
//                         trailing: Icon(Icons.arrow_forward_ios, size: 14),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   // --- COMPONENT: QUICK ACTION CARD ---
//   Widget buildActionCard(
//     BuildContext context,
//     String title,
//     IconData icon,
//     VoidCallback onTap,
//   ) {
//     return Expanded(
//       child: Card(
//         elevation: 2,
//         clipBehavior: Clip.antiAlias,
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
//         child: InkWell(
//           onTap: onTap,
//           child: Padding(
//             padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 4),
//             child: Column(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 Icon(icon, color: Colors.deepPurple, size: 28),
//                 const SizedBox(height: 8),
//                 Text(
//                   title,
//                   textAlign: TextAlign.center,
//                   style: const TextStyle(
//                     fontWeight: FontWeight.bold,
//                     fontSize: 11,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   // --- COMPONENT: STAT CARD ---
//   Widget buildStatCard(String title, String value, IconData icon, Color color) {
//     return Expanded(
//       child: Container(
//         padding: const EdgeInsets.all(20),
//         decoration: BoxDecoration(
//           color: const Color.fromARGB(255, 255, 255, 255),
//           borderRadius: BorderRadius.circular(15),
//           boxShadow: [
//             BoxShadow(color: Colors.black.withOpacity(0.08), blurRadius: 10),
//           ],
//         ),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Icon(icon, color: color),
//             const SizedBox(height: 10),
//             Text(
//               value,
//               style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
//             ),
//             Text(
//               title,
//               style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget buildProfilePicture(String? path) {
//     final String fullImageUrl = "http://${Utils().ip}:5205$path";

//     return Container(
//       decoration: BoxDecoration(
//         shape: BoxShape.circle,
//         border: Border.all(color: Colors.white, width: 3),
//         boxShadow: [
//           BoxShadow(color: Colors.black.withOpacity(0.2), blurRadius: 10),
//         ],
//       ),
//       child: CircleAvatar(
//         radius: 40,
//         backgroundColor: Colors.grey.shade200,
//         backgroundImage: (path != null && path.isNotEmpty)
//             ? NetworkImage(fullImageUrl)
//             : null,
//         child: (path == null || path.isEmpty)
//             ? const Icon(Icons.person, size: 40, color: Colors.grey)
//             : null,
//       ),
//     );
//   }
// }

class DashboardPage extends StatelessWidget {
  final Function(int) onFindOffer;
  const DashboardPage({super.key, required this.onFindOffer});

  @override
  Widget build(BuildContext context) {
    final user = UserUtils.currentUser;

    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          // --- STICKY APP BAR WITH SHRINKING EFFECT ---
          SliverAppBar(
            expandedHeight: 280,
            floating: false,
            pinned: true,
            stretch: true,
            elevation: 0,
            backgroundColor: Colors.deepPurple,
            flexibleSpace: FlexibleSpaceBar(
              stretchModes: const [
                StretchMode.zoomBackground,
                StretchMode.blurBackground,
              ],
              centerTitle: true,
              titlePadding: const EdgeInsets.only(bottom: 16),
              title: Text(
                "Welcome, ${user?.firstName ?? 'Traveler'}",
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  shadows: [
                    Shadow(
                      blurRadius: 10,
                      color: Colors.black26,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
              ),
              background: Stack(
                fit: StackFit.expand,
                children: [
                  // 1. Gradient Background
                  Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Color(0xFF673AB7), Color(0xFF3F51B5)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                  ),
                  // 2. Decorative Background Texture
                  Positioned(
                    top: -50,
                    right: -50,
                    child: CircleAvatar(
                      radius: 100,
                      backgroundColor: Colors.white.withOpacity(0.05),
                    ),
                  ),
                  Positioned(
                    top: 100,
                    right: 50,
                    child: CircleAvatar(
                      radius: 30,
                      backgroundColor: Colors.white.withOpacity(0.08),
                    ),
                  ),
                  Positioned(
                    top: 150,
                    right: 300,
                    child: CircleAvatar(
                      radius: 120,
                      backgroundColor: Colors.white.withOpacity(0.08),
                    ),
                  ),
                  // 3. Centered Profile Picture
                  Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(height: 20),
                        buildModernProfilePicture(
                          user?.profilePicturePath,
                          context,
                        ),
                        const SizedBox(height: 40),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // --- MAIN CONTENT BODY ---
          SliverToBoxAdapter(
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
              ),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24, 32, 24, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // --- PENDING REQUESTS ---
                    PendingRequestsPreview(context: context),

                    const SizedBox(height: 35),
                    buildSectionHeader("Quick Actions"),
                    const SizedBox(height: 16),

                    Row(
                      children: [
                        buildActionCard(
                          context,
                          "Create Offer",
                          Icons.add_circle_rounded,
                          () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                                  CreateOfferPage(onOfferCreated: () {}),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        buildActionCard(
                          context,
                          "Find Offer",
                          Icons.search_rounded,
                          () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const OffersPage(),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        buildActionCard(
                          context,
                          "My Garage",
                          Icons.garage_rounded,
                          () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const ManageVehiclesPage(),
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 35),
                    buildSectionHeader("Your Activity"),
                    const SizedBox(height: 16),

                    Row(
                      children: [
                        buildStatCard(
                          "Total Trips",
                          "12",
                          Icons.auto_awesome_motion_rounded,
                          Colors.blueAccent,
                        ),
                        const SizedBox(width: 16),
                        buildStatCard(
                          "Rating",
                          "4.9",
                          Icons.stars_rounded,
                          Colors.orangeAccent,
                        ),
                      ],
                    ),

                    const SizedBox(height: 35),
                    buildSectionHeader("Travel Info"),
                    const SizedBox(height: 12),
                    buildInfoCard(
                      icon: Icons.notifications_active_rounded,
                      title: "Next trip in 2 days",
                      subtitle: "Sofia to Plovdiv at 09:00",
                    ),

                    const SizedBox(height: 35),
                    buildSectionHeader("Account Actions"),
                    const SizedBox(height: 12),
                    buildLogoutCard(context),
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // --- UI COMPONENTS ---

  Widget buildSectionHeader(String title) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w800,
        color: Colors.blueGrey.shade900,
        letterSpacing: -0.5,
      ),
    );
  }

  Widget buildModernProfilePicture(String? path, BuildContext context) {
    final String fullImageUrl = "http://${Utils().ip}:5205$path";

    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white.withOpacity(0.4), width: 2),
      ),
      child: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: InkWell(
          onTap: () async {
            var currentUserId = await UserUtils.getCurrentUserId();
            var user = await UserUtils.getUser(currentUserId);
            UserDetailModal.show(context, user!);
          },
          child: CircleAvatar(
            radius: 70,
            backgroundColor: Colors.white,
            child: CircleAvatar(
              radius: 68,
              backgroundColor: Colors.grey.shade200,
              backgroundImage: (path != null && path.isNotEmpty)
                  ? NetworkImage(fullImageUrl)
                  : null,
              child: (path == null || path.isEmpty)
                  ? Icon(
                      Icons.person_rounded,
                      size: 55,
                      color: Colors.grey.shade400,
                    )
                  : null,
            ),
          ),
        ),
      ),
    );
  }

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

  Widget buildStatCard(String title, String value, IconData icon, Color color) {
  return Expanded(
    child: Stack(
      clipBehavior: Clip.none, // Allows the shadow/elements to breathe
      children: [
        // The Main Card Container
        Container(
          // Using a fixed height or Constraints ensures they are all the same size
          constraints: const BoxConstraints(minHeight: 140, minWidth: 140), 
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            // A subtle, colored border makes it stand out from the grey background
            border: Border.all(
              color: color.withOpacity(0.18), 
              width: 1.5,
            ),
            boxShadow: [
              // 1. Bottom Heavy Soft Shadow (The "Pop")
              BoxShadow(
                color: color.withOpacity(0.18),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
              // 2. Very subtle dark shadow for grounding
              BoxShadow(
                color: const Color.fromARGB(255, 117, 117, 117).withOpacity(0.1),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween, // Keeps layout uniform
            children: [
              // Icon with a glowing background
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: color, size: 24),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    value,
                    style: const TextStyle(
                      fontSize: 26, 
                      fontWeight: FontWeight.w900, // Heavier weight for impact
                      letterSpacing: -1,
                    ),
                  ),
                  Text(
                    title,
                    style: TextStyle(
                      color: Colors.grey.shade500, 
                      fontSize: 12, 
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.5,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        // 3. The "Interesting" Background Watermark
        // Positioned(
        //   right: -10,
        //   bottom: -10,
        //   child: Opacity(
        //     opacity: 0.4,
        //     child: Icon(
        //       icon,
        //       size: 80,
        //       color: color,
        //     ),
        //   ),
        // ),
      ],
    ),
  );
}

  Widget buildInfoCard({
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: ListTile(
        leading: Icon(icon, color: Colors.deepPurple),
        title: Text(title),
        subtitle: Text(subtitle),
        trailing: Icon(Icons.arrow_forward_ios, size: 14),
      ),
    );
  }

  Widget buildLogoutCard(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () {
          UserUtils.logout();
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const MyApp()),
            (route) => false, 
          );
        },
        child: const ListTile(
          leading: Icon(Icons.logout, color: Colors.deepPurple),
          title: Text("Logout"),
          subtitle: Text("Sign out of your account"),
          trailing: Icon(Icons.arrow_forward_ios, size: 14),
        ),
      ),
    );
  }
}
