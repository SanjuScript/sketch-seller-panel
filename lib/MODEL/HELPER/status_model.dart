import 'package:flutter/material.dart';

class StatusModel {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;

  StatusModel({
    required this.title,
    this.color = Colors.deepPurple,
    required this.subtitle,
    required this.icon,
  });
}
