import 'dart:convert';
import 'package:flutter/foundation.dart';
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

  Future<List<T>> _loadAssetList<T>(
    String path,
    T Function(Map<String, dynamic> json) fromJson,
  ) async {
    final raw = await rootBundle.loadString(path);
    final decoded = jsonDecode(raw) as List<dynamic>;
    return decoded
        .map((item) => fromJson(item as Map<String, dynamic>))
        .toList();
  }

  Future<void> preload() async {
    try {
      await Future.wait([
        getServices(),
        getBranches(),
        getReviews(),
        getTips(),
      ]);
    } catch (e) {
      debugPrint('Error preloading local mock data: $e');
    }
  }

  Future<List<EmergencyService>> getServices() async {
    _services ??= await _loadAssetList(
      'assets/mock/items.json',
      EmergencyService.fromJson,
    );
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
    _branches ??= await _loadAssetList(
      'assets/mock/branches.json',
      EmergencyBranch.fromJson,
    );
    return _branches!;
  }

  Future<List<Review>> getReviews() async {
    _reviews ??= await _loadAssetList(
      'assets/mock/reviews.json',
      Review.fromJson,
    );
    return _reviews!;
  }

  Future<List<Review>> getReviewsForService(String serviceId) async {
    final reviews = await getReviews();
    return reviews.where((review) => review.serviceId == serviceId).toList();
  }

  Future<void> addReview(Review review) async {
    final list = await getReviews();
    list.insert(0, review);
  }

  Future<List<FirstAidTip>> getTips() async {
    _tips ??= await _loadAssetList(
      'assets/mock/tips.json',
      FirstAidTip.fromJson,
    );
    return _tips!;
  }
}
