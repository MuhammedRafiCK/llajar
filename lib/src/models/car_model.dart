enum CarType {
  economy,
  compact,
  midsize,
  fullsize,
  suv,
  luxury,
  convertible,
  hybrid,
  electric,
}

enum TransmissionType { manual, automatic }

enum FuelType { gasoline, diesel, hybrid, electric }

class Car {
  final String id;
  final String hostId;
  final String make;
  final String model;
  final int year;
  final String color;
  final String licensePlate;
  final CarType carType;
  final TransmissionType transmission;
  final FuelType fuelType;
  final int seats;
  final int doors;
  final double pricePerDay;
  final String description;
  final List<String> images;
  final List<String> features;
  final double latitude;
  final double longitude;
  final String address;
  final String city;
  final String state;
  final String zipCode;
  final bool isAvailable;
  final double rating;
  final int totalRentals;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String? insurancePolicy;
  final int mileage;
  final DateTime? lastMaintenanceDate;
  final List<DateTime> unavailableDates;

  Car({
    required this.id,
    required this.hostId,
    required this.make,
    required this.model,
    required this.year,
    required this.color,
    required this.licensePlate,
    required this.carType,
    required this.transmission,
    required this.fuelType,
    required this.seats,
    required this.doors,
    required this.pricePerDay,
    required this.description,
    required this.images,
    required this.features,
    required this.latitude,
    required this.longitude,
    required this.address,
    required this.city,
    required this.state,
    required this.zipCode,
    this.isAvailable = true,
    this.rating = 0.0,
    this.totalRentals = 0,
    required this.createdAt,
    required this.updatedAt,
    this.insurancePolicy,
    required this.mileage,
    this.lastMaintenanceDate,
    this.unavailableDates = const [],
  });

  factory Car.fromJson(Map<String, dynamic> json) {
    return Car(
      id: json['id'] ?? '',
      hostId: json['hostId'] ?? '',
      make: json['make'] ?? '',
      model: json['model'] ?? '',
      year: json['year'] ?? 0,
      color: json['color'] ?? '',
      licensePlate: json['licensePlate'] ?? '',
      carType: CarType.values.firstWhere(
        (e) => e.toString().split('.').last == json['carType'],
        orElse: () => CarType.economy,
      ),
      transmission: TransmissionType.values.firstWhere(
        (e) => e.toString().split('.').last == json['transmission'],
        orElse: () => TransmissionType.automatic,
      ),
      fuelType: FuelType.values.firstWhere(
        (e) => e.toString().split('.').last == json['fuelType'],
        orElse: () => FuelType.gasoline,
      ),
      seats: json['seats'] ?? 0,
      doors: json['doors'] ?? 0,
      pricePerDay: (json['pricePerDay'] ?? 0.0).toDouble(),
      description: json['description'] ?? '',
      images: List<String>.from(json['images'] ?? []),
      features: List<String>.from(json['features'] ?? []),
      latitude: (json['latitude'] ?? 0.0).toDouble(),
      longitude: (json['longitude'] ?? 0.0).toDouble(),
      address: json['address'] ?? '',
      city: json['city'] ?? '',
      state: json['state'] ?? '',
      zipCode: json['zipCode'] ?? '',
      isAvailable: json['isAvailable'] ?? true,
      rating: (json['rating'] ?? 0.0).toDouble(),
      totalRentals: json['totalRentals'] ?? 0,
      createdAt: DateTime.parse(
        json['createdAt'] ?? DateTime.now().toIso8601String(),
      ),
      updatedAt: DateTime.parse(
        json['updatedAt'] ?? DateTime.now().toIso8601String(),
      ),
      insurancePolicy: json['insurancePolicy'],
      mileage: json['mileage'] ?? 0,
      lastMaintenanceDate: json['lastMaintenanceDate'] != null
          ? DateTime.parse(json['lastMaintenanceDate'])
          : null,
      unavailableDates:
          (json['unavailableDates'] as List?)
              ?.map((date) => DateTime.parse(date))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'hostId': hostId,
      'make': make,
      'model': model,
      'year': year,
      'color': color,
      'licensePlate': licensePlate,
      'carType': carType.toString().split('.').last,
      'transmission': transmission.toString().split('.').last,
      'fuelType': fuelType.toString().split('.').last,
      'seats': seats,
      'doors': doors,
      'pricePerDay': pricePerDay,
      'description': description,
      'images': images,
      'features': features,
      'latitude': latitude,
      'longitude': longitude,
      'address': address,
      'city': city,
      'state': state,
      'zipCode': zipCode,
      'isAvailable': isAvailable,
      'rating': rating,
      'totalRentals': totalRentals,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'insurancePolicy': insurancePolicy,
      'mileage': mileage,
      'lastMaintenanceDate': lastMaintenanceDate?.toIso8601String(),
      'unavailableDates': unavailableDates
          .map((date) => date.toIso8601String())
          .toList(),
    };
  }

