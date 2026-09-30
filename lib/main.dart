import 'package:flutter/material.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(const CodigosPostaisApp());
}

class CodigosPostaisApp extends StatelessWidget {
  const CodigosPostaisApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Códigos Postais Braga',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF1B5E20), // Verde Portugal / Braga
          brightness: Brightness.light,
        ),
        useMaterial3: true,
        appBarTheme: const AppBarTheme(
          centerTitle: true,
          elevation: 0,
        ),
        cardTheme: CardThemeData(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          filled: true,
        ),
      ),
      home: const HomeScreen(),
    );
  }
}
