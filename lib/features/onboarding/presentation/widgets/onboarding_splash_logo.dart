import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../../../core/theme/colors.dart';

/// Animated logo mark: icon container + spinning outer ring with dot.
class OnboardingSplashLogo extends StatefulWidget {
  const OnboardingSplashLogo({super.key});

  @override
  State<OnboardingSplashLogo> createState() => _OnboardingSplashLogoState();
}

class _OnboardingSplashLogoState extends State<OnboardingSplashLogo>
    with TickerProviderStateMixin {
  late final AnimationController _spin;
  late final AnimationController _scaleController;
  late final Animation<double> _scale;

  @override
  void initState() {
    super.initState();

    _spin = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 12),
    )..repeat();

    _scaleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    )..forward();

    _scale = CurvedAnimation(
      parent: _scaleController,
      curve: const ElasticOutCurve(0.8),
    );
  }

  @override
  void dispose() {
    _spin.dispose();
    _scaleController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _scale,
      child: SizedBox(
        width: 108,
        height: 108,
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Spinning outer ring with orbiting dot
            AnimatedBuilder(
              animation: _spin,
              builder: (_, _) {
                return Transform.rotate(
                  angle: _spin.value * 2 * math.pi,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Container(
                        width: 108,
                        height: 108,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: AppColors.primary.withValues(alpha: 0.25),
                            width: 1.5,
                          ),
                        ),
                      ),
                      // Orbiting dot at top
                      Positioned(
                        top: 0,
                        child: Container(
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: AppColors.primary,
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.primary.withValues(alpha: 0.7),
                                blurRadius: 8,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
            // Icon container
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(26),
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFF1A1D2E), Color(0xFF0D0F1A)],
                ),
                border: Border.all(
                  color: AppColors.primary.withValues(alpha: 0.4),
                  width: 1.5,
                ),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha: 0.2),
                    blurRadius: 40,
                  ),
                ],
              ),
              alignment: Alignment.center,
              child: const Text('💰', style: TextStyle(fontSize: 36)),
            ),
          ],
        ),
      ),
    );
  }
}
