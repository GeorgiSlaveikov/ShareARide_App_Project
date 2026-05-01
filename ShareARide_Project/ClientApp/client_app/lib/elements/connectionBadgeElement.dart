import 'package:flutter/material.dart';

Widget ConnectionBadgeElement(bool connected, {VoidCallback? onTap}) {
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
    decoration: BoxDecoration(
      color: connected
          ? Colors.green.withOpacity(0.1)
          : Colors.red.withOpacity(0.1),
      borderRadius: BorderRadius.circular(20),
      border: Border.all(
        color: connected ? Colors.green.shade300 : Colors.red.shade300,
      ),
    ),
    child: InkWell(
      onTap: () {
        if (onTap != null) {
          onTap();
        }
      },
      borderRadius: BorderRadius.circular(20), 
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              connected ? Icons.cloud_done_outlined : Icons.cloud_off_outlined,
              size: 16,
              color: connected ? Colors.green : Colors.red,
            ),
            const SizedBox(width: 6),
            Text(
              connected ? "Server Connected" : "Server Disconnected",
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: connected ? Colors.green : Colors.red,
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
