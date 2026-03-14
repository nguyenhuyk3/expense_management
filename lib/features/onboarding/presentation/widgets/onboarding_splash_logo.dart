import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../../../core/theme/colors.dart';
import '../../../../core/theme/sizes.dart';

/// Widget logo: khối icon chứa emoji + vòng tròn xoay ngoài cùng với chấm orbit.
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
        width: Sizes.containerLarge,
        height: Sizes.containerLarge,
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Vòng tròn xoay ngoài cùng và chấm orbit
            AnimatedBuilder(
              animation: _spin,
              builder: (_, _) {
                return Transform.rotate(
                  angle: _spin.value * 2 * math.pi,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Container(
                        width: Sizes.containerLarge,
                        height: Sizes.containerLarge,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: AppColors.primary.withValues(alpha: 0.25),
                            width: Sizes.borderThin,
                          ),
                        ),
                      ),
                      // Chấm orbit phía trên
                      Positioned(
                        top: 0,
                        child: Container(
                          width: Sizes.dotMedium,
                          height: Sizes.dotMedium,
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
            // Khối chứa icon emoji
            Container(
              width: Sizes.containerMedium,
              height: Sizes.containerMedium,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(Sizes.radiusLarge),
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFF1A1D2E), Color(0xFF0D0F1A)],
                ),
                border: Border.all(
                  color: AppColors.primary.withValues(alpha: 0.4),
                  width: Sizes.borderThin,
                ),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha: 0.2),
                    blurRadius: 40,
                  ),
                ],
              ),
              alignment: Alignment.center,
              child: const Text(
                '💰',
                style: TextStyle(fontSize: Sizes.emojiSmall),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
