import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:firebase_storage/firebase_storage.dart';

class ApiService {
  static const String _baseUrl =
      'https://api.llajar.com'; // Replace with your API base URL
  static const Duration _timeoutDuration = Duration(seconds: 30);

  // Singleton pattern
  static final ApiService _instance = ApiService._internal();
  factory ApiService() => _instance;
  ApiService._internal();

  final FirebaseStorage _storage = FirebaseStorage.instance;

  // Generic HTTP request method
  Future<Map<String, dynamic>?> _makeRequest(
    String method,
    String endpoint, {
    Map<String, dynamic>? body,
    Map<String, String>? headers,
    Map<String, String>? queryParams,
  }) async {
    try {
      final uri = Uri.parse(
        '$_baseUrl$endpoint',
      ).replace(queryParameters: queryParams);

      final defaultHeaders = {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      };

      if (headers != null) {
        defaultHeaders.addAll(headers);
      }

      http.Response response;

      switch (method.toUpperCase()) {
        case 'GET':
          response = await http
              .get(uri, headers: defaultHeaders)
              .timeout(_timeoutDuration);
          break;
        case 'POST':
          response = await http
              .post(
                uri,
                headers: defaultHeaders,
                body: body != null ? json.encode(body) : null,
              )
              .timeout(_timeoutDuration);
          break;
        case 'PUT':
          response = await http
              .put(
                uri,
                headers: defaultHeaders,
                body: body != null ? json.encode(body) : null,
              )
              .timeout(_timeoutDuration);
          break;
        case 'DELETE':
          response = await http
              .delete(uri, headers: defaultHeaders)
              .timeout(_timeoutDuration);
          break;
        default:
          throw Exception('Unsupported HTTP method: $method');
      }

      if (response.statusCode >= 200 && response.statusCode < 300) {
        if (response.body.isNotEmpty) {
          return json.decode(response.body) as Map<String, dynamic>;
        }
        return {'success': true};
      } else {
        throw ApiException(
          'HTTP ${response.statusCode}: ${response.reasonPhrase}',
          statusCode: response.statusCode,
        );
      }
    } catch (e) {
      if (e is ApiException) {
        rethrow;
      }
      throw ApiException('Network error: $e');
    }
  }

  // Upload file to Firebase Storage
  Future<String?> uploadFile(File file, String path) async {
    try {
      final ref = _storage.ref().child(path);
      final uploadTask = ref.putFile(file);

      final snapshot = await uploadTask;
      final downloadUrl = await snapshot.ref.getDownloadURL();

      return downloadUrl;
    } catch (e) {
      throw ApiException('File upload failed: $e');
    }
  }

  // Upload multiple files
  Future<List<String>> uploadMultipleFiles(
    List<File> files,
    String basePath,
  ) async {
    try {
      final List<String> urls = [];

      for (int i = 0; i < files.length; i++) {
        final file = files[i];
        final fileName =
            '${DateTime.now().millisecondsSinceEpoch}_$i.${file.path.split('.').last}';
        final path = '$basePath/$fileName';

        final url = await uploadFile(file, path);
        if (url != null) {
          urls.add(url);
        }
      }

      return urls;
    } catch (e) {
      throw ApiException('Multiple file upload failed: $e');
    }
  }

  // Delete file from Firebase Storage
  Future<bool> deleteFile(String url) async {
    try {
      final ref = _storage.refFromURL(url);
      await ref.delete();
      return true;
    } catch (e) {
      return false; // File might not exist or other error
    }
  }

  // Get geocoding data (convert address to coordinates)
  Future<Map<String, double>?> getCoordinatesFromAddress(String address) async {
    try {
      // This would typically use Google Maps Geocoding API or similar
      // For now, returning mock data
      // You should implement this with your preferred geocoding service

      final response = await _makeRequest(
        'GET',
        '/geocoding',
        queryParams: {'address': address},
      );

      if (response != null &&
          response['latitude'] != null &&
          response['longitude'] != null) {
        return {
          'latitude': (response['latitude'] as num).toDouble(),
          'longitude': (response['longitude'] as num).toDouble(),
        };
      }

      return null;
    } catch (e) {
      return null; // Return null if geocoding fails
    }
  }

