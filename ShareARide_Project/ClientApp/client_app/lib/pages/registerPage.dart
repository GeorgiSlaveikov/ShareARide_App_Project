import 'package:client_app/controllers/cityUtils.dart';
import 'package:client_app/entity/sex.dart';
import 'package:flutter/material.dart';
import '../controllers/userUtils.dart';
import '../controllers/utils.dart';

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
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  bool _isConnected = false;
  bool _isLoading = false;

  File? _selectedImage;
  final ImagePicker _picker = ImagePicker();

  var cities = [];

  Sex? _selectedSex = Sex.Male;

  DateTime get _latestAllowedBirthDate {
    final now = DateTime.now();
    return DateTime(now.year - 18, now.month, now.day);
  }

  @override
  void initState() {
    super.initState();

    final defaultBirthDate = _latestAllowedBirthDate;
    _birthDateController.text =
        "${defaultBirthDate.year}-${defaultBirthDate.month.toString().padLeft(2, '0')}-${defaultBirthDate.day.toString().padLeft(2, '0')}";

    _verifyConnection();

    CityUtils.getCities().then((data) {
      if (!mounted) return;

      setState(() {
        cities = data;
      });
    });
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _phoneNumberController.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
    _birthDateController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();

    super.dispose();
  }

  void _verifyConnection() async {
    bool status = await Utils.checkConnection();

    if (!mounted) return;

    setState(() {
      _isConnected = status;
    });
  }

  Future<void> _pickImage(ImageSource source) async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: source,
        maxWidth: 1000,
        maxHeight: 1000,
        imageQuality: 85,
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
    final latestAllowedDate = _latestAllowedBirthDate;

    DateTime? initialDate;

    if (_birthDateController.text.isNotEmpty) {
      initialDate = DateTime.tryParse(_birthDateController.text);
    }

    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: initialDate ?? latestAllowedDate,
      firstDate: DateTime(1900),
      lastDate: latestAllowedDate,
    );

    if (picked != null) {
      setState(() {
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

  bool _isBirthDateValid() {
    final birthDate = DateTime.tryParse(_birthDateController.text);

    if (birthDate == null) {
      return false;
    }

    return !birthDate.isAfter(_latestAllowedBirthDate);
  }

  @override
  Widget build(BuildContext context) {
    final themeColor = Colors.deepPurple;
    final secondaryColor = Colors.blueAccent;

    return Scaffold(
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
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: _showImagePickerOptions,
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
                        ConnectionBadgeElement(_isConnected),

                        const SizedBox(height: 24),

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
                          icon: Icons.email_outlined,
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

                            if (!_isBirthDateValid()) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                    "Трябва да сте навършили поне 18 години.",
                                  ),
                                  backgroundColor: Colors.redAccent,
                                ),
                              );
                              return;
                            }

                            handleRegister();
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
    if (_selectedSex == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Моля, изберете пол."),
          backgroundColor: Colors.redAccent,
        ),
      );
      return;
    }

    if (!_isBirthDateValid()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Трябва да сте навършили поне 18 години."),
          backgroundColor: Colors.redAccent,
        ),
      );
      return;
    }

    final birthDate = DateTime.tryParse(_birthDateController.text);

    if (birthDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Моля, изберете валидна дата на раждане."),
          backgroundColor: Colors.redAccent,
        ),
      );
      return;
    }

    setState(() => _isLoading = true);

    var response = await UserUtils.Register(
      _usernameController.text,
      _firstNameController.text,
      _lastNameController.text,
      _phoneNumberController.text,
      _emailController.text,
      _birthDateController.text,
      _calculateAge(birthDate),
      _selectedSex!.index,
      _passwordController.text,
      _selectedImage,
    );

    if (!mounted) return;

    setState(() => _isLoading = false);

    final bool success = response['success'] ?? false;
    final String message =
        response['message'] ?? 'Unknown response from server';

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: Colors.green,
        ),
      );

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const MyApp()),
        (route) => false,
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: Colors.redAccent,
        ),
      );
    }
  }
}