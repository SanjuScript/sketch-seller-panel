import 'package:flutter/material.dart';

class PremiumTextField extends StatelessWidget {
  final String labelText;
  final TextEditingController controller;
  final TextInputType keyboardType;
  final String? Function(String?)? validator;
  final bool isOptional;
  final IconData icon;

  const PremiumTextField({
    super.key,
    required this.labelText,
    required this.controller,
    this.keyboardType = TextInputType.text,
    this.validator,
    required this.icon,
    this.isOptional = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric( vertical: 5),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.teal.withOpacity(0.1),
            blurRadius: 10,
            spreadRadius: 2,
            offset: const Offset(0, 4),
          ),
        ],
        borderRadius: BorderRadius.circular(15),
      ),
      child: Center(
        child: TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          validator: validator ??
              (value) {
                if (!isOptional && (value == null || value.isEmpty)) {
                  return 'Please enter $labelText';
                }
                return null;
              },
          decoration: InputDecoration(
            prefixIcon: Icon(icon),
            hintText: labelText,
            hintStyle:  TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: Colors.teal.shade300,
            ),
          
            border: InputBorder.none,
            contentPadding: EdgeInsets.only(top: 10)
          ),
          cursorOpacityAnimates: true,
          style: const TextStyle(
            fontSize: 16,
            color: Colors.black87,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}

