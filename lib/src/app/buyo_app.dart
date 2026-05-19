import 'package:flutter/material.dart';

import '../features/home/presentation/home_page.dart';
import '../features/landing/presentation/landing_page.dart';
import 'app_routes.dart';

class BuyoApp extends StatelessWidget {
  const BuyoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Buyo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF09C08E)),
        fontFamily: 'Arial',
        useMaterial3: true,
      ),
      initialRoute: AppRoutes.landing,
      routes: {
        AppRoutes.landing: (_) => const LandingPage(),
        AppRoutes.home: (_) => const HomePage(),
      },
    );
  }
}
