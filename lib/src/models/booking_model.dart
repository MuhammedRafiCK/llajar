enum BookingStatus {
  pending,
  confirmed,
  active,
  completed,
  cancelled,
  rejected,
}

enum PaymentStatus { pending, paid, failed, refunded, partialRefund }

class Booking {
  final String id;
  final String renterId;
  final String hostId;
  final String carId;
  final DateTime startDate;
  final DateTime endDate;
  final double totalAmount;
  final double dailyRate;
  final int totalDays;
  final BookingStatus status;
  final PaymentStatus paymentStatus;
  final String? paymentIntentId;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String? notes;
  final String? cancellationReason;
  final DateTime? checkinTime;
  final DateTime? checkoutTime;
  final double? securityDeposit;
  final bool isInsuranceIncluded;
  final double? insuranceAmount;
  final String? pickupLocation;
  final String? dropoffLocation;
  final Map<String, dynamic>? metadata;

  Booking({
    required this.id,
    required this.renterId,
    required this.hostId,
    required this.carId,
    required this.startDate,
    required this.endDate,
    required this.totalAmount,
    required this.dailyRate,
    required this.totalDays,
    required this.status,
    required this.paymentStatus,
    this.paymentIntentId,
    required this.createdAt,
    required this.updatedAt,
    this.notes,
    this.cancellationReason,
    this.checkinTime,
    this.checkoutTime,
    this.securityDeposit,
    this.isInsuranceIncluded = false,
    this.insuranceAmount,
    this.pickupLocation,
    this.dropoffLocation,
    this.metadata,
  });