  // Calculate distance between two points
  Future<double?> calculateDistance(
    double lat1,
    double lon1,
    double lat2,
    double lon2,
  ) async {
    try {
      final response = await _makeRequest(
        'GET',
        '/distance',
        queryParams: {
          'lat1': lat1.toString(),
          'lon1': lon1.toString(),
          'lat2': lat2.toString(),
          'lon2': lon2.toString(),
        },
      );

      if (response != null && response['distance'] != null) {
        return (response['distance'] as num).toDouble();
      }

      return null;
    } catch (e) {
      return null;
    }
  }

  // Send notification (push notification service)
  Future<bool> sendNotification({
    required String userId,
    required String title,
    required String message,
    Map<String, dynamic>? data,
  }) async {
    try {
      final response = await _makeRequest(
        'POST',
        '/notifications/send',
        body: {
          'userId': userId,
          'title': title,
          'message': message,
          'data': data,
        },
      );

      return response != null && response['success'] == true;
    } catch (e) {
      return false;
    }
  }

  // Process payment
  Future<Map<String, dynamic>?> processPayment({
    required double amount,
    required String currency,
    required String paymentMethodId,
    required String bookingId,
    Map<String, dynamic>? metadata,
  }) async {
    try {
      final response = await _makeRequest(
        'POST',
        '/payments/process',
        body: {
          'amount': amount,
          'currency': currency,
          'paymentMethodId': paymentMethodId,
          'bookingId': bookingId,
          'metadata': metadata,
        },
      );

      return response;
    } catch (e) {
      throw ApiException('Payment processing failed: $e');
    }
  }

  // Get payment intent
  Future<Map<String, dynamic>?> createPaymentIntent({
    required double amount,
    required String currency,
    required String bookingId,
    Map<String, dynamic>? metadata,
  }) async {
    try {
      final response = await _makeRequest(
        'POST',
        '/payments/create-intent',
        body: {
          'amount': amount,
          'currency': currency,
          'bookingId': bookingId,
          'metadata': metadata,
        },
      );

      return response;
    } catch (e) {
      throw ApiException('Payment intent creation failed: $e');
    }
  }

  // Send email
  Future<bool> sendEmail({
    required String to,
    required String subject,
    required String body,
    String? templateId,
    Map<String, dynamic>? templateData,
  }) async {
    try {
      final response = await _makeRequest(
        'POST',
        '/email/send',
        body: {
          'to': to,
          'subject': subject,
          'body': body,
          'templateId': templateId,
          'templateData': templateData,
        },
      );

      return response != null && response['success'] == true;
    } catch (e) {
      return false;
    }
  }

  // Get weather data for location
  Future<Map<String, dynamic>?> getWeatherData(
    double latitude,
    double longitude,
  ) async {
    try {
      final response = await _makeRequest(
        'GET',
        '/weather',
        queryParams: {'lat': latitude.toString(), 'lon': longitude.toString()},
      );

      return response;
    } catch (e) {
      return null;
    }
  }

  // Search nearby places
  Future<List<Map<String, dynamic>>?> searchNearbyPlaces({
    required double latitude,
    required double longitude,
    required String type, // restaurant, gas_station, etc.
    int radius = 5000, // meters
  }) async {
    try {
      final response = await _makeRequest(
        'GET',
        '/places/nearby',
        queryParams: {
          'lat': latitude.toString(),
          'lon': longitude.toString(),
          'type': type,
          'radius': radius.toString(),
        },
      );

      if (response != null && response['places'] != null) {
        return List<Map<String, dynamic>>.from(response['places']);
      }

      return null;
    } catch (e) {
      return null;
    }
  }

  // Analytics tracking
  Future<void> trackEvent({
    required String eventName,
    required String userId,
    Map<String, dynamic>? parameters,
  }) async {
    try {
      await _makeRequest(
        'POST',
        '/analytics/track',
        body: {
          'eventName': eventName,
          'userId': userId,
          'parameters': parameters,
          'timestamp': DateTime.now().toIso8601String(),
        },
      );
    } catch (e) {
      // Silently fail for analytics
    }
  }

  // Health check
  Future<bool> healthCheck() async {
    try {
      final response = await _makeRequest('GET', '/health');
      return response != null && response['status'] == 'ok';
    } catch (e) {
      return false;
    }
  }
}

class ApiException implements Exception {
  final String message;
  final int? statusCode;

  ApiException(this.message, {this.statusCode});

  @override
  String toString() {
    return 'ApiException: $message${statusCode != null ? ' (Status: $statusCode)' : ''}';
  }
}
