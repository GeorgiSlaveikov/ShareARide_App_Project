import 'package:flutter/material.dart';
import '../entity/vehicleMake.dart'; // Path to your Enum
import '../controllers/vehicleUtils.dart'; // Path to the Utility file created earlier
import 'dart:io'; // Required for File
import 'package:image_picker/image_picker.dart'; // Import the picker

class CreateVehiclePage extends StatefulWidget {
  const CreateVehiclePage({super.key});

  @override
  State<CreateVehiclePage> createState() => _CreateVehiclePageState();
}

class _CreateVehiclePageState extends State<CreateVehiclePage> {
  final _formKey = GlobalKey<FormState>();

  File? _vehicleImage; // Variable to store the picked image
  final ImagePicker _picker = ImagePicker(); // Initialize picker

  Future<void> pickImage() async {
    // Show a dialog to choose between Camera or Gallery
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => SafeArea(
        child: Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text('Направете снимка'),
              onTap: () => handleImageSource(ImageSource.camera),
            ),
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('Изберете от галерия'),
              onTap: () => handleImageSource(ImageSource.gallery),
            )
          ],
        ),
      ),
    );
  }

  Future<void> handleImageSource(ImageSource source) async {
    Navigator.pop(context); // Close bottom sheet
    final XFile? pickedFile = await _picker.pickImage(
      source: source,
      maxWidth: 1000, // Optimize image size
      maxHeight: 1000,
      imageQuality: 85,
    );

    if (pickedFile != null) {
      setState(() {
        _vehicleImage = File(pickedFile.path);
      });
    }
  }

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

  void handleMakeChange(VehicleMake? newValue) {
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

  void submitForm() {
    if (_formKey.currentState!.validate()) {
      // Logic to save the vehicle to your database/API
      final vehicleData = {
        "make": _selectedMake?.name,
        "model": _selectedModel,
        "year": _selectedYear,
        "maxCapacity": _seats,
        "vehiclePicture": _vehicleImage,
      };

      Navigator.pop(context, vehicleData);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Превозното средство е създадено успешно!"),
          dismissDirection: DismissDirection.horizontal,
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Добавяне на ново превозно средство"),
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
                "Детайли за превозното средство",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),

              // --- MAKE DROPDOWN ---
              buildLabel("Направи превозно средство"),
              DropdownButtonFormField<VehicleMake>(
                decoration: _inputDecoration("Изберете марка"),
                value: _selectedMake,
                items: VehicleMake.values.map((make) {
                  return DropdownMenuItem(value: make, child: Text(make.name));
                }).toList(),
                onChanged: handleMakeChange,
                validator: (value) =>
                    value == null ? "Моля, изберете направи" : null,
              ),

              const SizedBox(height: 20),

              // --- MODEL DROPDOWN ---
              buildLabel("Модел на превозното средство"),
              DropdownButtonFormField<String>(
                decoration: _inputDecoration("Изберете модел"),
                value: _selectedModel,
                disabledHint: const Text("Изберете направи първо"),
                items: _availableModels.map((model) {
                  return DropdownMenuItem(value: model, child: Text(model));
                }).toList(),
                onChanged: (val) => setState(() => _selectedModel = val),
                validator: (value) =>
                    value == null ? "Моля, изберете модел" : null,
              ),

              const SizedBox(height: 20),

              Row(
                children: [
                  // --- YEAR DROPDOWN ---
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        buildLabel("Година"),
                        DropdownButtonFormField<int>(
                          decoration: _inputDecoration(null),
                          value: _selectedYear,
                          items: _years.map((year) {
                            return DropdownMenuItem(
                              value: year,
                              child: Text(year.toString()),
                            );
                          }).toList(),
                          onChanged: (val) =>
                              setState(() => _selectedYear = val!),
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
                        buildLabel("Места"),
                        DropdownButtonFormField<int>(
                          decoration: _inputDecoration(null),
                          value: _seats,
                          items: [2, 4, 5, 7, 8, 9].map((s) {
                            return DropdownMenuItem(
                              value: s,
                              child: Text("$s Места"),
                            );
                          }).toList(),
                          onChanged: (val) => setState(() => _seats = val!),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              // --- VEHICLE PHOTO ---
              const SizedBox(height: 20),
              buildLabel("Снимка на превозно средство"),
              Center(
                child: GestureDetector(
                  onTap: pickImage,
                  child: Container(
                    width: 360,
                    height: 360,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.grey.shade300, width: 2),
                      image: _vehicleImage != null
                          ? DecorationImage(
                              image: FileImage(_vehicleImage!),
                              fit: BoxFit.cover,
                            )
                          : null,
                    ),
                    child: _vehicleImage == null
                        ? Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.add_a_photo,
                                size: 50,
                                color: Colors.deepPurple.shade300,
                              ),
                              const SizedBox(height: 8),
                              const Text(
                                "Качете снимка",
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          )
                        : Stack(
                            children: [
                              Positioned(
                                right: 5,
                                top: 5,
                                child: CircleAvatar(
                                  backgroundColor: Colors.red.withOpacity(0.8),
                                  radius: 15,
                                  child: IconButton(
                                    icon: const Icon(
                                      Icons.close,
                                      size: 15,
                                      color: Colors.white,
                                    ),
                                    onPressed: () =>
                                        setState(() => _vehicleImage = null),
                                  ),
                                ),
                              ),
                            ],
                          ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              // --- SUBMIT BUTTON ---
              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  onPressed: submitForm,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurple,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    "Добавете превозно средство",
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

  Widget buildLabel(String text) {
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
