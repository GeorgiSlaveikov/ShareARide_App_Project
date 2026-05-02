import 'package:flutter/material.dart';

import '../entity/vehicle.dart';
import '../infoPopupModals/vehicleDetailsModal.dart';

class VehicleCard extends StatelessWidget {
  final Vehicle vehicle;
  final int index;
  final VoidCallback onDelete;

  const VehicleCard({
    super.key,
    required this.vehicle,
    required this.index,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final bool isArchived = vehicle.isDeleted;

    return Opacity(
      opacity: isArchived ? 0.45 : 1,
      child: Card(
        elevation: isArchived ? 0 : 3,
        margin: const EdgeInsets.only(bottom: 14),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
          side: BorderSide(
            color: isArchived ? Colors.grey.shade300 : Colors.transparent,
          ),
        ),
        child: InkWell(
          borderRadius: BorderRadius.circular(15),
          onTap: isArchived
              ? null
              : () {
                  VehicleDetailModal.show(
                    context,
                    vehicle,
                    () {
                      // edit photo callback
                    },
                  );
                },
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 28,
                  backgroundColor:
                      isArchived ? Colors.grey.shade300 : Colors.deepPurple,
                  child: Icon(
                    Icons.directions_car,
                    color: isArchived ? Colors.grey.shade600 : Colors.white,
                    size: 28,
                  ),
                ),

                const SizedBox(width: 14),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "${vehicle.make.name} ${vehicle.model}",
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                          color: isArchived
                              ? Colors.grey.shade600
                              : Colors.black,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "${vehicle.year} • ${vehicle.maxCapacity} места",
                        style: TextStyle(
                          color: Colors.grey.shade600,
                        ),
                      ),

                      if (isArchived) ...[
                        const SizedBox(height: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 5,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade200,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            "Архивирано",
                            style: TextStyle(
                              color: Colors.grey.shade700,
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),

                if (!isArchived)
                  IconButton(
                    onPressed: onDelete,
                    icon: const Icon(
                      Icons.delete_outline,
                      color: Colors.red,
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}