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
  final TextEditingController _passwordController = TextEditingController();
  bool _isConnected = false;
   bool _isLoading = false;

   void _verifyConnection() async {
    bool status = await Userutils.checkConnection();
    setState(() {
      _isConnected = status;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _verifyConnection();
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
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white70,
                  ),
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
                        horizontal: 20, vertical: 32),
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
                          controller: _usernameController,
                          label: "Email",
                          icon: Icons.person_outline,
                          color: themeColor,
                        ),
                        const SizedBox(height: 32),
                        TextFieldElement(
                          controller: _usernameController,
                          label: "First Name",
                          icon: Icons.person_outline,
                          color: themeColor,
                        ),
                        const SizedBox(height: 16),
                        TextFieldElement(
                          controller: _usernameController,
                          label: "Last Name",
                          icon: Icons.person_outline,
                          color: themeColor,
                        ),
                        const SizedBox(height: 16),
                        TextFieldElement(
                          controller: _passwordController,
                          label: "Age",
                          icon: Icons.lock_outline,
                          color: themeColor,
                          obscureText: true,
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
                          controller: _passwordController,
                          label: "Confirm Password",
                          icon: Icons.lock_outline,
                          color: themeColor,
                          obscureText: true,
                        ),
                        
                        const SizedBox(height: 16),
                        
                        // 5. Main Action Button (Login)
                        MainButtonElement(
                          onPressed: _handleRegister,
                          isLoading: _isLoading,
                          text: "REGISTER",
                          color: themeColor,
                        ),
                        const SizedBox(height: 16),

                        // 6. Secondary Action (Register)
                        TextButton(
                          onPressed: _isLoading ? null : () {
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
                                      fontWeight: FontWeight.bold),
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
    bool response = await Userutils.Login(
      _usernameController.text,
      _passwordController.text,
    );
    setState(() => _isLoading = false);

    if (response) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Login Success!"),
          backgroundColor: Colors.green,
        ),
      );

      // setState(() {
      //     _usernameController.clear();
      //     _passwordController.clear();
      // });
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