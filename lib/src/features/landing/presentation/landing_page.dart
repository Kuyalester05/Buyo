import 'package:flutter/material.dart';

import '../../../app/app_routes.dart';
import '../../../shared/widgets/background_rings.dart';
import '../../../shared/widgets/buyo_leaf_mark.dart';

class LandingPage extends StatelessWidget {
  const LandingPage({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final isWide = size.width > 520;
    final contentWidth = isWide ? 380.0 : size.width * 0.7;

    return Scaffold(
      body: DecoratedBox(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF08CA94), Color(0xFF009E7C), Color(0xFF007C76)],
            stops: [0.02, 0.56, 1],
          ),
        ),
        child: Stack(
          children: [
            const Positioned.fill(child: BackgroundRings()),
            SafeArea(
              child: Center(
                child: ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: contentWidth),
                  child: Column(
                    children: [
                      const Spacer(flex: 27),
                      const BuyoLeafMark(),
                      const SizedBox(height: 54),
                      const FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                          'BUYO',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 45,
                            fontWeight: FontWeight.w900,
                            height: 0.92,
                            letterSpacing: 0,
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'AI-powered Buyo leaf disease\n'
                        'detection & severity assessment',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12.5,
                          fontWeight: FontWeight.w400,
                          height: 1.45,
                          letterSpacing: 0,
                        ),
                      ),
                      const SizedBox(height: 49),
                      SizedBox(
                        width: double.infinity,
                        height: 47,
                        child: OutlinedButton(
                          onPressed: () {
                            Navigator.of(
                              context,
                            ).pushReplacementNamed(AppRoutes.home);
                          },
                          style:
                              OutlinedButton.styleFrom(
                                foregroundColor: Colors.white,
                                side: const BorderSide(
                                  color: Colors.white,
                                  width: 1.2,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(7),
                                ),
                                textStyle: const TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w800,
                                  letterSpacing: 0,
                                ),
                              ).copyWith(
                                overlayColor: WidgetStatePropertyAll(
                                  Colors.white.withValues(alpha: 0.12),
                                ),
                              ),
                          child: const Text('Get Started'),
                        ),
                      ),
                      const SizedBox(height: 12),
                      const Text(
                        'Powered by Custom CNN - Leyte\n'
                        'Normal University',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 9,
                          fontWeight: FontWeight.w400,
                          height: 1.45,
                          letterSpacing: 0,
                        ),
                      ),
                      const Spacer(flex: 34),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
