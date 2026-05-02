import 'package:flutter/material.dart';
import '../entity/user.dart';
import '../controllers/utils.dart';

class UserDetailModal extends StatelessWidget {
  final User user;

  const UserDetailModal({super.key, required this.user});

  // Helper to show the modal from anywhere
  static void show(BuildContext context, User user) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => UserDetailModal(user: user),
    );
  }

  @override
  Widget build(BuildContext context) {
    final String fullImageUrl = "http://${Utils().ip}:5205${user.profilePicturePath}";
    
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle for dragging
          Container(
            width: 40,
            height: 5,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          const SizedBox(height: 20),
          CircleAvatar(
            radius: 55,
            backgroundColor: Colors.white,
            child: CircleAvatar(
              radius: 52,
              backgroundColor: Colors.grey.shade200,
              backgroundImage: (user.profilePicturePath != null && user.profilePicturePath!.isNotEmpty)
                  ? NetworkImage(fullImageUrl)
                  : null,
              child: (user.profilePicturePath == null || user.profilePicturePath!.isEmpty)
                  ? Icon(
                      Icons.person_rounded,
                      size: 55,
                      color: Colors.grey.shade400,
                    )
                  : null,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            "${user.firstName} ${user.lastName}",
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          Text(
            "@${user.username}",
            style: TextStyle(color: Colors.grey[600], fontSize: 14),
          ),
          
          const SizedBox(height: 15),
          
          // Rating Badge
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.amber[100],
              borderRadius: BorderRadius.circular(15),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.star, color: Colors.amber, size: 18),
                const SizedBox(width: 4),
                Text(
                  "N/A",
                  style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.orange),
                ),
              ],
            ),
          ),

          const Divider(height: 40),

          _buildInfoRow(Icons.email, "Имейл", user.email),
          _buildInfoRow(Icons.phone, "Телефонен номер", user.phoneNumber),
          _buildInfoRow(Icons.cake, "Възраст", "${user.age} години"),
           
          const SizedBox(height: 30),
          
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurple,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                padding: const EdgeInsets.symmetric(vertical: 15),
              ),
              child: const Text("Затвори"),
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Row(
        children: [
          Icon(icon, color: Colors.deepPurple, size: 22),
          const SizedBox(width: 15),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: const TextStyle(color: Colors.grey, fontSize: 12)),
              Text(value, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
            ],
          ),
        ],
      ),
    );
  }
}