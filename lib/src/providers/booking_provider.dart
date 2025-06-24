import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:llajar/src/models/booking_model.dart';
import 'package:llajar/src/services/api_services.dart';

class BookingProvider with ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final ApiService _apiService = ApiService();

  List<Booking> _bookings = [];
  List<Booking> _myBookings = [];
  List<Booking> _hostBookings = [];
  Booking? _selectedBooking;
  bool _isLoading = false;
  String? _errorMessage;

  List<Booking> get bookings => _bookings;
  List<Booking> get myBookings => _myBookings;
  List<Booking> get hostBookings => _hostBookings;
  Booking? get selectedBooking => _selectedBooking;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> loadMyBookings(String userId) async {
    try {
      _setLoading(true);
      _clearError();

      final querySnapshot = await _firestore
          .collection('bookings')
          .where('renterId', isEqualTo: userId)
          .orderBy('createdAt', descending: true)
          .get();

      _myBookings = querySnapshot.docs
          .map((doc) => Booking.fromJson({'id': doc.id, ...doc.data()}))
          .toList();

      notifyListeners();
    } catch (e) {
      _setError('Failed to load your bookings: $e');
    } finally {
      _setLoading(false);
    }
  }

  Future<void> loadHostBookings(String hostId) async {
    try {
      _setLoading(true);
      _clearError();

      final querySnapshot = await _firestore
          .collection('bookings')
          .where('hostId', isEqualTo: hostId)
          .orderBy('createdAt', descending: true)
          .get();

      _hostBookings = querySnapshot.docs
          .map((doc) => Booking.fromJson({'id': doc.id, ...doc.data()}))
          .toList();

      notifyListeners();
    } catch (e) {
      _setError('Failed to load host bookings: $e');
    } finally {
      _setLoading(false);
    }
  }

  Future<Booking?> getBookingById(String bookingId) async {
    try {
      final docSnapshot = await _firestore
          .collection('bookings')
          .doc(bookingId)
          .get();

      if (docSnapshot.exists) {
        return Booking.fromJson({'id': docSnapshot.id, ...docSnapshot.data()!});
      }
      return null;
    } catch (e) {
      _setError('Failed to load booking: $e');
      return null;
    }
  }

  void setSelectedBooking(Booking? booking) {
    _selectedBooking = booking;
    notifyListeners();
  }

  Future<bool> createBooking({
    required String renterId,
    required String hostId,
    required String carId,
    required DateTime startDate,
    required DateTime endDate,
    required double dailyRate,
    required int totalDays,
    required double totalAmount,
    String? notes,
    double? securityDeposit,
    bool isInsuranceIncluded = false,
    double? insuranceAmount,
    String? pickupLocation,
    String? dropoffLocation,
  }) async {
    try {
      _setLoading(true);
      _clearError();

      final booking = Booking(
        id: '', // Will be set by Firestore
        renterId: renterId,
        hostId: hostId,
        carId: carId,
        startDate: startDate,
        endDate: endDate,
        totalAmount: totalAmount,
        dailyRate: dailyRate,
        totalDays: totalDays,
        status: BookingStatus.pending,
        paymentStatus: PaymentStatus.pending,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        notes: notes,
        securityDeposit: securityDeposit,
        isInsuranceIncluded: isInsuranceIncluded,
        insuranceAmount: insuranceAmount,
        pickupLocation: pickupLocation,
        dropoffLocation: dropoffLocation,
      );

      final docRef = await _firestore
          .collection('bookings')
          .add(booking.toJson());
      final newBooking = booking.copyWith(id: docRef.id);

      _myBookings.insert(0, newBooking);
      _bookings.insert(0, newBooking);

      notifyListeners();
      return true;
    } catch (e) {
      _setError('Failed to create booking: $e');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> updateBookingStatus(
    String bookingId,
    BookingStatus status, {
    String? reason,
  }) async {
    try {
      _setLoading(true);
      _clearError();

      final updateData = {
        'status': status.toString().split('.').last,
        'updatedAt': DateTime.now().toIso8601String(),
      };

      if (reason != null && status == BookingStatus.cancelled) {
        updateData['cancellationReason'] = reason;
      }

      await _firestore.collection('bookings').doc(bookingId).update(updateData);

      // Update in local lists
      _updateBookingInLists(
        bookingId,
        (booking) => booking.copyWith(
          status: status,
          updatedAt: DateTime.now(),
          cancellationReason: reason,
        ),
      );

      notifyListeners();
      return true;
    } catch (e) {
      _setError('Failed to update booking status: $e');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> updatePaymentStatus(
    String bookingId,
    PaymentStatus paymentStatus, {
    String? paymentIntentId,
  }) async {
    try {
      final updateData = {
        'paymentStatus': paymentStatus.toString().split('.').last,
        'updatedAt': DateTime.now().toIso8601String(),
      };

      if (paymentIntentId != null) {
        updateData['paymentIntentId'] = paymentIntentId;
      }

      await _firestore.collection('bookings').doc(bookingId).update(updateData);

      // Update in local lists
      _updateBookingInLists(
        bookingId,
        (booking) => booking.copyWith(
          paymentStatus: paymentStatus,
          paymentIntentId: paymentIntentId,
          updatedAt: DateTime.now(),
        ),
      );

      notifyListeners();
      return true;
    } catch (e) {
      _setError('Failed to update payment status: $e');
      return false;
    }
  }

  Future<bool> checkInBooking(String bookingId) async {
    try {
      await _firestore.collection('bookings').doc(bookingId).update({
        'status': BookingStatus.active.toString().split('.').last,
        'checkinTime': DateTime.now().toIso8601String(),
        'updatedAt': DateTime.now().toIso8601String(),
      });

      _updateBookingInLists(
        bookingId,
        (booking) => booking.copyWith(
          status: BookingStatus.active,
          checkinTime: DateTime.now(),
          updatedAt: DateTime.now(),
        ),
      );

      notifyListeners();
      return true;
    } catch (e) {
      _setError('Failed to check in: $e');
      return false;
    }
  }

  Future<bool> checkOutBooking(String bookingId) async {
    try {
      await _firestore.collection('bookings').doc(bookingId).update({
        'status': BookingStatus.completed.toString().split('.').last,
        'checkoutTime': DateTime.now().toIso8601String(),
        'updatedAt': DateTime.now().toIso8601String(),
      });

      _updateBookingInLists(
        bookingId,
        (booking) => booking.copyWith(
          status: BookingStatus.completed,
          checkoutTime: DateTime.now(),
          updatedAt: DateTime.now(),
        ),
      );

      notifyListeners();
      return true;
    } catch (e) {
      _setError('Failed to check out: $e');
      return false;
    }
  }

  void _updateBookingInLists(
    String bookingId,
    Booking Function(Booking) updateFunction,
  ) {
    // Update in myBookings
    final myBookingIndex = _myBookings.indexWhere((b) => b.id == bookingId);
    if (myBookingIndex != -1) {
      _myBookings[myBookingIndex] = updateFunction(_myBookings[myBookingIndex]);
    }

    // Update in hostBookings
    final hostBookingIndex = _hostBookings.indexWhere((b) => b.id == bookingId);
    if (hostBookingIndex != -1) {
      _hostBookings[hostBookingIndex] = updateFunction(
        _hostBookings[hostBookingIndex],
      );
    }

    // Update in bookings
    final bookingIndex = _bookings.indexWhere((b) => b.id == bookingId);
    if (bookingIndex != -1) {
      _bookings[bookingIndex] = updateFunction(_bookings[bookingIndex]);
    }

    // Update selected booking
    if (_selectedBooking?.id == bookingId) {
      _selectedBooking = updateFunction(_selectedBooking!);
    }
  }

  List<Booking> getUpcomingBookings(String userId) {
    return _myBookings
        .where(
          (booking) =>
              booking.status == BookingStatus.confirmed &&
              booking.startDate.isAfter(DateTime.now()),
        )
        .toList();
  }

  List<Booking> getActiveBookings(String userId) {
    return _myBookings
        .where((booking) => booking.status == BookingStatus.active)
        .toList();
  }

  List<Booking> getPastBookings(String userId) {
    return _myBookings
        .where((booking) => booking.status == BookingStatus.completed)
        .toList();
  }

  List<Booking> getPendingHostBookings(String hostId) {
    return _hostBookings
        .where((booking) => booking.status == BookingStatus.pending)
        .toList();
  }

  double calculateTotalAmount(
    double dailyRate,
    int totalDays, {
    bool includeInsurance = false,
    double insuranceRate = 15.0,
    double? securityDeposit,
  }) {
    double total = dailyRate * totalDays;

    if (includeInsurance) {
      total += insuranceRate * totalDays;
    }

    if (securityDeposit != null) {
      total += securityDeposit;
    }

    return total;
  }

  bool isCarAvailableForDates(
    List<Booking> existingBookings,
    DateTime startDate,
    DateTime endDate,
  ) {
    for (final booking in existingBookings) {
      if (booking.status != BookingStatus.cancelled &&
          booking.status != BookingStatus.rejected) {
        // Check for date overlap
        if (startDate.isBefore(booking.endDate) &&
            endDate.isAfter(booking.startDate)) {
          return false;
        }
      }
    }
    return true;
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
