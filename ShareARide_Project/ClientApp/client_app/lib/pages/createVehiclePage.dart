import 'package:flutter/material.dart';
import '../entity/vehicleMake.dart'; // Path to your Enum
import '../controllers/vehicleUtils.dart'; // Path to the Utility file created earlier

class CreateVehiclePage extends StatefulWidget {
  const CreateVehiclePage({super.key});

  @override
  State<CreateVehiclePage> createState() => _CreateVehiclePageState();
}

class _CreateVehiclePageState extends State<CreateVehiclePage> {
  final _formKey = GlobalKey<FormState>();

  // Form Values
  VehicleMake? _selectedMake;
  String? _selectedModel;
  int _selectedYear = DateTime.now().year;
  int _seats = 4;

  // Dynamic list of models based on selection
  List<String> _availableModels = [];

  // Generate a list of years (e.g., from 1990 to current year + 1)
  final List<int> _years = List.generate(
    (DateTime.now().year + 1) - 1990,
    (index) => (DateTime.now().year + 1) - index,
  );

  void _handleMakeChange(VehicleMake? newValue) {
    setState(() {
      _selectedMake = newValue;
      _selectedModel = null; // Reset model if make changes
      if (newValue != null) {
        _availableModels = VehicleUtils.getModelsForMake(newValue);
      } else {
        _availableModels = [];
      }
    });
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      // Logic to save the vehicle to your database/API
      final vehicleData = {
        "make": _selectedMake?.name,
        "model": _selectedModel,
        "year": _selectedYear,
        "maxCapacity": _seats,
      };

      Navigator.pop(context, vehicleData);
      
      // print("Vehicle Created: $vehicleData");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Vehicle created successfully!")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add New Vehicle"),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Vehicle Details",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),

              // --- MAKE DROPDOWN ---
              _buildLabel("Vehicle Make"),
              DropdownButtonFormField<VehicleMake>(
                decoration: _inputDecoration("Select Brand"),
                value: _selectedMake,
                items: VehicleMake.values.map((make) {
                  return DropdownMenuItem(
                    value: make,
                    child: Text(make.name),
                  );
                }).toList(),
                onChanged: _handleMakeChange,
                validator: (value) => value == null ? "Please select a make" : null,
              ),

              const SizedBox(height: 20),

              // --- MODEL DROPDOWN ---
              _buildLabel("Vehicle Model"),
              DropdownButtonFormField<String>(
                decoration: _inputDecoration("Select Model"),
                value: _selectedModel,
                disabledHint: const Text("Select a make first"),
                items: _availableModels.map((model) {
                  return DropdownMenuItem(
                    value: model,
                    child: Text(model),
                  );
                }).toList(),
                onChanged: (val) => setState(() => _selectedModel = val),
                validator: (value) => value == null ? "Please select a model" : null,
              ),

              const SizedBox(height: 20),

              Row(
                children: [
                  // --- YEAR DROPDOWN ---
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildLabel("Year"),
                        DropdownButtonFormField<int>(
                          decoration: _inputDecoration(null),
                          value: _selectedYear,
                          items: _years.map((year) {
                            return DropdownMenuItem(
                              value: year,
                              child: Text(year.toString()),
                            );
                          }).toList(),
                          onChanged: (val) => setState(() => _selectedYear = val!),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  // --- SEATS COUNTER ---
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildLabel("Seats"),
                        DropdownButtonFormField<int>(
                          decoration: _inputDecoration(null),
                          value: _seats,
                          items: [2, 4, 5, 7, 8, 9].map((s) {
                            return DropdownMenuItem(
                              value: s,
                              child: Text("$s Seats"),
                            );
                          }).toList(),
                          onChanged: (val) => setState(() => _seats = val!),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 40),

              // --- SUBMIT BUTTON ---
              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  onPressed: _submitForm,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurple,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    "Add Vehicle",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // --- UI HELPERS ---

  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(
        text,
        style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.grey),
      ),
    );
  }

  InputDecoration _inputDecoration(String? hint) {
    return InputDecoration(
      hintText: hint,
      filled: true,
      fillColor: Colors.grey.shade100,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.grey.shade300),
      ),
    );
  }
}