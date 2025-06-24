import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:llajar/src/models/car_model.dart';
import 'package:llajar/src/services/api_services.dart';
import 'package:llajar/src/models/car_model.dart';

class CarProvider with ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final ApiService _apiService = ApiService();

  List<Car> _cars = [];
  List<Car> _myCars = [];
  List<Car> _searchResults = [];
  Car? _selectedCar;
  bool _isLoading = false;
  String? _errorMessage;

  // Search filters
  String _searchLocation = '';
  DateTime? _startDate;
  DateTime? _endDate;
  CarType? _carTypeFilter;
  double _minPrice = 0;
  double _maxPrice = 1000;
  String _sortBy = 'price'; // price, rating, distance

  List<Car> get cars => _cars;
  List<Car> get myCars => _myCars;
  List<Car> get searchResults => _searchResults;
  Car? get selectedCar => _selectedCar;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  String get searchLocation => _searchLocation;
  DateTime? get startDate => _startDate;
  DateTime? get endDate => _endDate;
  CarType? get carTypeFilter => _carTypeFilter;
  double get minPrice => _minPrice;
  double get maxPrice => _maxPrice;
  String get sortBy => _sortBy;

  Future<void> loadCars() async {
    try {
      _setLoading(true);
      _clearError();

      final querySnapshot = await _firestore
          .collection('cars')
          .where('isAvailable', isEqualTo: true)
          .get();

      _cars = querySnapshot.docs
          .map((doc) => Car.fromJson({'id': doc.id, ...doc.data()}))
          .toList();

      notifyListeners();
    } catch (e) {
      _setError('Failed to load cars: $e');
    } finally {
      _setLoading(false);
    }
  }

  Future<void> loadMyCars(String hostId) async {
    try {
      _setLoading(true);
      _clearError();

      final querySnapshot = await _firestore
          .collection('cars')
          .where('hostId', isEqualTo: hostId)
          .get();

      _myCars = querySnapshot.docs
          .map((doc) => Car.fromJson({'id': doc.id, ...doc.data()}))
          .toList();

      notifyListeners();
    } catch (e) {
      _setError('Failed to load your cars: $e');
    } finally {
      _setLoading(false);
    }
  }

  Future<void> searchCars({
    String? location,
    DateTime? startDate,
    DateTime? endDate,
    CarType? carType,
    double? minPrice,
    double? maxPrice,
  }) async {
    try {
      _setLoading(true);
      _clearError();

      // Update search criteria
      _searchLocation = location ?? _searchLocation;
      _startDate = startDate ?? _startDate;
      _endDate = endDate ?? _endDate;
      _carTypeFilter = carType ?? _carTypeFilter;
      _minPrice = minPrice ?? _minPrice;
      _maxPrice = maxPrice ?? _maxPrice;

      Query query = _firestore
          .collection('cars')
          .where('isAvailable', isEqualTo: true);

      // Apply filters
      if (_searchLocation.isNotEmpty) {
        query = query.where('city', isEqualTo: _searchLocation);
      }

      if (_carTypeFilter != null) {
        query = query.where(
          'carType',
          isEqualTo: _carTypeFilter.toString().split('.').last,
        );
      }

      if (_minPrice > 0) {
        query = query.where('pricePerDay', isGreaterThanOrEqualTo: _minPrice);
      }

      if (_maxPrice < 1000) {
        query = query.where('pricePerDay', isLessThanOrEqualTo: _maxPrice);
      }

      final querySnapshot = await query.get();

      //    _searchResults = querySnapshot.docs
      // .map(
      //   (doc) => Car.fromJson({
      //     'id': doc.id,
      //     // Use null-aware spread here:
      //     ...?doc.data(),
      //   }),
      // )
      // .toList();

      // Filter by date availability if dates are provided
      if (_startDate != null && _endDate != null) {
        _searchResults = _searchResults
            .where((car) => car.isAvailableForDates(_startDate!, _endDate!))
            .toList();
      }

      // Sort results
      _sortSearchResults();

      notifyListeners();
    } catch (e) {
      _setError('Failed to search cars: $e');
    } finally {
      _setLoading(false);
    }
  }

  void _sortSearchResults() {
    switch (_sortBy) {
      case 'price':
        _searchResults.sort((a, b) => a.pricePerDay.compareTo(b.pricePerDay));
        break;
      case 'rating':
        _searchResults.sort((a, b) => b.rating.compareTo(a.rating));
        break;
      case 'distance':
        // This would require user location and distance calculation
        // For now, just sort by created date
        _searchResults.sort((a, b) => b.createdAt.compareTo(a.createdAt));
        break;
    }
  }

  void setSortBy(String sortBy) {
    _sortBy = sortBy;
    _sortSearchResults();
    notifyListeners();
  }

  void clearSearch() {
    _searchResults.clear();
    _searchLocation = '';
    _startDate = null;
    _endDate = null;
    _carTypeFilter = null;
    _minPrice = 0;
    _maxPrice = 1000;
    notifyListeners();
  }

  Future<Car?> getCarById(String carId) async {
    try {
      final docSnapshot = await _firestore.collection('cars').doc(carId).get();

      if (docSnapshot.exists) {
        return Car.fromJson({'id': docSnapshot.id, ...docSnapshot.data()!});
      }
      return null;
    } catch (e) {
      _setError('Failed to load car: $e');
      return null;
    }
  }

  void setSelectedCar(Car? car) {
    _selectedCar = car;
    notifyListeners();
  }

  Future<bool> addCar(Car car) async {
    try {
      _setLoading(true);
      _clearError();

      final docRef = await _firestore.collection('cars').add(car.toJson());
      final newCar = car.copyWith(id: docRef.id);

      _myCars.add(newCar);
      _cars.add(newCar);

      notifyListeners();
      return true;
    } catch (e) {
      _setError('Failed to add car: $e');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> updateCar(Car car) async {
    try {
      _setLoading(true);
      _clearError();

      await _firestore.collection('cars').doc(car.id).update(car.toJson());

      // Update in local lists
      final myCarIndex = _myCars.indexWhere((c) => c.id == car.id);
      if (myCarIndex != -1) {
        _myCars[myCarIndex] = car;
      }

      final carIndex = _cars.indexWhere((c) => c.id == car.id);
      if (carIndex != -1) {
        _cars[carIndex] = car;
      }

      if (_selectedCar?.id == car.id) {
        _selectedCar = car;
      }

      notifyListeners();
      return true;
    } catch (e) {
      _setError('Failed to update car: $e');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> deleteCar(String carId) async {
    try {
      _setLoading(true);
      _clearError();

      await _firestore.collection('cars').doc(carId).delete();

      _myCars.removeWhere((car) => car.id == carId);
      _cars.removeWhere((car) => car.id == carId);
      _searchResults.removeWhere((car) => car.id == carId);

      if (_selectedCar?.id == carId) {
        _selectedCar = null;
      }

      notifyListeners();
      return true;
    } catch (e) {
      _setError('Failed to delete car: $e');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> toggleCarAvailability(String carId, bool isAvailable) async {
    try {
      await _firestore.collection('cars').doc(carId).update({
        'isAvailable': isAvailable,
        'updatedAt': DateTime.now().toIso8601String(),
      });

      // Update in local lists
      final myCarIndex = _myCars.indexWhere((c) => c.id == carId);
      if (myCarIndex != -1) {
        _myCars[myCarIndex] = _myCars[myCarIndex].copyWith(
          isAvailable: isAvailable,
          updatedAt: DateTime.now(),
        );
      }

      final carIndex = _cars.indexWhere((c) => c.id == carId);
      if (carIndex != -1) {
        _cars[carIndex] = _cars[carIndex].copyWith(
          isAvailable: isAvailable,
          updatedAt: DateTime.now(),
        );
      }

      notifyListeners();
      return true;
    } catch (e) {
      _setError('Failed to update car availability: $e');
      return false;
    }
  }

  List<Car> getPopularCars() {
    final popularCars = List<Car>.from(_cars);
    popularCars.sort((a, b) => b.totalRentals.compareTo(a.totalRentals));
    return popularCars.take(10).toList();
  }

  List<Car> getNearestCars(double latitude, double longitude) {
    // This would require distance calculation
    // For now, return cars sorted by rating
    final nearestCars = List<Car>.from(_cars);
    nearestCars.sort((a, b) => b.rating.compareTo(a.rating));
    return nearestCars.take(10).toList();
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
