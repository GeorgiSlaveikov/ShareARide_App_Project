import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../controllers/locationService.dart';
import '../entity/city.dart';

class RideMapPreview extends StatefulWidget {
  final City departureCity;
  final City destinationCity;

  const RideMapPreview({
    super.key,
    required this.departureCity,
    required this.destinationCity,
  });

  @override
  State<RideMapPreview> createState() => _RideMapPreviewState();
}

class _RideMapPreviewState extends State<RideMapPreview> {
  Position? currentPosition;
  GoogleMapController? mapController;

  @override
  void initState() {
    super.initState();
    _loadCurrentLocation();
  }

  Future<void> _loadCurrentLocation() async {
    final position = await LocationService.getCurrentLocation();

    if (!mounted) return;

    setState(() {
      currentPosition = position;
    });
  }

  @override
  Widget build(BuildContext context) {
    final LatLng departureLatLng = LatLng(
      widget.departureCity.latitude,
      widget.departureCity.longitude,
    );

    final LatLng destinationLatLng = LatLng(
      widget.destinationCity.latitude,
      widget.destinationCity.longitude,
    );

    final Set<Marker> markers = {
      Marker(
        markerId: const MarkerId('departure_city'),
        position: departureLatLng,
        infoWindow: InfoWindow(
          title: 'Начална точка',
          snippet: widget.departureCity.name,
        ),
      ),
      Marker(
        markerId: const MarkerId('destination_city'),
        position: destinationLatLng,
        infoWindow: InfoWindow(
          title: 'Крайна точка',
          snippet: widget.destinationCity.name,
        ),
      ),
    };

    if (currentPosition != null) {
      markers.add(
        Marker(
          markerId: const MarkerId('current_location'),
          position: LatLng(
            currentPosition!.latitude,
            currentPosition!.longitude,
          ),
          infoWindow: const InfoWindow(
            title: 'Моята локация',
          ),
        ),
      );
    }

    return SizedBox(
      height: 260,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(18),
        child: GoogleMap(
          initialCameraPosition: CameraPosition(
            target: departureLatLng,
            zoom: 7,
          ),
          markers: markers,
          myLocationEnabled: currentPosition != null,
          myLocationButtonEnabled: true,
          zoomControlsEnabled: true,
          mapToolbarEnabled: true,
          onMapCreated: (GoogleMapController controller) {
            mapController = controller;
          },
        ),
      ),
    );
  }
}
