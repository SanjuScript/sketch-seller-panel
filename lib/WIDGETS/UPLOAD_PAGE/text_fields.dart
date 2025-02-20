import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomTextFields extends StatefulWidget {
  final String label;
  final TextEditingController controller;
  final TextInputType keyboardType;
  final int maxLines;
  final String hint;
  final IconData icon;
  final bool isNumberField;
  final bool isDescription;
  final String? Function(String?)? validator;

  const CustomTextFields({
    super.key,
    required this.label,
    this.isDescription = false,
    this.validator,
    required this.controller,
    this.isNumberField = false,
    this.keyboardType = TextInputType.text,
    this.maxLines = 1,
    required this.hint,
    required this.icon,
  });

  @override
  State<CustomTextFields> createState() => _CustomTextFieldsState();
}

class _CustomTextFieldsState extends State<CustomTextFields> {
  String? errorText;

  void _validateField() {
    setState(() {
      errorText = widget.validator?.call(widget.controller.text);
    });
  }

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_validateField);
  }

  @override
  void dispose() {
    widget.controller.removeListener(_validateField);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.label,
          style: Theme.of(context).textTheme.labelSmall?.copyWith(fontSize: 14),
        ),
        const SizedBox(height: 8),
        TextFormField(
          maxLength: widget.isDescription ? 400 : null,
          controller: widget.controller,
          validator: widget.validator,
          keyboardType: widget.keyboardType,
          maxLines: widget.isDescription ? null : widget.maxLines,
          inputFormatters: widget.isDescription
              ? [LengthLimitingTextInputFormatter(400)]
              : null,
          onChanged: (_) => _validateField(),
          decoration: InputDecoration(
            errorText: errorText,
            prefixIcon: Icon(widget.icon, color: Colors.deepPurple),
            hintText: widget.hint,
            hintStyle: Theme.of(context).textTheme.labelMedium?.copyWith(
                  letterSpacing: 0,
                  color: Colors.black54,
                  fontWeight: FontWeight.normal,
                ),
            contentPadding: const EdgeInsets.symmetric(vertical: 16.0),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.0),
              borderSide: const BorderSide(color: Colors.deepPurple),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.0),
              borderSide: const BorderSide(color: Colors.deepPurple),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.0),
              borderSide:
                  const BorderSide(color: Colors.deepPurple, width: 2.0),
            ),
          ),
        ),
      ],
    );
  }
}

class CustomTFieldUploadPage extends StatelessWidget {
  final void Function(String)? onChanged;
  final String? init;
  const CustomTFieldUploadPage({super.key, this.onChanged, this.init});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      initialValue: init,
      decoration: InputDecoration(
        prefixIcon: const Icon(Icons.type_specimen, color: Colors.deepPurple),
        hintText: "Enter drawing type (eg: single or double)",
        hintStyle: Theme.of(context).textTheme.labelMedium?.copyWith(
              letterSpacing: 0,
              color: Colors.black54,
              fontWeight: FontWeight.normal,
            ),
        contentPadding: const EdgeInsets.symmetric(vertical: 16.0),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: const BorderSide(color: Colors.deepPurple),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: const BorderSide(color: Colors.deepPurple),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: const BorderSide(color: Colors.deepPurple, width: 2.0),
        ),
      ),
      onChanged: onChanged,
    );
  }
}
