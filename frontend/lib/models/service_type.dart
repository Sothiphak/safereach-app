import 'package:flutter/material.dart';

enum ServiceType {
  police('Police', Icons.local_police, Color(0xFF007AFF)), // Modern System Blue
  hospital(
    'Hospital',
    Icons.local_hospital,
    Color(0xFFFF3B30),
  ), // Vibrant Vermilion
  fire('Fire', Icons.local_fire_department, Color(0xFFFF9500)), // Alert Orange
  ambulance(
    'Ambulance',
    Icons.airport_shuttle,
    Color(0xFF8E44AD),
  ), // Vibrant Purple
  women('Women Help', Icons.woman, Color(0xFFFF2D55)), // System Pink
  disaster(
    'Disaster Relief',
    Icons.crisis_alert,
    Color(0xFF64748B),
  ); // Slate Gray

  const ServiceType(this.label, this.icon, this.color);

  final String label;
  final IconData icon;
  final Color color;

  static ServiceType fromJson(String value) {
    return ServiceType.values.firstWhere(
      (type) => type.name == value,
      orElse: () => ServiceType.hospital,
    );
  }
}
