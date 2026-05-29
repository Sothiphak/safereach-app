import 'package:flutter/material.dart';

enum ServiceType {
  police('Police', Icons.local_police, Color(0xFF1976D2)),
  hospital('Hospital', Icons.local_hospital, Color(0xFFD32F2F)),
  fire('Fire', Icons.local_fire_department, Color(0xFFFF6F00)),
  ambulance('Ambulance', Icons.emergency, Color(0xFF6A1B9A)),
  women('Women Help', Icons.woman, Color(0xFF00897B)),
  disaster('Disaster Relief', Icons.crisis_alert, Color(0xFF455A64));

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
