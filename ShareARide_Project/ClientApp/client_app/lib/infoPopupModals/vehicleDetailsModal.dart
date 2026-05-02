import 'package:flutter/material.dart';
import '../entity/vehicle.dart';
import '../controllers/utils.dart';

class VehicleDetailModal extends StatelessWidget {
  final Vehicle vehicle;
  final VoidCallback onEditPhoto;

  const VehicleDetailModal({
    super.key,
    required this.vehicle,
    required this.onEditPhoto,
  });

  static void show(BuildContext context, Vehicle vehicle, VoidCallback onEditPhoto) {
    // print(vehicle);
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => VehicleDetailModal(
        vehicle: vehicle,
        onEditPhoto: onEditPhoto,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    String path = vehicle.vehiclePicturePath ?? "";
    
    if (path.startsWith('/')) {
      path = path.substring(1);
    }
    
    final String fullImageUrl = "http://${Utils().ip}:5205/$path";

    return Container(
      // Force the modal to take full width of the screen
      width: MediaQuery.of(context).size.width,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center, // Center text
        children: [
          // Drag Handle
          Container(
            width: 40,
            height: 5,
            margin: const EdgeInsets.only(bottom: 20),
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          SizedBox(
            width: double.infinity, // Force full width
            height: 360,
            child: Stack(
              children: [
                Positioned.fill(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: (vehicle.vehiclePicturePath != null && vehicle.vehiclePicturePath!.isNotEmpty)
                        ? Image.network(
                            fullImageUrl,
                            fit: BoxFit.cover,
                            // This helps catch loading issues
                            loadingBuilder: (context, child, loadingProgress) {
                              if (loadingProgress == null) return child;
                              return Center(child: CircularProgressIndicator(color: Colors.deepPurple));
                            },
                            errorBuilder: (context, error, stackTrace) => _buildPlaceholder(),
                          )
                        : _buildPlaceholder(),
                  ),
                ),
                // Edit Button
                Positioned(
                  bottom: 12,
                  right: 12,
                  child: FloatingActionButton.small(
                    heroTag: "edit_veh_photo", // Avoid hero tag conflicts
                    onPressed: () {
                      Navigator.pop(context);
                      onEditPhoto();
                    },
                    backgroundColor: Colors.deepPurple,
                    child: const Icon(Icons.camera_alt, color: Colors.white, size: 18),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          Text(
            "${vehicle.make.name} ${vehicle.model}",
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold, letterSpacing: -0.5),
          ),
          
          const SizedBox(height: 8),

          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              "Година: ${vehicle.year}  •  Капацитет: ${vehicle.maxCapacity} места",
              style: TextStyle(color: Colors.grey[700], fontSize: 15, fontWeight: FontWeight.w500),
            ),
          ),

          const SizedBox(height: 32),

          // Close Button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurple,
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: const Text("Назад", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildPlaceholder() {
    return Container(
      color: Colors.grey[200],
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.directions_car_filled, size: 60, color: Colors.grey[400]),
          const SizedBox(height: 8),
          Text("Не е намерено изображение", style: TextStyle(color: Colors.grey[500])),
        ],
      ),
    );
  }
}