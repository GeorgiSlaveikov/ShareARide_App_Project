import 'package:client_app/controllers/cityUtils.dart';
import 'package:client_app/entity/sex.dart';
import 'package:flutter/material.dart';
import '../controllers/userUtils.dart';

// import '../styles/mainColors.dart';

import '../elements/textFieldElement.dart';
import '../elements/connectionBadgeElement.dart';
import '../elements/mainButtonElement.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _birthDateController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  bool _isConnected = false;
  bool _isLoading = false;

  var cities = [];
  int? _selectedCityId = 1;

  Sex? _selectedSex = Sex.Male; // Default to

  void _verifyConnection() async {
    bool status = await UserUtils.checkConnection();
    setState(() {
      _isConnected = status;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _verifyConnection();
    CityUtils.getCities().then((data) {
      setState(() {
        cities = data;
      });
    });
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
                // 2. Stylish App Icon/Logo Placeholder
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.1),
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white24, width: 2),
                  ),
                  child: const Icon(
                    Icons.account_circle,
                    size: 80,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  "WELCOME",
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    letterSpacing: 1.5,
                  ),
                ),
                const Text(
                  "Create your account",
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
                          label: "Username",
                          icon: Icons.person_outline,
                          color: themeColor,
                        ),
                        const SizedBox(height: 16),
                        TextFieldElement(
                          controller: _emailController,
                          label: "Email",
                          icon: Icons.person_outline,
                          color: themeColor,
                        ),
                        const SizedBox(height: 32),
                        TextFieldElement(
                          controller: _firstNameController,
                          label: "First Name",
                          icon: Icons.person_outline,
                          color: themeColor,
                        ),
                        const SizedBox(height: 16),
                        TextFieldElement(
                          controller: _lastNameController,
                          label: "Last Name",
                          icon: Icons.person_outline,
                          color: themeColor,
                        ),
                        const SizedBox(height: 16),
                        TextFieldElement(
                          onTap: () => _selectDate(context),
                          controller: _birthDateController,
                          label: "Birth Date",
                          icon: Icons.calendar_today,
                          color: themeColor,
                          obscureText: false,
                        ),
                        const SizedBox(height: 16),
                        // 4.5 City Dropdown
                        DropdownButtonFormField<int>(
                          key: ValueKey(cities.length),
                          value: _selectedCityId,
                          decoration: InputDecoration(
                            labelText: "Select Home City",
                            prefixIcon: Icon(
                              Icons.location_city,
                              color: themeColor,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          items: cities.map((city) {
                            return DropdownMenuItem<int>(
                              value:
                                  city.id, // Ensure 'id' matches your API key
                              child: Text(
                                city.name,
                              ), // Ensure 'name' matches your API key
                            );
                          }).toList(),
                          onChanged: (value) {
                            setState(() {
                              _selectedCityId = value;
                            });
                          },
                          validator: (value) =>
                              value == null ? "Please select a city" : null,
                        ),
                        const SizedBox(height: 16),
                        // 4.5 Sex Dropdown
                        DropdownButtonFormField<int>(
                          value: _selectedSex?.index,
                          decoration: InputDecoration(
                            labelText: "Select Sex",
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
                              child: Text(
                                sex.toString().split('.').last,
                              ),
                            );
                          }).toList(),
                          onChanged: (value) {
                            setState(() {
                              _selectedSex = Sex.values[value!];
                            });
                          },
                          validator: (value) =>
                              value == null ? "Please select a sex" : null,
                        ),
                        const SizedBox(height: 32),
                        TextFieldElement(
                          controller: _passwordController,
                          label: "Password",
                          icon: Icons.lock_outline,
                          color: themeColor,
                          obscureText: true,
                        ),
                        const SizedBox(height: 16),
                        TextFieldElement(
                          controller: _confirmPasswordController,
                          label: "Confirm Password",
                          icon: Icons.lock_outline,
                          color: themeColor,
                          obscureText: true,
                        ),

                        const SizedBox(height: 16),

                        // 5. Main Action Button (Login)
                        MainButtonElement(
                          onPressed: () {
                            if (_passwordController.text !=
                                _confirmPasswordController.text) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text("Passwords do not match!"),
                                  backgroundColor: Colors.redAccent,
                                ),
                              );
                              return;
                            }
                            _handleRegister();
                          },
                          isLoading: _isLoading,
                          text: "REGISTER",
                          color: themeColor,
                        ),
                        const SizedBox(height: 16),

                        // 6. Secondary Action (Register)
                        TextButton(
                          onPressed: _isLoading
                              ? null
                              : () {
                                  Navigator.pop(context);
                                },
                          child: RichText(
                            text: TextSpan(
                              text: "Go back to ",
                              style: const TextStyle(color: Colors.black54),
                              children: [
                                TextSpan(
                                  text: "Login",
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

  void _handleRegister() async {
    setState(() => _isLoading = true);
    bool response = await UserUtils.Register(
      _usernameController.text,
      _firstNameController.text,
      _lastNameController.text,
      _emailController.text,
      _birthDateController.text,
      _calculateAge(
        _birthDateController.text.isNotEmpty
            ? DateTime.parse(_birthDateController.text)
            : DateTime(2000, 1, 1),
      ),
      _selectedCityId!,
      _selectedSex!.index,
      _passwordController.text,
    );
    setState(() => _isLoading = false);

    if (response) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Registration Success!"),
          backgroundColor: Colors.green,
        ),
      );
    } else {
      // Shakes the card or shows error
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Invalid Credentials"),
          backgroundColor: Colors.redAccent,
        ),
      );
    }
  }
}
