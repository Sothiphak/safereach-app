import 'service_type.dart';

class EmergencyBranch {
  const EmergencyBranch({
    required this.id,
    required this.name,
    required this.type,
    required this.phone,
    required this.address,
    required this.latitude,
    required this.longitude,
  });

  final String id;
  final String name;
  final ServiceType type;
  final String phone;
  final String address;
  final double latitude;
  final double longitude;

  factory EmergencyBranch.fromJson(Map<String, dynamic> json) {
    return EmergencyBranch(
      id: json['id'] as String,
      name: json['name'] as String,
      type: ServiceType.fromJson(json['type'] as String),
      phone: json['phone'] as String,
      address: json['address'] as String,
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
    );
  }
}
