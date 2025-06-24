import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:llajar/src/models/car_model.dart';
import 'package:llajar/src/services/api_services.dart';

class FavoritesProvider with ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final ApiService _apiService = ApiService();

  List<String> _favoriteCarIds = [];
  List<Car> _favoriteCars = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<String> get favoriteCarIds => _favoriteCarIds;
  List<Car> get favoriteCars => _favoriteCars;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> loadFavorites(String userId) async {
    try {
      _setLoading(true);
      _clearError();

      // Load favorite car IDs from user document
      final userDoc = await _firestore.collection('users').doc(userId).get();
      if (userDoc.exists) {
        final userData = userDoc.data()!;
        _favoriteCarIds = List<String>.from(userData['favoriteCarIds'] ?? []);
      }

      // Load the actual car objects
      if (_favoriteCarIds.isNotEmpty) {
        await _loadFavoriteCarDetails();
      } else {
        _favoriteCars.clear();
      }

      notifyListeners();
    } catch (e) {
      _setError('Failed to load favorites: $e');
    } finally {
      _setLoading(false);
    }
  }

  Future<void> _loadFavoriteCarDetails() async {
    try {
      _favoriteCars.clear();

      // Firestore has a limit of 10 items for 'whereIn' queries
      // So we need to batch the requests if there are more than 10 favorites
      const batchSize = 10;

      for (int i = 0; i < _favoriteCarIds.length; i += batchSize) {
        final batch = _favoriteCarIds.skip(i).take(batchSize).toList();

        final querySnapshot = await _firestore
            .collection('cars')
            .where(FieldPath.documentId, whereIn: batch)
            .get();

        final batchCars = querySnapshot.docs
            .map((doc) => Car.fromJson({'id': doc.id, ...doc.data()}))
            .toList();

        _favoriteCars.addAll(batchCars);
      }
    } catch (e) {
      _setError('Failed to load favorite car details: $e');
    }
  }

  bool isFavorite(String carId) {
    return _favoriteCarIds.contains(carId);
  }

  Future<bool> toggleFavorite(String userId, String carId) async {
    try {
      final isFav = isFavorite(carId);

      if (isFav) {
        return await removeFavorite(userId, carId);
      } else {
        return await addFavorite(userId, carId);
      }
    } catch (e) {
      _setError('Failed to toggle favorite: $e');
      return false;
    }
  }

  Future<bool> addFavorite(String userId, String carId) async {
    try {
      _setLoading(true);
      _clearError();

      if (_favoriteCarIds.contains(carId)) {
        return true; // Already a favorite
      }

      _favoriteCarIds.add(carId);

      await _firestore.collection('users').doc(userId).update({
        'favoriteCarIds': _favoriteCarIds,
        'updatedAt': DateTime.now().toIso8601String(),
      });

      // Load the car details and add to favorites list
      final carDoc = await _firestore.collection('cars').doc(carId).get();
      if (carDoc.exists) {
        final car = Car.fromJson({'id': carDoc.id, ...carDoc.data()!});
        _favoriteCars.add(car);
      }

      notifyListeners();
      return true;
    } catch (e) {
      // Revert the local change
      _favoriteCarIds.remove(carId);
      _setError('Failed to add favorite: $e');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> removeFavorite(String userId, String carId) async {
    try {
      _setLoading(true);
      _clearError();

      _favoriteCarIds.remove(carId);

      await _firestore.collection('users').doc(userId).update({
        'favoriteCarIds': _favoriteCarIds,
        'updatedAt': DateTime.now().toIso8601String(),
      });

      _favoriteCars.removeWhere((car) => car.id == carId);

      notifyListeners();
      return true;
    } catch (e) {
      // Revert the local change
      _favoriteCarIds.add(carId);
      _setError('Failed to remove favorite: $e');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> clearAllFavorites(String userId) async {
    try {
      _setLoading(true);
      _clearError();

      final oldFavorites = List<String>.from(_favoriteCarIds);
      _favoriteCarIds.clear();
      _favoriteCars.clear();

      await _firestore.collection('users').doc(userId).update({
        'favoriteCarIds': [],
        'updatedAt': DateTime.now().toIso8601String(),
      });

      notifyListeners();
      return true;
    } catch (e) {
      // Revert the local changes
      await loadFavorites(userId);
      _setError('Failed to clear favorites: $e');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Car? getFavoriteCarById(String carId) {
    try {
      return _favoriteCars.firstWhere((car) => car.id == carId);
    } catch (e) {
      return null;
    }
  }

  List<Car> getFavoritesByType(CarType carType) {
    return _favoriteCars.where((car) => car.carType == carType).toList();
  }

  List<Car> getFavoritesByPriceRange(double minPrice, double maxPrice) {
    return _favoriteCars
        .where(
          (car) => car.pricePerDay >= minPrice && car.pricePerDay <= maxPrice,
        )
        .toList();
  }

  List<Car> getFavoritesByLocation(String city) {
    return _favoriteCars
        .where((car) => car.city.toLowerCase() == city.toLowerCase())
        .toList();
  }

  List<Car> getAvailableFavorites() {
    return _favoriteCars.where((car) => car.isAvailable).toList();
  }

  void sortFavoritesByPrice({bool ascending = true}) {
    _favoriteCars.sort((a, b) {
      if (ascending) {
        return a.pricePerDay.compareTo(b.pricePerDay);
      } else {
        return b.pricePerDay.compareTo(a.pricePerDay);
      }
    });
    notifyListeners();
  }

  void sortFavoritesByRating({bool ascending = false}) {
    _favoriteCars.sort((a, b) {
      if (ascending) {
        return a.rating.compareTo(b.rating);
      } else {
        return b.rating.compareTo(a.rating);
      }
    });
    notifyListeners();
  }

  void sortFavoritesByDate({bool newest = true}) {
    _favoriteCars.sort((a, b) {
      if (newest) {
        return b.createdAt.compareTo(a.createdAt);
      } else {
        return a.createdAt.compareTo(b.createdAt);
      }
    });
    notifyListeners();
  }

  // Refresh a specific favorite car (useful when car details are updated)
  Future<void> refreshFavoriteCar(String carId) async {
    try {
      final carDoc = await _firestore.collection('cars').doc(carId).get();
      if (carDoc.exists) {
        final updatedCar = Car.fromJson({'id': carDoc.id, ...carDoc.data()!});
        final index = _favoriteCars.indexWhere((car) => car.id == carId);
        if (index != -1) {
          _favoriteCars[index] = updatedCar;
          notifyListeners();
        }
      }
    } catch (e) {
      _setError('Failed to refresh favorite car: $e');
    }
  }

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setError(String message) {
    _errorMessage = message;
    notifyListeners();
  }

  void _clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
