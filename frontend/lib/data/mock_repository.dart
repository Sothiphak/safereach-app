import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../models/emergency_branch.dart';
import '../models/emergency_service.dart';
import '../models/first_aid_tip.dart';
import '../models/review.dart';
import '../models/service_type.dart';

class MockRepository {
  static const String baseUrl = 'http://localhost:3000/api';

  List<EmergencyService>? _services;
  List<EmergencyBranch>? _branches;
  List<Review>? _reviews;
  List<FirstAidTip>? _tips;

  Future<void> preload() async {
    try {
      await Future.wait([
        getServices(),
        getBranches(),
        getReviews(),
        getTips(),
      ]);
    } catch (e) {
      debugPrint('Error preloading data from backend: $e');
    }
  }

  Future<List<EmergencyService>> getServices() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/services'));
      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body) as List<dynamic>;
        _services = decoded
            .map((item) => EmergencyService.fromJson(item as Map<String, dynamic>))
            .toList();
        return _services!;
      }
    } catch (e) {
      debugPrint('Failed to load services from backend, using fallback: $e');
    }
    return _services ?? [];
  }

  Future<List<EmergencyService>> getServicesByType(ServiceType type) async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/services?type=${type.name}'));
      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body) as List<dynamic>;
        return decoded
            .map((item) => EmergencyService.fromJson(item as Map<String, dynamic>))
            .toList();
      }
    } catch (e) {
      debugPrint('Failed to load services by type from backend: $e');
    }
    final services = await getServices();
    return services.where((service) => service.type == type).toList();
  }

  Future<EmergencyService?> getServiceById(String id) async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/services/$id'));
      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body) as Map<String, dynamic>;
        return EmergencyService.fromJson(decoded);
      }
    } catch (e) {
      debugPrint('Failed to load service by ID from backend: $e');
    }
    final services = await getServices();
    try {
      return services.firstWhere((service) => service.id == id);
    } catch (_) {
      return null;
    }
  }

  Future<List<EmergencyBranch>> getBranches() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/branches'));
      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body) as List<dynamic>;
        _branches = decoded
            .map((item) => EmergencyBranch.fromJson(item as Map<String, dynamic>))
            .toList();
        return _branches!;
      }
    } catch (e) {
      debugPrint('Failed to load branches from backend: $e');
    }
    return _branches ?? [];
  }

  Future<List<Review>> getReviews() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/reviews'));
      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body) as List<dynamic>;
        _reviews = decoded
            .map((item) => Review.fromJson(item as Map<String, dynamic>))
            .toList();
        return _reviews!;
      }
    } catch (e) {
      debugPrint('Failed to load reviews from backend: $e');
    }
    return _reviews ?? [];
  }

  Future<List<Review>> getReviewsForService(String serviceId) async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/reviews?serviceId=$serviceId'));
      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body) as List<dynamic>;
        return decoded
            .map((item) => Review.fromJson(item as Map<String, dynamic>))
            .toList();
      }
    } catch (e) {
      debugPrint('Failed to load reviews for service from backend: $e');
    }
    final reviews = await getReviews();
    return reviews.where((review) => review.serviceId == serviceId).toList();
  }

  Future<void> addReview(Review review) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/reviews'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'serviceId': review.serviceId,
          'author': review.author,
          'rating': review.rating,
          'comment': review.comment,
        }),
      );
      if (response.statusCode == 201) {
        await getReviews();
        return;
      }
    } catch (e) {
      debugPrint('Failed to add review on backend: $e');
    }
    final list = await getReviews();
    list.insert(0, review);
  }

  Future<List<FirstAidTip>> getTips() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/tips'));
      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body) as List<dynamic>;
        _tips = decoded
            .map((item) => FirstAidTip.fromJson(item as Map<String, dynamic>))
            .toList();
        return _tips!;
      }
    } catch (e) {
      debugPrint('Failed to load tips from backend: $e');
    }
    return _tips ?? [];
  }
}
