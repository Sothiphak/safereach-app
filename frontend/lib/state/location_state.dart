import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:http/http.dart' as http;

class LocationState extends ChangeNotifier {
  LatLng? _currentPosition;
  bool _isLoading = false;
  String? _errorMessage;
  String _currentAddress = 'Phnom Penh, BKK1';

  // Default coordinate: BKK1, Phnom Penh
  static const LatLng defaultLocation = LatLng(11.5564, 104.9282);

  LatLng get currentPosition => _currentPosition ?? defaultLocation;
  bool get hasActualLocation => _currentPosition != null;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  String get currentAddress => _currentAddress;

  Future<void> fetchLocation() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        _errorMessage = 'Location services are disabled.';
        _isLoading = false;
        notifyListeners();
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          _errorMessage = 'Location permissions are denied.';
          _isLoading = false;
          notifyListeners();
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        _errorMessage = 'Location permissions are permanently denied.';
        _isLoading = false;
        notifyListeners();
        return;
      }

      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.medium,
        timeLimit: const Duration(seconds: 5),
      );

      _currentPosition = LatLng(position.latitude, position.longitude);
      _errorMessage = null;

      // Reverse geocoding using Nominatim
      try {
        final url = Uri.parse(
          'https://nominatim.openstreetmap.org/reverse?format=jsonv2&lat=${position.latitude}&lon=${position.longitude}',
        );
        final response = await http.get(
          url,
          headers: {'User-Agent': 'SafeReachEmergencyApp/1.0'},
        );
        if (response.statusCode == 200) {
          final data = json.decode(response.body) as Map<String, dynamic>;
          final address = data['address'] as Map<String, dynamic>?;
          if (address != null) {
            final city = address['city'] ?? address['town'] ?? address['village'] ?? address['county'] ?? address['state'] ?? '';
            final suburb = address['suburb'] ?? address['neighbourhood'] ?? address['road'] ?? address['quarter'] ?? '';
            if (city.isNotEmpty && suburb.isNotEmpty) {
              _currentAddress = '$city, $suburb';
            } else if (data['display_name'] != null) {
              final parts = (data['display_name'] as String).split(',');
              if (parts.length > 2) {
                _currentAddress = '${parts[0].trim()}, ${parts[1].trim()}';
              } else {
                _currentAddress = data['display_name'] as String;
              }
            }
          }
        }
      } catch (_) {
        _currentAddress = '${position.latitude.toStringAsFixed(4)}° N, ${position.longitude.toStringAsFixed(4)}° E';
      }
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
