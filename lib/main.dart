import 'package:flutter/material.dart';
import 'package:llajar/home_screen.dart';

void main() {
  runApp(const CarRentalsApp());
}

class CarRentalsApp extends StatelessWidget {
  const CarRentalsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Car Rentals',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        primaryColor: const Color(0xFF2c4c62),
        fontFamily: 'Roboto',
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const HomeScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
