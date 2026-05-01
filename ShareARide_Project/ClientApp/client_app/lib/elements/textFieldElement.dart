import 'package:flutter/material.dart';

Widget TextFieldElement({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    required Color color,
    final VoidCallback? onTap,
    bool obscureText = false,
  }) {
    return TextField(
      controller: controller,
      onTap: onTap,
      obscureText: obscureText,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: color.withOpacity(0.7)),
        prefixIcon: Icon(icon, color: color),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(color: color, width: 2),
        ),
        filled: true,
        fillColor: Colors.grey.shade50,
      ),
    );
  }