import 'service_type.dart';

class EmergencyService {
  const EmergencyService({
    required this.id,
    required this.name,
    required this.type,
    required this.phone,
    required this.address,
    required this.hours,
    required this.services,
    required this.rating,
    required this.reviewCount,
    required this.distanceKm,
    required this.openNow,
    required this.latitude,
    required this.longitude,
    required this.imageUrl,
    required this.description,
  });

  final String id;
  final String name;
  final ServiceType type;
  final String phone;
  final String address;
  final String hours;
  final List<String> services;
  final double rating;
  final int reviewCount;
  final double distanceKm;
  final bool openNow;
  final double latitude;
  final double longitude;
  final String imageUrl;
  final String description;

  factory EmergencyService.fromJson(Map<String, dynamic> json) {
    return EmergencyService(
      id: json['id'] as String,
      name: json['name'] as String,
      type: ServiceType.fromJson(json['type'] as String),
      phone: json['phone'] as String,
      address: json['address'] as String,
      hours: json['hours'] as String,
      services: (json['services'] as List<dynamic>).cast<String>(),
      rating: (json['rating'] as num).toDouble(),
      reviewCount: (json['reviewCount'] as num).toInt(),
      distanceKm: (json['distanceKm'] as num).toDouble(),
      openNow: json['openNow'] as bool,
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      imageUrl: json['imageUrl'] as String,
      description: json['description'] as String,
    );
  }

  EmergencyService copyWith({
    String? id,
    String? name,
    ServiceType? type,
    String? phone,
    String? address,
    String? hours,
    List<String>? services,
    double? rating,
    int? reviewCount,
    double? distanceKm,
    bool? openNow,
    double? latitude,
    double? longitude,
    String? imageUrl,
    String? description,
  }) {
    return EmergencyService(
      id: id ?? this.id,
      name: name ?? this.name,
      type: type ?? this.type,
      phone: phone ?? this.phone,
      address: address ?? this.address,
      hours: hours ?? this.hours,
      services: services ?? this.services,
      rating: rating ?? this.rating,
      reviewCount: reviewCount ?? this.reviewCount,
      distanceKm: distanceKm ?? this.distanceKm,
      openNow: openNow ?? this.openNow,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      imageUrl: imageUrl ?? this.imageUrl,
      description: description ?? this.description,
    );
  }
}
