import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../config/api_config.dart';
import '../models/emergency_branch.dart';
import '../models/emergency_service.dart';
import '../models/first_aid_tip.dart';
import '../models/review.dart';
import '../models/service_type.dart';

class EmergencyRepository {
  static const String _apiBaseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: ApiConfig.baseUrl,
  );
  static const Duration _requestTimeout = Duration(seconds: 4);
  static const String _servicesCacheKey = 'cache_services';
  static const String _branchesCacheKey = 'cache_branches';
  static const String _reviewsCacheKey = 'cache_reviews';
  static const String _tipsCacheKey = 'cache_tips';

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

  List<T> _parseList<T>(
    String raw,
    T Function(Map<String, dynamic> json) fromJson,
  ) {
    final decoded = jsonDecode(raw) as List<dynamic>;
    return decoded
        .map((item) => fromJson(item as Map<String, dynamic>))
        .toList();
  }

  Future<String?> _readCache(String cacheKey) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(cacheKey);
  }

  Future<void> _writeCache(String cacheKey, String raw) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(cacheKey, raw);
  }

  Future<List<T>> _loadApiList<T>(
    String path,
    T Function(Map<String, dynamic> json) fromJson, {
    Map<String, String>? queryParameters,
    String? cacheKey,
  }) async {
    final uri = Uri.parse(
      '$_apiBaseUrl/$path',
    ).replace(queryParameters: queryParameters);
    final response = await http.get(uri).timeout(_requestTimeout);

    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw Exception('API $path returned ${response.statusCode}');
    }

    if (cacheKey != null) {
      await _writeCache(cacheKey, response.body);
    }

    return _parseList(response.body, fromJson);
  }

  Future<List<T>> _loadApiListWithFallback<T>({
    required String apiPath,
    required String cacheKey,
    required String assetPath,
    required T Function(Map<String, dynamic> json) fromJson,
    Map<String, String>? queryParameters,
  }) async {
    try {
      final apiItems = await _loadApiList(
        apiPath,
        fromJson,
        queryParameters: queryParameters,
        cacheKey: queryParameters == null ? cacheKey : null,
      );
      if (apiItems.isNotEmpty) {
        return apiItems;
      }
      debugPrint('API $apiPath returned no data; using fallback data.');
    } catch (error) {
      debugPrint('API $apiPath unavailable; using fallback data. $error');
    }

    final cached = await _readCache(cacheKey);
    if (cached != null) {
      try {
        return _parseList(cached, fromJson);
      } catch (error) {
        debugPrint('Cache $cacheKey could not be parsed. $error');
      }
    }

    return _loadAssetList(assetPath, fromJson);
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
      debugPrint('Error preloading emergency data: $e');
    }
  }

  Future<List<EmergencyService>> getServices() async {
    _services ??= await _loadApiListWithFallback(
      apiPath: 'services',
      cacheKey: _servicesCacheKey,
      assetPath: 'assets/mock/items.json',
      fromJson: EmergencyService.fromJson,
    );
    return _services!;
  }

  Future<List<EmergencyService>> getServicesByType(ServiceType type) async {
    try {
      final services = await _loadApiList(
        'services',
        EmergencyService.fromJson,
        queryParameters: {'type': type.name},
      );
      if (services.isNotEmpty) {
        return services;
      }
    } catch (error) {
      debugPrint('API services?type=${type.name} unavailable. $error');
    }

    final services = await getServices();
    return services.where((service) => service.type == type).toList();
  }

  Future<EmergencyService?> getServiceById(String id) async {
    try {
      final uri = Uri.parse('$_apiBaseUrl/services/$id');
      final response = await http.get(uri).timeout(_requestTimeout);
      if (response.statusCode >= 200 && response.statusCode < 300) {
        return EmergencyService.fromJson(
          jsonDecode(response.body) as Map<String, dynamic>,
        );
      }
    } catch (error) {
      debugPrint('API services/$id unavailable. $error');
    }

    final services = await getServices();
    try {
      return services.firstWhere((service) => service.id == id);
    } catch (_) {
      return null;
    }
  }

  Future<List<EmergencyBranch>> getBranches() async {
    _branches ??= await _loadApiListWithFallback(
      apiPath: 'branches',
      cacheKey: _branchesCacheKey,
      assetPath: 'assets/mock/branches.json',
      fromJson: EmergencyBranch.fromJson,
    );
    return _branches!;
  }

  Future<List<Review>> getReviews() async {
    _reviews ??= await _loadApiListWithFallback(
      apiPath: 'reviews',
      cacheKey: _reviewsCacheKey,
      assetPath: 'assets/mock/reviews.json',
      fromJson: Review.fromJson,
    );
    return _reviews!;
  }

  Future<List<Review>> getReviewsForService(String serviceId) async {
    try {
      return await _loadApiList(
        'reviews',
        Review.fromJson,
        queryParameters: {'serviceId': serviceId},
      );
    } catch (error) {
      debugPrint('API reviews?serviceId=$serviceId unavailable. $error');
    }

    final reviews = await getReviews();
    return reviews.where((review) => review.serviceId == serviceId).toList();
  }

  Future<void> addReview(Review review) async {
    try {
      final uri = Uri.parse('$_apiBaseUrl/reviews');
      final response = await http
          .post(
            uri,
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({
              'serviceId': review.serviceId,
              'author': review.author,
              'rating': review.rating,
              'comment': review.comment,
            }),
          )
          .timeout(_requestTimeout);

      if (response.statusCode >= 200 && response.statusCode < 300) {
        final created = Review.fromJson(
          jsonDecode(response.body) as Map<String, dynamic>,
        );
        final list = await getReviews();
        list.insert(0, created);
        await _writeCache(
          _reviewsCacheKey,
          jsonEncode(list.map(_reviewToJson).toList()),
        );
        return;
      }

      debugPrint('API reviews POST returned ${response.statusCode}.');
    } catch (error) {
      debugPrint('API reviews POST unavailable; saving review locally. $error');
    }

    final list = await getReviews();
    list.insert(0, review);
    await _writeCache(
      _reviewsCacheKey,
      jsonEncode(list.map(_reviewToJson).toList()),
    );
  }

  Future<List<FirstAidTip>> getTips() async {
    _tips ??= await _loadApiListWithFallback(
      apiPath: 'tips',
      cacheKey: _tipsCacheKey,
      assetPath: 'assets/mock/tips.json',
      fromJson: FirstAidTip.fromJson,
    );
    return _tips!;
  }

  Map<String, dynamic> _reviewToJson(Review review) {
    return {
      'id': review.id,
      'serviceId': review.serviceId,
      'author': review.author,
      'rating': review.rating,
      'date': review.date,
      'comment': review.comment,
    };
  }
}
