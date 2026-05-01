import 'package:client_app/controllers/cityUtils.dart';
import 'package:client_app/entity/sex.dart';
import 'package:flutter/material.dart';
import '../controllers/userUtils.dart';
import '../controllers/utils.dart';

// import '../styles/mainColors.dart';

import '../elements/textFieldElement.dart';
import '../elements/connectionBadgeElement.dart';
import '../elements/mainButtonElement.dart';

import 'package:image_picker/image_picker.dart';
import 'dart:io';

import '../main.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _birthDateController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  bool _isConnected = false;
  bool _isLoading = false;

  File? _selectedImage;
  final ImagePicker _picker = ImagePicker();

  var cities = [];


  Sex? _selectedSex = Sex.Male;

  void _verifyConnection() async {
    bool status = await Utils.checkConnection();
    setState(() {
      _isConnected = status;
    });
  }

  @override
  void initState() {
    super.initState();
    _verifyConnection();
    CityUtils.getCities().then((data) {
      setState(() {
        cities = data;
      });
    });
  }

  Future<void> _pickImage(ImageSource source) async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: source,
        maxWidth: 1000, // Optimize image size
        maxHeight: 1000,
        imageQuality: 85, // Compress slightly for faster upload
      );

      if (pickedFile != null) {
        setState(() {
          _selectedImage = File(pickedFile.path);
        });
      }
    } catch (e) {
      debugPrint("Грешка при избора на изображение: $e");
    }
  }

  // This creates the "Alert/Action Sheet" at the bottom
  void _showImagePickerOptions() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => SafeArea(
        child: Wrap(
          children: [
            const ListTile(
              title: Text(
                'Профилна снимка',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.camera_alt, color: Colors.deepPurple),
              title: const Text('Направете снимка'),
              onTap: () {
                Navigator.pop(context);
                _pickImage(ImageSource.camera);
              },
            ),
            ListTile(
              leading: const Icon(
                Icons.photo_library,
                color: Colors.deepPurple,
              ),
              title: const Text('Избере от галерия'),
              onTap: () {
                Navigator.pop(context);
                _pickImage(ImageSource.gallery);
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900), // Adjust based on your needs
      lastDate: DateTime.now(),
    );

    if (picked != null) {
      setState(() {
        // _selectedBirthDate = picked; // Store the actual DateTime object
        // Format it for the UI
        _birthDateController.text =
            "${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}";
      });
    }
  }

  int _calculateAge(DateTime birthDate) {
    DateTime today = DateTime.now();
    int age = today.year - birthDate.year;
    if (today.month < birthDate.month ||
        (today.month == birthDate.month && today.day < birthDate.day)) {
      age--;
    }
    return age;
  }

  @override
  Widget build(BuildContext context) {
    final themeColor = Colors.deepPurple;
    final secondaryColor = Colors.blueAccent;

    return Scaffold(
      // 1. Cool Gradient Background
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              themeColor.shade900,
              themeColor.shade600,
              secondaryColor.shade400,
            ],
          ),
        ),
        child: Center(
          // Makes the content scrollable on small screens
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: _showImagePickerOptions, // Trigger the alert
                  child: Stack(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.1),
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white24, width: 2),
                        ),
                        child: CircleAvatar(
                          radius: 50,
                          backgroundColor: Colors.white10,
                          backgroundImage: _selectedImage != null
                              ? FileImage(_selectedImage!)
                              : null,
                          child: _selectedImage == null
                              ? const Icon(
                                  Icons.person,
                                  size: 60,
                                  color: Colors.white,
                                )
                              : null,
                        ),
                      ),
                      // Little camera icon badge
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: CircleAvatar(
                          radius: 18,
                          backgroundColor: themeColor,
                          child: const Icon(
                            Icons.add_a_photo,
                            size: 18,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                // // 2. Stylish App Icon/Logo Placeholder
                // Container(
                //   padding: const EdgeInsets.all(16),
                //   decoration: BoxDecoration(
                //     color: Colors.white.withOpacity(0.1),
                //     shape: BoxShape.circle,
                //     border: Border.all(color: Colors.white24, width: 2),
                //   ),
                //   child: const Icon(
                //     Icons.account_circle,
                //     size: 80,
                //     color: Colors.white,
                //   ),
                // ),
                const SizedBox(height: 16),
                const Text(
                  "ДОБРЕ ДОШЛИ",
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    letterSpacing: 1.5,
                  ),
                ),
                const Text(
                  "Създайте си акаунт",
                  style: TextStyle(fontSize: 16, color: Colors.white70),
                ),
                const SizedBox(height: 32),

                // 3. Floating Card Container for the Form
                Card(
                  elevation: 12,
                  shadowColor: Colors.black45,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 32,
                    ),
                    constraints: const BoxConstraints(maxWidth: 450),
                    child: Column(
                      children: [
                        // Connection Status Indicator (Styled)
                        ConnectionBadgeElement(_isConnected),
                        const SizedBox(height: 24),

                        // 4. Modern Input Fields
                        TextFieldElement(
                          controller: _usernameController,
                          label: "Прякор",
                          icon: Icons.person_outline,
                          color: themeColor,
                        ),
                        const SizedBox(height: 16),
                        TextFieldElement(
                          controller: _emailController,
                          label: "Емейл",
                          icon: Icons.person_outline,
                          color: themeColor,
                        ),
                        const SizedBox(height: 16),
                        TextFieldElement(
                          controller: _phoneNumberController,
                          label: "Телефонен номер",
                          icon: Icons.phone,
                          color: themeColor,
                        ),
                        const SizedBox(height: 32),
                        TextFieldElement(
                          controller: _firstNameController,
                          label: "Първо име",
                          icon: Icons.person_outline,
                          color: themeColor,
                        ),
                        const SizedBox(height: 16),
                        TextFieldElement(
                          controller: _lastNameController,
                          label: "Фамилия",
                          icon: Icons.person_outline,
                          color: themeColor,
                        ),
                        const SizedBox(height: 16),
                        TextFieldElement(
                          onTap: () => _selectDate(context),
                          controller: _birthDateController,
                          label: "Дата на раждане",
                          icon: Icons.calendar_today,
                          color: themeColor,
                          obscureText: false,
                        ),
                        const SizedBox(height: 16),
                        DropdownButtonFormField<int>(
                          value: _selectedSex?.index,
                          decoration: InputDecoration(
                            labelText: "Изберете пол",
                            prefixIcon: Icon(
                              Icons.person_outline,
                              color: themeColor,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          items: Sex.values.map((sex) {
                            return DropdownMenuItem<int>(
                              value: sex.index,
                              child: Text(sex.toString().split('.').last),
                            );
                          }).toList(),
                          onChanged: (value) {
                            setState(() {
                              _selectedSex = Sex.values[value!];
                            });
                          },
                          validator: (value) =>
                              value == null ? "Моля, изберете пол" : null,
                        ),
                        const SizedBox(height: 32),
                        TextFieldElement(
                          controller: _passwordController,
                          label: "Парола",
                          icon: Icons.lock_outline,
                          color: themeColor,
                          obscureText: true,
                        ),
                        const SizedBox(height: 16),
                        TextFieldElement(
                          controller: _confirmPasswordController,
                          label: "Потвърдете паролата",
                          icon: Icons.lock_outline,
                          color: themeColor,
                          obscureText: true,
                        ),

                        const SizedBox(height: 16),

                        MainButtonElement(
                          onPressed: () {
                            if (_passwordController.text !=
                                _confirmPasswordController.text) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text("Паролите не съвпадат!"),
                                  backgroundColor: Colors.redAccent,
                                ),
                              );
                              return;
                            }
                            handleRegister();
                            Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const MyApp(),
                          ),
                          (route) =>
                              false, // This clears the entire navigation history
                        );
                          },
                          isLoading: _isLoading,
                          text: "Регистрация",
                          color: themeColor,
                        ),
                        const SizedBox(height: 16),

                        TextButton(
                          onPressed: _isLoading
                              ? null
                              : () {
                                  Navigator.pop(context);
                                },
                          child: RichText(
                            text: TextSpan(
                              text: "Върни се към ",
                              style: const TextStyle(color: Colors.black54),
                              children: [
                                TextSpan(
                                  text: "Влизане",
                                  style: TextStyle(
                                    color: themeColor,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void handleRegister() async {
    setState(() => _isLoading = true);
    bool response = await UserUtils.Register(
      _usernameController.text,
      _firstNameController.text,
      _lastNameController.text,
      _phoneNumberController.text,
      _emailController.text,
      _birthDateController.text,
      _calculateAge(
        _birthDateController.text.isNotEmpty
            ? DateTime.parse(_birthDateController.text)
            : DateTime(2000, 1, 1),
      ),
      _selectedSex!.index,
      _passwordController.text,
      _selectedImage
    );
    setState(() => _isLoading = false);

    if (response) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Успешна регистрация!"),
          backgroundColor: Colors.green,
        ),
      );
    } else {
      // Shakes the card or shows error
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Невалидни данни"),
          backgroundColor: Colors.redAccent,
        ),
      );
    }
  }
}
