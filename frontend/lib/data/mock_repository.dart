import 'dart:convert';

import 'package:flutter/services.dart';

import '../models/emergency_branch.dart';
import '../models/emergency_service.dart';
import '../models/first_aid_tip.dart';
import '../models/review.dart';
import '../models/service_type.dart';

class MockRepository {
  List<EmergencyService>? _services;
  List<EmergencyBranch>? _branches;
  List<Review>? _reviews;
  List<FirstAidTip>? _tips;

  Future<void> preload() async {
    await Future.wait([
      getServices(),
      getBranches(),
      getReviews(),
      getTips(),
    ]);
  }

  Future<List<EmergencyService>> getServices() async {
    if (_services != null) {
      return _services!;
    }
    final data = await rootBundle.loadString('assets/mock/items.json');
    final decoded = jsonDecode(data) as List<dynamic>;
    _services = decoded
        .map((item) => EmergencyService.fromJson(item as Map<String, dynamic>))
        .toList();
    return _services!;
  }

  Future<List<EmergencyService>> getServicesByType(ServiceType type) async {
    final services = await getServices();
    return services.where((service) => service.type == type).toList();
  }

  Future<EmergencyService?> getServiceById(String id) async {
    final services = await getServices();
    try {
      return services.firstWhere((service) => service.id == id);
    } catch (_) {
      return null;
    }
  }

  Future<List<EmergencyBranch>> getBranches() async {
    if (_branches != null) {
      return _branches!;
    }
    final data = await rootBundle.loadString('assets/mock/branches.json');
    final decoded = jsonDecode(data) as List<dynamic>;
    _branches = decoded
        .map((item) => EmergencyBranch.fromJson(item as Map<String, dynamic>))
        .toList();
    return _branches!;
  }

  Future<List<Review>> getReviews() async {
    if (_reviews != null) {
      return _reviews!;
    }
    final data = await rootBundle.loadString('assets/mock/reviews.json');
    final decoded = jsonDecode(data) as List<dynamic>;
    _reviews = decoded
        .map((item) => Review.fromJson(item as Map<String, dynamic>))
        .toList();
    return _reviews!;
  }

  Future<List<Review>> getReviewsForService(String serviceId) async {
    final reviews = await getReviews();
    return reviews.where((review) => review.serviceId == serviceId).toList();
  }

  Future<List<FirstAidTip>> getTips() async {
    if (_tips != null) {
      return _tips!;
    }
    final data = await rootBundle.loadString('assets/mock/tips.json');
    final decoded = jsonDecode(data) as List<dynamic>;
    _tips = decoded
        .map((item) => FirstAidTip.fromJson(item as Map<String, dynamic>))
        .toList();
    return _tips!;
  }
}
