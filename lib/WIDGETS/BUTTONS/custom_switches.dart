import 'package:flutter/material.dart';

class CustomSwitch extends StatelessWidget {
  final bool value;
  final ValueChanged<bool> onChanged;
  final String label;

  const CustomSwitch({
    super.key,
    required this.value,
    required this.onChanged,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      height: size.height * .06,
      width: size.width * .37,
      decoration: BoxDecoration(
        color: value ? Colors.green[300] : Colors.red[300],
        borderRadius: BorderRadius.circular(25),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 8,
            offset: Offset(2, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
          Switch.adaptive(
            value: value,
            trackOutlineColor: const WidgetStatePropertyAll(Colors.transparent),
            activeColor: Colors.white,
            inactiveThumbColor: Colors.white,
            activeTrackColor: Colors.green,
            inactiveTrackColor: Colors.red[900],
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }
}
