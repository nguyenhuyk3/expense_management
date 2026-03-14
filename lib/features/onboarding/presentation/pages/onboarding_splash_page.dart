import 'package:flutter/material.dart';

import '../../../../core/theme/colors.dart';
import '../../../../core/theme/sizes.dart';
import '../widgets/onboarding_name_star_field.dart';
import '../widgets/onboarding_splash_dots.dart';
import '../widgets/onboarding_splash_logo.dart';
import 'onboarding_name_page.dart';

/// Màn hình đầu tiên hiển thị khi người dùng chưa thiết lập hồ sơ.
/// Hiệu ứng xuất hiện thương hiệu rồi điều hướng sang [OnboardingNamePage].
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

            Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // ── Logo ──────────────────────────────────
                  const OnboardingSplashLogo(),

                  const SizedBox(height: Sizes.hXLarge),
                  // ── Tên ứng dụng ──────────────────────────────
                  _FadeUpText(
                    delay: const Duration(milliseconds: 150),
                    child: const Text(
                      'Spendly',
                      style: TextStyle(
                        fontWeight: FontWeight.w900,
                        fontSize: Sizes.text3XLarge,
                        color: AppColors.textAppName,
                        letterSpacing: -1,
                      ),
                    ),
                  ),
                  // ── Tagline ───────────────────────────────
                  AnimatedOpacity(
                    opacity: _phase >= 1 ? 1.0 : 0.0,
                    duration: const Duration(milliseconds: 500),
                    child: AnimatedSlide(
                      offset: _phase >= 1 ? Offset.zero : const Offset(0, 0.4),
                      duration: const Duration(milliseconds: 500),
                      curve: Curves.easeOut,
                      child: Padding(
                        padding: const EdgeInsets.only(top: Sizes.hMedium),
                        child: Text(
                          'Quản lý chi tiêu thông minh',
                          style: TextStyle(
                            color: AppColors.textSecondary.withValues(
                              alpha: 0.8,
                            ),
                            fontSize: Sizes.textRegular,
                            fontWeight: FontWeight.w400,
                            letterSpacing: 0.3,
                          ),
                        ),
                      ),
                    ),
                  ),
                  // ── Bouncing dots ─────────────────────────
                  AnimatedOpacity(
                    opacity: _phase >= 1 ? 1.0 : 0.0,
                    duration: const Duration(milliseconds: 400),
                    child: Padding(
                      padding: const EdgeInsets.only(top: 48),
                      child: _phase >= 1
                          ? const OnboardingSplashDots()
                          : const SizedBox(height: 6),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Widget hiệu ứng trượt lên và mờ dần khi xuất hiện.
class _FadeUpText extends StatefulWidget {
  final Widget child;
  final Duration delay;
  const _FadeUpText({required this.child, required this.delay});

  @override
  State<_FadeUpText> createState() => _FadeUpTextState();
}

class _FadeUpTextState extends State<_FadeUpText>
    with SingleTickerProviderStateMixin {
  late final AnimationController _c;
  late final Animation<double> _fade;
  late final Animation<Offset> _slide;

  @override
  void initState() {
    super.initState();

    _c = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _fade = CurvedAnimation(parent: _c, curve: Curves.easeOut);
    _slide = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _c, curve: Curves.easeOut));

    Future.delayed(widget.delay, () {
      if (mounted) {
        _c.forward();
      }
    });
  }

  @override
  void dispose() {
    _c.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fade,
      child: SlideTransition(position: _slide, child: widget.child),
    );
  }
}