  String get fullName => '$year $make $model';

  String get carTypeDisplay {
    switch (carType) {
      case CarType.economy:
        return 'Economy';
      case CarType.compact:
        return 'Compact';
      case CarType.midsize:
        return 'Mid-size';
      case CarType.fullsize:
        return 'Full-size';
      case CarType.suv:
        return 'SUV';
      case CarType.luxury:
        return 'Luxury';
      case CarType.convertible:
        return 'Convertible';
      case CarType.hybrid:
        return 'Hybrid';
      case CarType.electric:
        return 'Electric';
    }
  }

  String get transmissionDisplay {
    switch (transmission) {
      case TransmissionType.manual:
        return 'Manual';
      case TransmissionType.automatic:
        return 'Automatic';
    }
  }

  String get fuelTypeDisplay {
    switch (fuelType) {
      case FuelType.gasoline:
        return 'Gasoline';
      case FuelType.diesel:
        return 'Diesel';
      case FuelType.hybrid:
        return 'Hybrid';
      case FuelType.electric:
        return 'Electric';
    }
  }

  bool isAvailableForDates(DateTime startDate, DateTime endDate) {
    for (DateTime unavailableDate in unavailableDates) {
      if (unavailableDate.isAfter(
            startDate.subtract(const Duration(days: 1)),
          ) &&
          unavailableDate.isBefore(endDate.add(const Duration(days: 1)))) {
        return false;
      }
    }
    return isAvailable;
  }

  Car copyWith({
    String? id,
    String? hostId,
    String? make,
    String? model,
    int? year,
    String? color,
    String? licensePlate,
    CarType? carType,
    TransmissionType? transmission,
    FuelType? fuelType,
    int? seats,
    int? doors,
    double? pricePerDay,
    String? description,
    List<String>? images,
    List<String>? features,
    double? latitude,
    double? longitude,
    String? address,
    String? city,
    String? state,
    String? zipCode,
    bool? isAvailable,
    double? rating,
    int? totalRentals,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? insurancePolicy,
    int? mileage,
    DateTime? lastMaintenanceDate,
    List<DateTime>? unavailableDates,
  }) {
    return Car(
      id: id ?? this.id,
      hostId: hostId ?? this.hostId,
      make: make ?? this.make,
      model: model ?? this.model,
      year: year ?? this.year,
      color: color ?? this.color,
      licensePlate: licensePlate ?? this.licensePlate,
      carType: carType ?? this.carType,
      transmission: transmission ?? this.transmission,
      fuelType: fuelType ?? this.fuelType,
      seats: seats ?? this.seats,
      doors: doors ?? this.doors,
      pricePerDay: pricePerDay ?? this.pricePerDay,
      description: description ?? this.description,
      images: images ?? this.images,
      features: features ?? this.features,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      address: address ?? this.address,
      city: city ?? this.city,
      state: state ?? this.state,
      zipCode: zipCode ?? this.zipCode,
      isAvailable: isAvailable ?? this.isAvailable,
      rating: rating ?? this.rating,
      totalRentals: totalRentals ?? this.totalRentals,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      insurancePolicy: insurancePolicy ?? this.insurancePolicy,
      mileage: mileage ?? this.mileage,
      lastMaintenanceDate: lastMaintenanceDate ?? this.lastMaintenanceDate,
      unavailableDates: unavailableDates ?? this.unavailableDates,
    );
  }
}
