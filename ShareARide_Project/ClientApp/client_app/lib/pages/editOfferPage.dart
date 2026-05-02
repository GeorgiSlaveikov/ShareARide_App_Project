import 'package:client_app/controllers/offerUtils.dart';
import 'package:client_app/controllers/userUtils.dart';
import 'package:flutter/material.dart';

import '../controllers/cityUtils.dart';
import '../controllers/vehicleUtils.dart';
import '../entity/offer.dart';
import '../entity/vehicle.dart';

class EditOfferPage extends StatefulWidget {
  final Offer offer;
  final VoidCallback onOfferUpdated;

  const EditOfferPage({
    super.key,
    required this.offer,
    required this.onOfferUpdated,
  });

  @override
  State<EditOfferPage> createState() => _EditOfferPageState();
}

class _EditOfferPageState extends State<EditOfferPage> {
  final formKey = GlobalKey<FormState>();

  final priceController = TextEditingController();
  final availableSeatsController = TextEditingController();

  DateTime selectedDateTime = DateTime.now();

  int? fromCityId;
  int? toCityId;
  int? selectedVehicleId;

  List<dynamic> cities = [];
  List<Vehicle> userVehicles = [];

  Vehicle? selectedVehicle;

  bool isLoading = true;
  bool isSaving = false;

  @override
  void initState() {
    super.initState();
    loadInitialData();
  }

  @override
  void dispose() {
    priceController.dispose();
    availableSeatsController.dispose();
    super.dispose();
  }

  Future<void> loadInitialData() async {
    final loadedCities = await CityUtils.getCities();
    final userId = await UserUtils.getCurrentUserId();
    final vehicles = await VehicleUtils.getMyVehicles(userId);

    if (!mounted) return;

    setState(() {
      cities = loadedCities;
      userVehicles = vehicles;

      selectedDateTime = widget.offer.departureTime;

      fromCityId = widget.offer.departureCity?.id;
      toCityId = widget.offer.destinationCity?.id;

      selectedVehicleId = widget.offer.vehicleId;

      priceController.text = widget.offer.pricePerSeat.toStringAsFixed(2);
      availableSeatsController.text = widget.offer.availableSeats.toString();

      if (userVehicles.isNotEmpty) {
        selectedVehicle = userVehicles.firstWhere(
          (v) => v.id == selectedVehicleId,
          orElse: () => userVehicles.first,
        );

        selectedVehicleId = selectedVehicle?.id;
      }

      isLoading = false;
    });
  }

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

  void handleVehicleChange(int? vehicleId) {
    if (vehicleId == null) return;

    final vehicle = userVehicles.firstWhere((v) => v.id == vehicleId);

    int currentSeats = int.tryParse(availableSeatsController.text) ?? 1;

    if (currentSeats > vehicle.maxCapacity) {
      currentSeats = vehicle.maxCapacity;
    }

    setState(() {
      selectedVehicleId = vehicleId;
      selectedVehicle = vehicle;
      availableSeatsController.text = currentSeats.toString();
    });
  }

  void updateSeats(int delta) {
    if (selectedVehicle == null) return;

    final currentSeats = int.tryParse(availableSeatsController.text) ?? 1;
    final newSeats = currentSeats + delta;

    if (newSeats < 1 || newSeats > selectedVehicle!.maxCapacity) return;

    setState(() {
      availableSeatsController.text = newSeats.toString();
    });
  }

