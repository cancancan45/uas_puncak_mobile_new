import 'package:flutter/material.dart';

import 'screens/onboarding_screen.dart';
import 'screens/main_navigation_screen.dart';

void main() {
  runApp(const PuncakApp());
}

class PuncakApp extends StatelessWidget {
  const PuncakApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'UAS Mobile - Puncak',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
        useMaterial3: true,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const OnboardingScreen(),
        '/main': (context) => const MainNavigationScreen(),
      },
    );
  }
}
