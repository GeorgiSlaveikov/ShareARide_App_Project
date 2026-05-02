import 'package:flutter/material.dart';

import '../controllers/bookingUtils.dart';
import '../controllers/userUtils.dart';
import '../widgets/userDetails.dart';

class RequestCard extends StatelessWidget {
  final Map<String, dynamic> request;
  final VoidCallback onChanged;

  const RequestCard({
    super.key,
    required this.request,
    required this.onChanged,
  });

  Future<void> handleAccept(BuildContext context) async {
    final bookingId = request['id'];

    if (bookingId == null) {
      showSnackBar(context, "Невалидна заявка.", Colors.red);
      return;
    }

    final success = await BookingUtils.acceptBooking(bookingId);

    if (!context.mounted) return;

    if (success) {
      showSnackBar(context, "Заявката е приета!", Colors.green);
      onChanged();
    } else {
      showSnackBar(context, "Неуспешно приемане на заявката.", Colors.red);
    }
  }

  void confirmReject(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text("Отхвърляне на заявка"),
        content: const Text(
          "Сигурни ли сте, че искате да отхвърлите тази заявка?",
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text("Отказ"),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(dialogContext);

              final bookingId = request['id'];

              if (bookingId == null) {
                showSnackBar(context, "Невалидна заявка.", Colors.red);
                return;
              }

              final success = await BookingUtils.rejectBooking(bookingId);

              if (!context.mounted) return;

              if (success) {
                showSnackBar(context, "Заявката е отхвърлена.", Colors.red);
                onChanged();
              } else {
                showSnackBar(
                  context,
                  "Неуспешно отхвърляне на заявката.",
                  Colors.red,
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text("Отхвърли"),
          ),
        ],
      ),
    );
  }

  void showSnackBar(BuildContext context, String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: color,
        behavior: SnackBarBehavior.floating,
        dismissDirection: DismissDirection.horizontal,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final requesterName = request['requesterFullName'] ?? "Неизвестен потребител";
    final seats = request['seats'] ?? 0;
    final trip = request['trip'] ?? "";

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        children: [
          ListTile(
            leading: InkWell(
              onTap: () async {
                final user = await UserUtils.getUser(request['requesterId']);

                if (!context.mounted) return;

                if (user != null) {
                  UserDetailModal.show(context, user);
                }
              },
              child: const CircleAvatar(
                child: Icon(Icons.person),
              ),
            ),
            title: Text(
              requesterName,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text("${request['age'] ?? 18} години"),
            trailing: Text(
              "$seats Места",
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),

          const Divider(),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  children: [
                    Icon(Icons.info_outline, size: 16, color: Colors.grey),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        "Иска да се присъедини към вашето пътуване",
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  trip,
                  style: const TextStyle(fontWeight: FontWeight.w500),
                ),
              ],
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => confirmReject(context),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.red,
                      side: const BorderSide(color: Colors.red),
                    ),
                    child: const Text("Отхвърляне"),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => handleAccept(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                    ),
                    child: const Text("Приемане"),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}