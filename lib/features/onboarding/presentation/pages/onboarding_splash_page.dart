import 'package:flutter/material.dart';

import '../../../../core/theme/colors.dart';
import '../../../../core/theme/sizes.dart';
import '../widgets/index.dart';
import 'onboarding_name_page.dart';

/// Màn hình đầu tiên hiển thị khi người dùng chưa thiết lập hồ sơ
/// Hiệu ứng xuất hiện thương hiệu rồi điều hướng sang [OnboardingNamePage]
class OnboardingSplashPage extends StatefulWidget {
  const OnboardingSplashPage({super.key});

  @override
  State<OnboardingSplashPage> createState() => _OnboardingSplashPageState();
}

class _OnboardingSplashPageState extends State<OnboardingSplashPage>
    with SingleTickerProviderStateMixin {
  // Phase 0 → chỉ logo; 1 → tagline + chấm nhảy; 2 → mờ dần
  int _phase = 0;

  late final AnimationController _fadeOut;

  @override
  void initState() {
    super.initState();

    _fadeOut = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );

    Future.delayed(const Duration(milliseconds: 900), () => _setPhase(1));
    Future.delayed(const Duration(milliseconds: 2200), () => _setPhase(2));
    Future.delayed(const Duration(milliseconds: 2900), _navigateNext);
  }

  void _setPhase(int p) {
    if (!mounted) {
      return;
    }

    setState(() => _phase = p);

    if (p == 2) {
      _fadeOut.forward();
    }
  }

  void _navigateNext() {
    if (!mounted) {
      return;
    }

    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        pageBuilder: (_, __, ___) => const OnboardingNamePage(),
        transitionsBuilder: (_, anim, __, child) =>
            FadeTransition(opacity: anim, child: child),
        transitionDuration: const Duration(milliseconds: 500),
      ),
    );
  }

  @override
  void dispose() {
    _fadeOut.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground,
      body: FadeTransition(
        opacity: Tween<double>(
          begin: 1,
          end: 0,
        ).animate(CurvedAnimation(parent: _fadeOut, curve: Curves.easeIn)),
        child: Stack(
          children: [
            const OnboardingNameStarField(),
            // Ánh sáng hào quang radial – góc trên bên phải
            Positioned(
              top: -60,
              right: -60,
              child: Container(
                width: Sizes.decorationSize,
                height: Sizes.decorationSize,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      AppColors.primary.withValues(alpha: 0.10),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            ),

            Center(child: OnboardingSplashBrand(phase: _phase)),
          ],
        ),
      ),
    );
  }
}
