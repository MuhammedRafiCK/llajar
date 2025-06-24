class User {
  final String id;
  final String email;
  final String firstName;
  final String lastName;
  final String? phoneNumber;
  final String? profileImageUrl;
  final String? address;
  final String? city;
  final String? state;
  final String? zipCode;
  final String? country;
  final DateTime createdAt;
  final DateTime updatedAt;
  final bool isHost;
  final double rating;
  final int totalRentals;
  final int totalCarsListed;
  final bool isVerified;
  final String? driverLicenseNumber;
  final DateTime? driverLicenseExpiry;

  User({
    required this.id,
    required this.email,
    required this.firstName,
    required this.lastName,
    this.phoneNumber,
    this.profileImageUrl,
    this.address,
    this.city,
    this.state,
    this.zipCode,
    this.country,
    required this.createdAt,
    required this.updatedAt,
    this.isHost = false,
    this.rating = 0.0,
    this.totalRentals = 0,
    this.totalCarsListed = 0,
    this.isVerified = false,
    this.driverLicenseNumber,
    this.driverLicenseExpiry,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] ?? '',
      email: json['email'] ?? '',
      firstName: json['firstName'] ?? '',
      lastName: json['lastName'] ?? '',
      phoneNumber: json['phoneNumber'],
      profileImageUrl: json['profileImageUrl'],
      address: json['address'],
      city: json['city'],
      state: json['state'],
      zipCode: json['zipCode'],
      country: json['country'],
      createdAt: DateTime.parse(
        json['createdAt'] ?? DateTime.now().toIso8601String(),
      ),
      updatedAt: DateTime.parse(
        json['updatedAt'] ?? DateTime.now().toIso8601String(),
      ),
      isHost: json['isHost'] ?? false,
      rating: (json['rating'] ?? 0.0).toDouble(),
      totalRentals: json['totalRentals'] ?? 0,
      totalCarsListed: json['totalCarsListed'] ?? 0,
      isVerified: json['isVerified'] ?? false,
      driverLicenseNumber: json['driverLicenseNumber'],
      driverLicenseExpiry: json['driverLicenseExpiry'] != null
          ? DateTime.parse(json['driverLicenseExpiry'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'firstName': firstName,
      'lastName': lastName,
      'phoneNumber': phoneNumber,
      'profileImageUrl': profileImageUrl,
      'address': address,
      'city': city,
      'state': state,
      'zipCode': zipCode,
      'country': country,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'isHost': isHost,
      'rating': rating,
      'totalRentals': totalRentals,
      'totalCarsListed': totalCarsListed,
      'isVerified': isVerified,
      'driverLicenseNumber': driverLicenseNumber,
      'driverLicenseExpiry': driverLicenseExpiry?.toIso8601String(),
    };
  }

  String get fullName => '$firstName $lastName';

  User copyWith({
    String? id,
    String? email,
    String? firstName,
    String? lastName,
    String? phoneNumber,
    String? profileImageUrl,
    String? address,
    String? city,
    String? state,
    String? zipCode,
    String? country,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? isHost,
    double? rating,
    int? totalRentals,
    int? totalCarsListed,
    bool? isVerified,
    String? driverLicenseNumber,
    DateTime? driverLicenseExpiry,
  }) {
    return User(
      id: id ?? this.id,
      email: email ?? this.email,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
      address: address ?? this.address,
      city: city ?? this.city,
      state: state ?? this.state,
      zipCode: zipCode ?? this.zipCode,
      country: country ?? this.country,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isHost: isHost ?? this.isHost,
      rating: rating ?? this.rating,
      totalRentals: totalRentals ?? this.totalRentals,
      totalCarsListed: totalCarsListed ?? this.totalCarsListed,
      isVerified: isVerified ?? this.isVerified,
      driverLicenseNumber: driverLicenseNumber ?? this.driverLicenseNumber,
      driverLicenseExpiry: driverLicenseExpiry ?? this.driverLicenseExpiry,
    );
  }
}
