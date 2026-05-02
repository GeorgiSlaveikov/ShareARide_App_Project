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
    return InkWell(
      onTap: () {
        // print(vehicle);
        VehicleDetailModal.show(context, vehicle, () {});
      },
      child: Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: ListTile(
        leading: const CircleAvatar(
          backgroundColor: Colors.deepPurple,
          child: Icon(Icons.directions_car, color: Colors.white),
        ),
        title: Text("${vehicle.make.name} ${vehicle.model}"),
        subtitle: Text(
          "${vehicle.year} • ${vehicle.maxCapacity} Места",
        ),
        trailing: IconButton(
          icon: const Icon(Icons.delete_outline, color: Colors.red),
          onPressed: onDelete,
        ),
      ),
    ),
    );
  }
}