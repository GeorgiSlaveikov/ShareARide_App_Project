import 'package:flutter/material.dart';
import '../controllers/userUtils.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    final user = UserUtils.currentUser;

    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 200,
            floating: false,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Text("Welcome back, ${user?.firstName ?? 'Traveler'}", 
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              background: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.deepPurple, Colors.indigo],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // --- NEW: Pending Requests Section ---
                  _buildPendingRequestsPreview(),
                  
                  const SizedBox(height: 30),
                  const Text("Your Activity", 
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 15),
                  
                  Row(
                    children: [
                      _buildStatCard("Total Trips", "12", Icons.route, Colors.blue),
                      const SizedBox(width: 15),
                      _buildStatCard("Saved", "\$140", Icons.savings, Colors.green),
                    ],
                  ),
                  const SizedBox(height: 15),
                  Row(
                    children: [
                      _buildStatCard("CO2 Saved", "4kg", Icons.eco, Colors.teal),
                      const SizedBox(width: 15),
                      _buildStatCard("Rating", "4.9", Icons.star, Colors.orange),
                    ],
                  ),
                  
                  const SizedBox(height: 30),
                  const Text("Quick Actions", 
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 10),
                  
                  Card(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                    child: const ListTile(
                      leading: Icon(Icons.notifications_active, color: Colors.deepPurple),
                      title: Text("Next trip in 2 days"),
                      subtitle: Text("Sofia to Plovdiv at 09:00"),
                      trailing: Icon(Icons.arrow_forward_ios, size: 14),
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

  Widget _buildPendingRequestsPreview() {
    // In a real app, you would check if requests list is empty
    int requestCount = 2; 

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text("Pending Requests", 
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            if (requestCount > 0)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(color: Colors.red, borderRadius: BorderRadius.circular(12)),
                child: Text("$requestCount New", 
                  style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
              ),
          ],
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.deepPurple.withOpacity(0.05),
            borderRadius: BorderRadius.circular(15),
            border: Border.all(color: Colors.deepPurple.withOpacity(0.1)),
          ),
          child: Row(
            children: [
              const CircleAvatar(
                backgroundColor: Colors.deepPurple,
                child: Icon(Icons.people, color: Colors.white),
              ),
              const SizedBox(width: 15),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Ivan and 1 other", style: TextStyle(fontWeight: FontWeight.bold)),
                    Text("want to join your Sofia → Varna trip", style: TextStyle(fontSize: 13, color: Colors.black54)),
                  ],
                ),
              ),
              TextButton(
                onPressed: () {
                  // Here you would navigate to the Requests Tab
                },
                child: const Text("View All"),
              )
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: color),
            const SizedBox(height: 10),
            Text(value, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            Text(title, style: TextStyle(color: Colors.grey.shade600, fontSize: 12)),
          ],
        ),
      ),
    );
  }
}