import 'package:client_app/controllers/offerUtils.dart';
import 'package:client_app/controllers/userUtils.dart';
import 'package:flutter/material.dart';
import '../controllers/cityUtils.dart';
import '../controllers/vehicleUtils.dart';
import '../entity/vehicle.dart';

class CreateOfferPage extends StatefulWidget {
  final VoidCallback onOfferCreated;
  const CreateOfferPage({super.key, required this.onOfferCreated});

  @override
  State<CreateOfferPage> createState() => _CreateOfferPageState();
}

class _CreateOfferPageState extends State<CreateOfferPage> {
  final formKey = GlobalKey<FormState>();
  final priceController = TextEditingController();
  final availableSeatsController = TextEditingController();
  DateTime selectedDateTime = DateTime.now().add(const Duration(hours: 2));

  int? fromCityId;
  int? toCityId;
  int? selectedVehicleId;

  List<dynamic> cities = [];
  List<Vehicle> userVehicles = [];

  Vehicle? selectedVehicle;

  bool canDecrement = true;
  bool canIncrement = false;

  @override
  void initState() {
    super.initState();
    CityUtils.getCities().then((data) => setState(() => cities = data));
    VehicleUtils.getMyVehicles(UserUtils.getCurrentUserId()).then((vehicles) {
      setState(() {
        userVehicles = vehicles;

        if (userVehicles.isNotEmpty) {
          selectedVehicleId = userVehicles[0].id;
          selectedVehicle = userVehicles[0];
          availableSeatsController.text = userVehicles[0].maxCapacity
              .toString();
        }
      });
    });
  }

  void handleVehicleChange(vehicleId) {
    if (userVehicles.isEmpty) {
      return;
    }
    final vehicle = userVehicles.firstWhere((v) => v.id == vehicleId);
    setState(() {
      selectedVehicle = vehicle;
      availableSeatsController.text = vehicle.maxCapacity.toString();
    });
  }

  void updateSeats(int delta) {
    if (selectedVehicleId == null) return;

    final currentVehicle = userVehicles.firstWhere(
      (v) => v.id == selectedVehicleId,
    );
    int currentSeats = int.tryParse(availableSeatsController.text) ?? 1;
    int newSeats = currentSeats + delta;

    if (newSeats >= 1 && newSeats <= currentVehicle.maxCapacity) {
      setState(() {
        availableSeatsController.text = newSeats.toString();
      });
    }
  
    setState(() {
      if (newSeats <= 1)
        canDecrement = false;
      else if (newSeats > 1)
        canDecrement = true;

      if (newSeats >= selectedVehicle!.maxCapacity)
        canIncrement = false;
      else if (newSeats < selectedVehicle!.maxCapacity) 
        canIncrement = true;
    });
  }

