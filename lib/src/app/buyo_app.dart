import 'package:flutter/material.dart';

import '../features/landing/presentation/landing_page.dart';
import '../features/scan_preview/presentation/scan_preview_page.dart';
import 'app_routes.dart';
import 'main_shell.dart';

class BuyoApp extends StatefulWidget {
  const BuyoApp({super.key});

  @override
  State<BuyoApp> createState() => _BuyoAppState();
}

class _BuyoAppState extends State<BuyoApp> {
  ThemeMode _themeMode = ThemeMode.light;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Buyo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF09C08E)),
        scaffoldBackgroundColor: const Color(0xFFECF8F4),
        fontFamily: 'Arial',
        useMaterial3: true,
      ),
      darkTheme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF09C08E),
          brightness: Brightness.dark,
        ),
        scaffoldBackgroundColor: const Color(0xFF0E1715),
        fontFamily: 'Arial',
        useMaterial3: true,
      ),
      themeMode: _themeMode,
      initialRoute: AppRoutes.landing,
      onGenerateRoute: (settings) {
        if (settings.name == AppRoutes.scanPreview) {
          final arguments = settings.arguments;
          if (arguments is ScanPreviewArguments) {
            return MaterialPageRoute<bool>(
              builder: (_) => ScanPreviewPage(arguments: arguments),
              settings: settings,
            );
          }
        }

        return null;
      },
      routes: {
        AppRoutes.landing: (_) => const LandingPage(),
        AppRoutes.home: (_) => MainShell(
          themeMode: _themeMode,
          onThemeModeChanged: (themeMode) {
            setState(() => _themeMode = themeMode);
          },
        ),
      },
    );
  }
}
