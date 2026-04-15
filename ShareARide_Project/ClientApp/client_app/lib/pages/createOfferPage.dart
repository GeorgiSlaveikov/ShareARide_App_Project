import 'package:client_app/controllers/offerUtils.dart';
import 'package:client_app/controllers/userUtils.dart';
import 'package:flutter/material.dart';
import '../controllers/cityUtils.dart';

class CreateOfferPage extends StatefulWidget {
  final VoidCallback onOfferCreated;
  const CreateOfferPage({super.key, required this.onOfferCreated});

  @override
  State<CreateOfferPage> createState() => _CreateOfferPageState();
}

class _CreateOfferPageState extends State<CreateOfferPage> {
  final _formKey = GlobalKey<FormState>();
  final _priceController = TextEditingController();
  DateTime _selectedDateTime = DateTime.now().add(const Duration(hours: 2));

  int? _fromCityId;
  int? _toCityId;
  List<dynamic> cities = [];

  @override
  void initState() {
    super.initState();
    CityUtils.getCities().then((data) => setState(() => cities = data));
  }

  // Reuseable styling for Input Decorations
  InputDecoration _inputStyle(String label, IconData icon, {String? prefix}) {
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

  void _submitOffer() async {
    if (_formKey.currentState!.validate()) {
      bool success = await OfferUtils.createOffer(
        UserUtils.getCurrentUserId(), // Hardcoded Driver ID for now
        1, // Hardcoded Vehicle ID for now
        _selectedDateTime.toIso8601String(),
        _fromCityId!,
        _toCityId!,
        double.parse(_priceController.text),
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
          key: _formKey,
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
                        value: _fromCityId,
                        decoration: _inputStyle(
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
                          _fromCityId = val;
                          if (_fromCityId == _toCityId) _toCityId = null;
                        }),
                        validator: (v) => v == null ? "Required" : null,
                      ),
                      const SizedBox(height: 20),
                      DropdownButtonFormField<int>(
                        value: _toCityId,
                        decoration: _inputStyle(
                          "Destination City",
                          Icons.flag_outlined,
                        ),
                        items: cities
                            .where((c) => c.id != _fromCityId)
                            .map<DropdownMenuItem<int>>((city) {
                              return DropdownMenuItem<int>(
                                value: city.id,
                                child: Text(city.name),
                              );
                            })
                            .toList(),
                        onChanged: (val) => setState(() => _toCityId = val),
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
                      TextFormField(
                        controller: _priceController,
                        keyboardType: TextInputType.number,
                        decoration: _inputStyle(
                          "Price per Seat",
                          Icons.attach_money,
                          prefix: "\$ ",
                        ),
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
                          "${_selectedDateTime.day}/${_selectedDateTime.month} at ${_selectedDateTime.hour.toString().padLeft(2, '0')}:${_selectedDateTime.minute.toString().padLeft(2, '0')}",
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
                onPressed: _submitOffer,
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
      initialDate: _selectedDateTime,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 30)),
    );
    if (d != null) {
      TimeOfDay? t = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(_selectedDateTime),
      );
      if (t != null) {
        setState(
          () => _selectedDateTime = DateTime(
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
