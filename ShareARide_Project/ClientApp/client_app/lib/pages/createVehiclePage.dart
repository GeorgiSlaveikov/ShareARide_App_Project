import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../controllers/vehicleUtils.dart';
import '../entity/vehicleMake.dart';

class CreateVehiclePage extends StatefulWidget {
  const CreateVehiclePage({super.key});

  @override
  State<CreateVehiclePage> createState() => _CreateVehiclePageState();
}

class _CreateVehiclePageState extends State<CreateVehiclePage> {
  final _formKey = GlobalKey<FormState>();

  File? _vehicleImage;
  final ImagePicker _picker = ImagePicker();

  VehicleMake? _selectedMake;
  String? _selectedModel;
  int _selectedYear = DateTime.now().year;
  int _seats = 4;

  List<String> _availableModels = [];

  late final List<VehicleMake> _availableMakes = VehicleMake.values
      .where((make) => make != VehicleMake.Unknown)
      .toList();

  final List<int> _years = List.generate(
    (DateTime.now().year + 1) - 1990,
    (index) => (DateTime.now().year + 1) - index,
  );

  final List<int> _seatOptions = const [2, 4, 5, 7, 8, 9];

  Future<void> pickImage() async {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => SafeArea(
        child: Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.camera_alt, color: Colors.deepPurple),
              title: const Text('Направете снимка'),
              onTap: () => handleImageSource(ImageSource.camera),
            ),
            ListTile(
              leading: const Icon(Icons.photo_library, color: Colors.deepPurple),
              title: const Text('Изберете от галерия'),
              onTap: () => handleImageSource(ImageSource.gallery),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> handleImageSource(ImageSource source) async {
    Navigator.pop(context);

    final pickedFile = await _picker.pickImage(
      source: source,
      maxWidth: 1000,
      maxHeight: 1000,
      imageQuality: 85,
    );

    if (pickedFile == null) return;

    setState(() {
      _vehicleImage = File(pickedFile.path);
    });
  }

  void handleMakeChange(VehicleMake? newValue) {
    if (newValue == null || newValue == VehicleMake.Unknown) {
      setState(() {
        _selectedMake = null;
        _selectedModel = null;
        _availableModels = [];
      });
      return;
    }

    final models = VehicleUtils.getModelsForMake(newValue)
        .where((model) => model.trim().isNotEmpty)
        .map((model) => model.trim())
        .toSet()
        .toList()
      ..sort();

    setState(() {
      _selectedMake = newValue;
      _selectedModel = null;
      _availableModels = models;
    });
  }

  void submitForm() {
    if (!_formKey.currentState!.validate()) return;

    if (_selectedMake == null || _selectedMake == VehicleMake.Unknown) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Моля, изберете валидна марка."),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    if (_selectedModel == null || _selectedModel!.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Моля, изберете модел."),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    final vehicleData = {
      "make": _selectedMake!.name,
      "model": _selectedModel,
      "year": _selectedYear,
      "maxCapacity": _seats,
      "vehiclePicture": _vehicleImage,
    };

    Navigator.pop(context, vehicleData);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
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
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 20),

              buildLabel("Марка на превозното средство"),
              DropdownButtonFormField<VehicleMake>(
                decoration: _inputDecoration("Изберете марка"),
                value: _selectedMake,
                items: _availableMakes.map((make) {
                  return DropdownMenuItem<VehicleMake>(
                    value: make,
                    child: Text(make.name),
                  );
                }).toList(),
                onChanged: handleMakeChange,
                validator: (value) {
                  if (value == null || value == VehicleMake.Unknown) {
                    return "Моля, изберете марка";
                  }

                  return null;
                },
              ),

              const SizedBox(height: 20),

              buildLabel("Модел на превозното средство"),
              DropdownButtonFormField<String>(
                decoration: _inputDecoration(
                  _selectedMake == null
                      ? "Първо изберете марка"
                      : "Изберете модел",
                ),
                value: _selectedModel,
                items: _availableModels.map((model) {
                  return DropdownMenuItem<String>(
                    value: model,
                    child: Text(model),
                  );
                }).toList(),
                onChanged: _availableModels.isEmpty
                    ? null
                    : (val) {
                        setState(() {
                          _selectedModel = val;
                        });
                      },
                validator: (value) {
                  if (_selectedMake == null) {
                    return "Първо изберете марка";
                  }

                  if (value == null || value.trim().isEmpty) {
                    return "Моля, изберете модел";
                  }

                  return null;
                },
              ),

              const SizedBox(height: 20),

              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        buildLabel("Година"),
                        DropdownButtonFormField<int>(
                          decoration: _inputDecoration(null),
                          value: _selectedYear,
                          items: _years.map((year) {
                            return DropdownMenuItem<int>(
                              value: year,
                              child: Text(year.toString()),
                            );
                          }).toList(),
                          onChanged: (val) {
                            if (val == null) return;

                            setState(() {
                              _selectedYear = val;
                            });
                          },
                          validator: (value) {
                            if (value == null) {
                              return "Изберете година";
                            }

                            return null;
                          },
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(width: 16),

                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        buildLabel("Места"),
                        DropdownButtonFormField<int>(
                          decoration: _inputDecoration(null),
                          value: _seats,
                          items: _seatOptions.map((seats) {
                            return DropdownMenuItem<int>(
                              value: seats,
                              child: Text("$seats места"),
                            );
                          }).toList(),
                          onChanged: (val) {
                            if (val == null) return;

                            setState(() {
                              _seats = val;
                            });
                          },
                          validator: (value) {
                            if (value == null || value <= 0) {
                              return "Изберете места";
                            }

                            return null;
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              buildLabel("Снимка на превозното средство"),
              Center(
                child: GestureDetector(
                  onTap: pickImage,
                  child: Container(
                    width: 360,
                    height: 360,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: Colors.grey.shade300,
                        width: 2,
                      ),
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
                                right: 8,
                                top: 8,
                                child: CircleAvatar(
                                  backgroundColor: Colors.red.withOpacity(0.85),
                                  radius: 18,
                                  child: IconButton(
                                    padding: EdgeInsets.zero,
                                    icon: const Icon(
                                      Icons.close,
                                      size: 18,
                                      color: Colors.white,
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        _vehicleImage = null;
                                      });
                                    },
                                  ),
                                ),
                              ),
                            ],
                          ),
                  ),
                ),
              ),

              const SizedBox(height: 24),

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
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
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
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          color: Colors.grey,
        ),
      ),
    );
  }

  InputDecoration _inputDecoration(String? hint) {
    return InputDecoration(
      hintText: hint,
      filled: true,
      fillColor: Colors.grey.shade100,
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 12,
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.grey.shade300),
      ),
      disabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.grey.shade200),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.red),
      ),
    );
  }
}