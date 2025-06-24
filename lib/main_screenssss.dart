import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:llajar/src/providers/auth_provider.dart';
import 'package:llajar/src/providers/booking_provider.dart';
import 'package:llajar/src/providers/car_provider.dart';
import 'package:llajar/src/providers/favorites_provider.dart';
import 'package:llajar/src/utils/app_theme.dart';
import 'package:llajar/src/view/home/home_screen.dart';
import 'package:llajar/src/view/screens/main_screen.dart';
import 'package:llajar/src/view/screens/on_boarding_screen.dart';
import 'package:llajar/src/view/screens/splash_screen.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const LlajarCarRentalApp());
}

class LlajarCarRentalApp extends StatelessWidget {
  const LlajarCarRentalApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => CarProvider()),
        ChangeNotifierProvider(create: (_) => BookingProvider()),
        ChangeNotifierProvider(create: (_) => FavoritesProvider()),
      ],
      child: MaterialApp(
        title: 'Llajar Car Rental',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: ThemeMode.system,
        home: const HomeScreen(),
      ),
    );
  }
}