  factory Booking.fromJson(Map<String, dynamic> json) {
    return Booking(
      id: json['id'] ?? '',
      renterId: json['renterId'] ?? '',
      hostId: json['hostId'] ?? '',
      carId: json['carId'] ?? '',
      startDate: DateTime.parse(json['startDate']),
      endDate: DateTime.parse(json['endDate']),
      totalAmount: (json['totalAmount'] ?? 0.0).toDouble(),
      dailyRate: (json['dailyRate'] ?? 0.0).toDouble(),
      totalDays: json['totalDays'] ?? 0,
      status: BookingStatus.values.firstWhere(
        (e) => e.toString().split('.').last == json['status'],
        orElse: () => BookingStatus.pending,
      ),
      paymentStatus: PaymentStatus.values.firstWhere(
        (e) => e.toString().split('.').last == json['paymentStatus'],
        orElse: () => PaymentStatus.pending,
      ),
      paymentIntentId: json['paymentIntentId'],
      createdAt: DateTime.parse(
        json['createdAt'] ?? DateTime.now().toIso8601String(),
      ),
      updatedAt: DateTime.parse(
        json['updatedAt'] ?? DateTime.now().toIso8601String(),
      ),
      notes: json['notes'],
      cancellationReason: json['cancellationReason'],
      checkinTime: json['checkinTime'] != null
          ? DateTime.parse(json['checkinTime'])
          : null,
      checkoutTime: json['checkoutTime'] != null
          ? DateTime.parse(json['checkoutTime'])
          : null,
      securityDeposit: json['securityDeposit']?.toDouble(),
      isInsuranceIncluded: json['isInsuranceIncluded'] ?? false,
      insuranceAmount: json['insuranceAmount']?.toDouble(),
      pickupLocation: json['pickupLocation'],
      dropoffLocation: json['dropoffLocation'],
      metadata: json['metadata'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'renterId': renterId,
      'hostId': hostId,
      'carId': carId,
      'startDate': startDate.toIso8601String(),
      'endDate': endDate.toIso8601String(),
      'totalAmount': totalAmount,
      'dailyRate': dailyRate,
      'totalDays': totalDays,
      'status': status.toString().split('.').last,
      'paymentStatus': paymentStatus.toString().split('.').last,
      'paymentIntentId': paymentIntentId,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'notes': notes,
      'cancellationReason': cancellationReason,
      'checkinTime': checkinTime?.toIso8601String(),
      'checkoutTime': checkoutTime?.toIso8601String(),
      'securityDeposit': securityDeposit,
      'isInsuranceIncluded': isInsuranceIncluded,
      'insuranceAmount': insuranceAmount,
      'pickupLocation': pickupLocation,
      'dropoffLocation': dropoffLocation,
      'metadata': metadata,
    };
  }

  String get statusDisplay {
    switch (status) {
      case BookingStatus.pending:
        return 'Pending';
      case BookingStatus.confirmed:
        return 'Confirmed';
      case BookingStatus.active:
        return 'Active';
      case BookingStatus.completed:
        return 'Completed';
      case BookingStatus.cancelled:
        return 'Cancelled';
      case BookingStatus.rejected:
        return 'Rejected';
    }
  }

  String get paymentStatusDisplay {
    switch (paymentStatus) {
      case PaymentStatus.pending:
        return 'Payment Pending';
      case PaymentStatus.paid:
        return 'Paid';
      case PaymentStatus.failed:
        return 'Payment Failed';
      case PaymentStatus.refunded:
        return 'Refunded';
      case PaymentStatus.partialRefund:
        return 'Partially Refunded';
    }
  }

  Duration get duration => endDate.difference(startDate);

  bool get isActive => status == BookingStatus.active;
  bool get isPending => status == BookingStatus.pending;
  bool get isCompleted => status == BookingStatus.completed;
  bool get isCancelled => status == BookingStatus.cancelled;
  bool get isUpcoming =>
      status == BookingStatus.confirmed && startDate.isAfter(DateTime.now());
  bool get isPaid => paymentStatus == PaymentStatus.paid;

  double get totalAmountWithExtras {
    double total = totalAmount;
    if (isInsuranceIncluded && insuranceAmount != null) {
      total += insuranceAmount!;
    }
    if (securityDeposit != null) {
      total += securityDeposit!;
    }
    return total;
  }

  Booking copyWith({
    String? id,
    String? renterId,
    String? hostId,
    String? carId,
    DateTime? startDate,
    DateTime? endDate,
    double? totalAmount,
    double? dailyRate,
    int? totalDays,
    BookingStatus? status,
    PaymentStatus? paymentStatus,
    String? paymentIntentId,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? notes,
    String? cancellationReason,
    DateTime? checkinTime,
    DateTime? checkoutTime,
    double? securityDeposit,
    bool? isInsuranceIncluded,
    double? insuranceAmount,
    String? pickupLocation,
    String? dropoffLocation,
    Map<String, dynamic>? metadata,
  }) {
    return Booking(
      id: id ?? this.id,
      renterId: renterId ?? this.renterId,
      hostId: hostId ?? this.hostId,
      carId: carId ?? this.carId,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      totalAmount: totalAmount ?? this.totalAmount,
      dailyRate: dailyRate ?? this.dailyRate,
      totalDays: totalDays ?? this.totalDays,
      status: status ?? this.status,
      paymentStatus: paymentStatus ?? this.paymentStatus,
      paymentIntentId: paymentIntentId ?? this.paymentIntentId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      notes: notes ?? this.notes,
      cancellationReason: cancellationReason ?? this.cancellationReason,
      checkinTime: checkinTime ?? this.checkinTime,
      checkoutTime: checkoutTime ?? this.checkoutTime,
      securityDeposit: securityDeposit ?? this.securityDeposit,
      isInsuranceIncluded: isInsuranceIncluded ?? this.isInsuranceIncluded,
      insuranceAmount: insuranceAmount ?? this.insuranceAmount,
      pickupLocation: pickupLocation ?? this.pickupLocation,
      dropoffLocation: dropoffLocation ?? this.dropoffLocation,
      metadata: metadata ?? this.metadata,
    );
  }
}
