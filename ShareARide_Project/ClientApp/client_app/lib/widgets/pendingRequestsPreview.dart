import 'package:flutter/material.dart';
import '../pages/requestsPage.dart';

// import '../widgets/pendingRequestsPreview.dart';

class PendingRequestsPreview extends StatefulWidget {
  final BuildContext context;
  const PendingRequestsPreview({super.key, required this.context});

  @override
  State<PendingRequestsPreview> createState() => _PendingRequestsPreviewState();
}

class _PendingRequestsPreviewState extends State<PendingRequestsPreview> {
  int requestCount = 2;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              "Pending Requests",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            if (requestCount > 0)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  "$requestCount New",
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
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
                    Text(
                      "Ivan and 1 other",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      "want to join your trip",
                      style: TextStyle(fontSize: 13, color: Colors.black54),
                    ),
                  ],
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const RequestsPage()),
                  );
                },
                child: const Text("View All"),
              ),
            ],
          ),
        ),
      ],
    );
  }
}