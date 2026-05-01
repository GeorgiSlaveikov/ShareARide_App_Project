import '../widgets/pendingRequestsPreview.dart';
import 'package:flutter/material.dart';
import '../controllers/userUtils.dart';
import 'createOfferPage.dart';
import 'offersPage.dart';
import 'manageVehiclesPage.dart';
import '../main.dart';
import '../controllers/utils.dart';
import '../infoPopupModals/userDetailModal.dart';

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
                "Добре дошъл, ${user?.firstName ?? 'Пътешественик'}",
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
                  Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Color(0xFF673AB7), Color(0xFF3F51B5)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                  ),
                  Positioned(
                    top: -50,
                    right: -50,
                    child: CircleAvatar(
                      radius: 100,
                      backgroundColor: Colors.white.withOpacity(0.05),
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
                    buildSectionHeader("Бързи действия"),
                    const SizedBox(height: 16),

                    Row(
                      children: [
                        buildActionCard(
                          context,
                          "Създай оферта",
                          Icons.add_circle_rounded,
                          () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => CreateOfferPage(onOfferCreated: () {}),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        buildActionCard(
                          context,
                          "Търси оферта",
                          Icons.search_rounded,
                          () => Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => const OffersPage()),
                          ),
                        ),
                        const SizedBox(width: 12),
                        buildActionCard(
                          context,
                          "Моят гараж",
                          Icons.garage_rounded,
                          () => Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => const ManageVehiclesPage()),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 35),
                    buildSectionHeader("Вашата активност"),
                    const SizedBox(height: 16),

                    Row(
                      children: [
                        buildStatCard(
                          "Общо пътувания",
                          "12",
                          Icons.auto_awesome_motion_rounded,
                          Colors.blueAccent,
                        ),
                        const SizedBox(width: 16),
                        buildStatCard(
                          "Рейтинг",
                          "4.9",
                          Icons.stars_rounded,
                          Colors.orangeAccent,
                        ),
                      ],
                    ),

                    const SizedBox(height: 35),
                    buildSectionHeader("Информация"),
                    const SizedBox(height: 12),
                    buildInfoCard(
                      icon: Icons.notifications_active_rounded,
                      title: "Следващо пътуване след 2 дни",
                      subtitle: "София до Пловдив в 09:00",
                    ),

                    const SizedBox(height: 35),
                    buildSectionHeader("Акаунт"),
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
            if (context.mounted && user != null) {
              UserDetailModal.show(context, user);
            }
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
      child: Container(
        constraints: const BoxConstraints(minHeight: 140),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: color.withOpacity(0.18),
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.18),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
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
                    fontWeight: FontWeight.w900,
                    letterSpacing: -1,
                  ),
                ),
                Text(
                  title,
                  style: TextStyle(
                    color: Colors.grey.shade500,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ],
        ),
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
        trailing: const Icon(Icons.arrow_forward_ios, size: 14),
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
          title: Text("Изход"),
          subtitle: Text("Излезте от профила си"),
          trailing: Icon(Icons.arrow_forward_ios, size: 14),
        ),
      ),
    );
  }
}