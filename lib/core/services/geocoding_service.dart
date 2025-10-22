import 'dart:convert';
import 'package:http/http.dart' as http;
import '../utils/debug_logger.dart';

/// Service for geocoding and reverse geocoding operations
/// Uses Nominatim (OpenStreetMap) API for address ↔ coordinates conversion
class GeocodingService {
  static const String _baseUrl = 'https://nominatim.openstreetmap.org';

  // Rate limiting: max 1 request per second
  static DateTime? _lastRequest;
  static const Duration _minDelay = Duration(seconds: 1);

  /// Convert an address to coordinates (geocoding)
  static Future<GeocodingResult?> geocodeAddress(String address) async {
    if (address.trim().isEmpty) {
      DebugLogger.warning('Geocoding: Empty address provided');
      return null;
    }

    try {
      await _enforceRateLimit();

      final encodedAddress = Uri.encodeComponent(address.trim());
      final url =
          '$_baseUrl/search?q=$encodedAddress&format=json&limit=1&addressdetails=1';

      DebugLogger.debug('Geocoding request: $address');

      final response = await http.get(
        Uri.parse(url),
        headers: {
          'User-Agent': 'Brivida-App/1.0 (cleaning service platform)',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> results = json.decode(response.body);

        if (results.isNotEmpty) {
          final result = results.first;
          final lat = double.tryParse(result['lat']?.toString() ?? '');
          final lng = double.tryParse(result['lon']?.toString() ?? '');

          if (lat != null && lng != null) {
            String formattedAddress = result['display_name'] ?? address;

            // Try to extract a cleaner address from components
            if (result['address'] != null) {
              final addressParts = result['address'] as Map<String, dynamic>;
              formattedAddress = _formatAddress(addressParts);
            }

            DebugLogger.debug('Geocoding success: $address → ($lat, $lng)');
            return GeocodingResult(
              lat: lat,
              lng: lng,
              address: formattedAddress,
              originalQuery: address,
            );
          }
        }
      }

      DebugLogger.warning('Geocoding failed: No results for "$address"');
      return null;
    } catch (e) {
      DebugLogger.error('Geocoding error for "$address"', e);
      return null;
    }
  }

  /// Convert coordinates to an address (reverse geocoding)
  static Future<String?> reverseGeocode(double lat, double lng) async {
    try {
      await _enforceRateLimit();

      final url =
          '$_baseUrl/reverse?lat=$lat&lon=$lng&format=json&addressdetails=1';

      DebugLogger.debug('Reverse geocoding request: ($lat, $lng)');

      final response = await http.get(
        Uri.parse(url),
        headers: {
          'User-Agent': 'Brivida-App/1.0 (cleaning service platform)',
        },
      );

      if (response.statusCode == 200) {
        final result = json.decode(response.body);

        if (result['address'] != null) {
          final addressParts = result['address'] as Map<String, dynamic>;
          final formattedAddress = _formatAddress(addressParts);

          DebugLogger.debug(
              'Reverse geocoding success: ($lat, $lng) → $formattedAddress');
          return formattedAddress;
        } else if (result['display_name'] != null) {
          return result['display_name'] as String;
        }
      }

      DebugLogger.warning(
          'Reverse geocoding failed: No results for ($lat, $lng)');
      return null;
    } catch (e) {
      DebugLogger.error('Reverse geocoding error for ($lat, $lng)', e);
      return null;
    }
  }

  /// Format address components into a readable string
  static String _formatAddress(Map<String, dynamic> addressParts) {
    final List<String> parts = [];

    // Street number and name
    if (addressParts['house_number'] != null && addressParts['road'] != null) {
      parts.add('${addressParts['road']} ${addressParts['house_number']}');
    } else if (addressParts['road'] != null) {
      parts.add(addressParts['road']);
    }

    // City
    if (addressParts['city'] != null) {
      parts.add(addressParts['city']);
    } else if (addressParts['town'] != null) {
      parts.add(addressParts['town']);
    } else if (addressParts['village'] != null) {
      parts.add(addressParts['village']);
    }

    // Postal code
    if (addressParts['postcode'] != null) {
      final city = parts.isNotEmpty ? parts.last : '';
      if (city.isNotEmpty) {
        parts[parts.length - 1] = '${addressParts['postcode']} $city';
      } else {
        parts.add(addressParts['postcode']);
      }
    }

    // Country (for international addresses)
    if (addressParts['country'] != null &&
        addressParts['country'] != 'Deutschland' &&
        addressParts['country'] != 'Germany') {
      parts.add(addressParts['country']);
    }

    return parts.isNotEmpty ? parts.join(', ') : 'Unbekannte Adresse';
  }

  /// Enforce rate limiting to comply with Nominatim usage policy
  static Future<void> _enforceRateLimit() async {
    if (_lastRequest != null) {
      final timeSinceLastRequest = DateTime.now().difference(_lastRequest!);
      if (timeSinceLastRequest < _minDelay) {
        final waitTime = _minDelay - timeSinceLastRequest;
        DebugLogger.debug(
            'Rate limiting: waiting ${waitTime.inMilliseconds}ms');
        await Future.delayed(waitTime);
      }
    }
    _lastRequest = DateTime.now();
  }
}

/// Result from geocoding operation
class GeocodingResult {
  final double lat;
  final double lng;
  final String address;
  final String originalQuery;

  const GeocodingResult({
    required this.lat,
    required this.lng,
    required this.address,
    required this.originalQuery,
  });

  @override
  String toString() =>
      'GeocodingResult(lat: $lat, lng: $lng, address: $address)';
}