  Future<void> submitEdit() async {
    if (!formKey.currentState!.validate()) return;

    if (widget.offer.id == null) {
      showError("Невалидна оферта.");
      return;
    }

    if (selectedVehicleId == null || fromCityId == null || toCityId == null) {
      showError("Моля, попълнете всички полета.");
      return;
    }

    setState(() {
      isSaving = true;
    });

    final success = await OfferUtils.updateOffer(
      offerId: widget.offer.id!,
      vehicleId: selectedVehicleId!,
      departureTime: selectedDateTime.toIso8601String(),
      departureCityId: fromCityId!,
      destinationCityId: toCityId!,
      pricePerSeat: double.parse(priceController.text),
      availableSeats: int.parse(availableSeatsController.text),
    );

    if (!mounted) return;

    setState(() {
      isSaving = false;
    });

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Офертата е редактирана успешно!"),
          backgroundColor: Colors.green,
          dismissDirection: DismissDirection.horizontal,
          behavior: SnackBarBehavior.floating,
        ),
      );

      widget.onOfferUpdated();
      Navigator.pop(context);
    } else {
      showError("Редактирането на офертата не бе успешно.");
    }
  }

  void showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        dismissDirection: DismissDirection.horizontal,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  Future<void> pickDateTime() async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: selectedDateTime,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 30)),
    );

    if (pickedDate == null) return;

    final pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(selectedDateTime),
    );

    if (pickedTime == null) return;

    setState(() {
      selectedDateTime = DateTime(
        pickedDate.year,
        pickedDate.month,
        pickedDate.day,
        pickedTime.hour,
        pickedTime.minute,
      );
    });
  }

  Widget buildSectionTitle(String title) {
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

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Scaffold(
        appBar: AppBar(
          title: const Text("Редактиране на оферта"),
          backgroundColor: Colors.deepPurple,
          foregroundColor: Colors.white,
        ),
        body: const Center(
          child: CircularProgressIndicator(color: Colors.deepPurple),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: const Text(
          "Редактиране на оферта",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              buildSectionTitle("Информация за маршрута"),

              Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      DropdownButtonFormField<int>(
                        value: fromCityId,
                        decoration: inputStyle(
                          "Град на заминаване",
                          Icons.location_on_outlined,
                        ),
                        items: cities.map<DropdownMenuItem<int>>((city) {
                          return DropdownMenuItem<int>(
                            value: city.id,
                            child: Text(city.name),
                          );
                        }).toList(),
                        onChanged: (val) {
                          setState(() {
                            fromCityId = val;
                            if (fromCityId == toCityId) {
                              toCityId = null;
                            }
                          });
                        },
                        validator: (v) => v == null ? "Задължително" : null,
                      ),

                      const SizedBox(height: 20),

                      DropdownButtonFormField<int>(
                        value: toCityId,
                        decoration: inputStyle(
                          "Град на дестинация",
                          Icons.flag_outlined,
                        ),
                        items: cities
                            .where((city) => city.id != fromCityId)
                            .map<DropdownMenuItem<int>>((city) {
                          return DropdownMenuItem<int>(
                            value: city.id,
                            child: Text(city.name),
                          );
                        }).toList(),
                        onChanged: (val) {
                          setState(() {
                            toCityId = val;
                          });
                        },
                        validator: (v) => v == null ? "Задължително" : null,
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 30),

              buildSectionTitle("Детайли за пътуването"),

              Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      DropdownButtonFormField<int>(
                        value: selectedVehicleId,
                        decoration: inputStyle(
                          "Изберете превозно средство",
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
                        onChanged: handleVehicleChange,
                        validator: (v) => v == null
                            ? "Моля, изберете превозно средство"
                            : null,
                      ),

                      const SizedBox(height: 20),

                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.grey.shade300),
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
                              "Предлагани места",
                              style: TextStyle(
                                color: Colors.grey.shade700,
                                fontSize: 16,
                              ),
                            ),
                            const Spacer(),
                            IconButton(
                              iconSize: 32,
                              onPressed:
                                  (int.tryParse(availableSeatsController.text) ?? 1) > 1
                                      ? () => updateSeats(-1)
                                      : null,
                              icon: const Icon(
                                Icons.remove_circle,
                                color: Colors.deepPurple,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 8),
                              child: Text(
                                availableSeatsController.text,
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                            IconButton(
                              iconSize: 32,
                              onPressed: selectedVehicle != null &&
                                      (int.tryParse(availableSeatsController.text) ?? 1) <
                                          selectedVehicle!.maxCapacity
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

                      const SizedBox(height: 20),

                      TextFormField(
                        controller: priceController,
                        keyboardType: TextInputType.number,
                        decoration: inputStyle("Цена за място", Icons.euro),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return "Задължително";
                          }

                          final price = double.tryParse(value);

                          if (price == null || price <= 0) {
                            return "Въведете валидна цена";
                          }

                          return null;
                        },
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
                          "Време на тръгване",
                          style: TextStyle(fontSize: 14, color: Colors.grey),
                        ),
                        subtitle: Text(
                          "${selectedDateTime.day}/${selectedDateTime.month}/${selectedDateTime.year} в "
                          "${selectedDateTime.hour.toString().padLeft(2, '0')}:"
                          "${selectedDateTime.minute.toString().padLeft(2, '0')}",
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        onTap: pickDateTime,
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 40),

              ElevatedButton(
                onPressed: isSaving ? null : submitEdit,
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size.fromHeight(55),
                  backgroundColor: Colors.deepPurple,
                  disabledBackgroundColor: Colors.grey,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  elevation: 5,
                ),
                child: isSaving
                    ? const SizedBox(
                        width: 22,
                        height: 22,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                    : const Text(
                        "ЗАПАЗИ ПРОМЕНИТЕ",
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
}