  // Reuseable styling for Input Decorations
  InputDecoration inputStyle(String label, IconData icon, {String? prefix}) {
    return InputDecoration(
      labelText: label,
      prefixText: prefix,
      prefixIcon: Icon(icon, color: Colors.deepPurple),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.grey.shade300),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.deepPurple, width: 2),
      ),
    );
  }

  void submitOffer() async {
    if (formKey.currentState!.validate()) {
      bool success = await OfferUtils.createOffer(
        UserUtils.getCurrentUserId(),
        selectedVehicleId!,
        selectedDateTime.toIso8601String(),
        fromCityId!,
        toCityId!,
        double.parse(priceController.text),
        int.parse(availableSeatsController.text),
      );

      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Offer Posted Successfully!"),
            backgroundColor: Colors.green,
            dismissDirection: DismissDirection.horizontal,
            behavior: SnackBarBehavior.floating,
          ),
        );
        widget.onOfferCreated();
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Failed to post offer."),
            backgroundColor: Colors.red,
            dismissDirection: DismissDirection.horizontal,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: const Text(
          "Create Travel Offer",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSectionTitle("Route Information"),
              Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      DropdownButtonFormField<int>(
                        value: fromCityId,
                        decoration: inputStyle(
                          "Departure City",
                          Icons.location_on_outlined,
                        ),
                        items: cities.map<DropdownMenuItem<int>>((city) {
                          return DropdownMenuItem<int>(
                            value: city.id,
                            child: Text(city.name),
                          );
                        }).toList(),
                        onChanged: (val) => setState(() {
                          fromCityId = val;
                          if (fromCityId == toCityId) toCityId = null;
                        }),
                        validator: (v) => v == null ? "Required" : null,
                      ),
                      const SizedBox(height: 20),
                      DropdownButtonFormField<int>(
                        value: toCityId,
                        decoration: inputStyle(
                          "Destination City",
                          Icons.flag_outlined,
                        ),
                        items: cities
                            .where((c) => c.id != fromCityId)
                            .map<DropdownMenuItem<int>>((city) {
                              return DropdownMenuItem<int>(
                                value: city.id,
                                child: Text(city.name),
                              );
                            })
                            .toList(),
                        onChanged: (val) => setState(() => toCityId = val),
                        validator: (v) => v == null ? "Required" : null,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 30),
              _buildSectionTitle("Trip Details"),
              Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      DropdownButtonFormField<int>(
                        value: selectedVehicleId,
                        decoration: inputStyle(
                          "Select Vehicle",
                          Icons.directions_car_filled_outlined,
                        ),
                        items: userVehicles.map((vehicle) {
                          return DropdownMenuItem<int>(
                            value: vehicle.id,
                            child: Text(
                              "${vehicle.make.name} ${vehicle.model} (${vehicle.year})",
                            ),
                          );
                        }).toList(),
                        onChanged: (val) => setState(() {
                          selectedVehicleId = val;
                          handleVehicleChange(val);
                        }),
                        validator: (v) =>
                            v == null ? "Please select a vehicle" : null,
                      ),
                      const SizedBox(height: 20),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: Colors.grey.shade300,
                          ), // Matches your enabledBorder
                          color: Colors.white,
                        ),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.settings_accessibility,
                              color: Colors.deepPurple,
                            ),
                            const SizedBox(width: 12),
                            Text(
                              "Seats to offer",
                              style: TextStyle(
                                color: Colors.grey.shade700,
                                fontSize: 16,
                              ),
                            ),
                            const Spacer(),
                            // Minus Button
                            IconButton(
                              iconSize: 32,
                              onPressed: canDecrement
                                  ? () => updateSeats(-1)
                                  : null,
                              icon: const Icon(
                                Icons.remove_circle,
                                color: Colors.deepPurple,
                              ),
                            ),
                            // Number Display
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8.0,
                              ),
                              child: Text(
                                availableSeatsController.text,
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                            // Plus Button
                            IconButton(
                              iconSize: 32,
                              onPressed: canIncrement
                                  ? () => updateSeats(1)
                                  : null,
                              icon: const Icon(
                                Icons.add_circle,
                                color: Colors.deepPurple,
                              ),
                            ),
                          ],
                        ),
                      ),
                      // const SizedBox(height: 20),
                      const SizedBox(height: 20),
                      TextFormField(
                        controller: priceController,
                        keyboardType: TextInputType.number,
                        decoration: inputStyle("Price per Seat", Icons.euro),
                        validator: (v) =>
                            (v == null || v.isEmpty) ? "Required" : null,
                      ),
                      const SizedBox(height: 10),
                      const Divider(),
                      ListTile(
                        leading: const CircleAvatar(
                          backgroundColor: Colors.deepPurple,
                          child: Icon(
                            Icons.calendar_month,
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                        title: const Text(
                          "Departure Time",
                          style: TextStyle(fontSize: 14, color: Colors.grey),
                        ),
                        subtitle: Text(
                          "${selectedDateTime.day}/${selectedDateTime.month} at ${selectedDateTime.hour.toString().padLeft(2, '0')}:${selectedDateTime.minute.toString().padLeft(2, '0')}",
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        onTap: _pickDateTime,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 40),
              ElevatedButton(
                onPressed: submitOffer,
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size.fromHeight(55),
                  backgroundColor: Colors.deepPurple,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  elevation: 5,
                ),
                child: const Text(
                  "POST OFFER",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 10),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Colors.grey.shade800,
        ),
      ),
    );
  }

  Future<void> _pickDateTime() async {
    DateTime? d = await showDatePicker(
      context: context,
      initialDate: selectedDateTime,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 30)),
    );
    if (d != null) {
      TimeOfDay? t = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(selectedDateTime),
      );
      if (t != null) {
        setState(
          () => selectedDateTime = DateTime(
            d.year,
            d.month,
            d.day,
            t.hour,
            t.minute,
          ),
        );
      }
    }
  }
}
