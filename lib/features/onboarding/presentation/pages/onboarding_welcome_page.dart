import 'package:flutter/material.dart';

import '../../../../core/theme/colors.dart';
import '../../../expense/add/presentation/pages/add_expense_page.dart';
import '../widgets/onboarding_name_star_field.dart';
import '../widgets/onboarding_welcome_content.dart';

/// Hiển thị sau khi người dùng nhập tên
/// Chào theo giờ hiện tại rồi tự động điều hướng về trang chủ
class OnboardingWelcomePage extends StatefulWidget {
  final String name;

  const OnboardingWelcomePage({super.key, required this.name});

  @override
  State<OnboardingWelcomePage> createState() => _OnboardingWelcomePageState();
}

class _OnboardingWelcomePageState extends State<OnboardingWelcomePage>
    with SingleTickerProviderStateMixin {
  late final AnimationController _enter;
  late final Animation<double> _fade;
  late final Animation<Offset> _slide;

  @override
  void initState() {
    super.initState();

    _enter = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    )..forward();
    _fade = CurvedAnimation(parent: _enter, curve: Curves.easeOut);
    _slide = Tween<Offset>(
      begin: const Offset(0, 0.08),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _enter, curve: Curves.easeOut));
    // TODO: thay Placeholder() bằng trang Home thực tế
    Future.delayed(const Duration(milliseconds: 2800), _navigateHome);
  }

  void _navigateHome() {
    if (!mounted) {
      return;
    }

    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        pageBuilder: (_, __, ___) => const AddExpensePage(),
        transitionsBuilder: (_, anim, __, child) =>
            FadeTransition(opacity: anim, child: child),
        transitionDuration: const Duration(milliseconds: 500),
      ),
    );
  }

  @override
  void dispose() {
    _enter.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground,
      body: Stack(
        children: [
          const OnboardingNameStarField(),

          Center(
            child: FadeTransition(
              opacity: _fade,
              child: SlideTransition(
                position: _slide,
                child: OnboardingWelcomeContent(name: widget.name),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
