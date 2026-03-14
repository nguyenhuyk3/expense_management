import 'package:flutter/material.dart';

import '../../../../core/services/user_local_service.dart';
import '../../../../core/theme/colors.dart';
import '../../../../core/theme/sizes.dart';
import '../widgets/onboarding_name_confirm_button.dart';
import '../widgets/onboarding_name_header.dart';
import '../widgets/onboarding_name_star_field.dart';
import '../widgets/onboarding_name_text_field.dart';
import 'onboarding_welcome_page.dart';

class OnboardingNamePage extends StatefulWidget {
  const OnboardingNamePage({super.key});

  @override
  State<OnboardingNamePage> createState() => _OnboardingNamePageState();
}

class _OnboardingNamePageState extends State<OnboardingNamePage> {
  final TextEditingController _controller = TextEditingController();
  static const int _maxLength = 30;

  String get _name => _controller.text.trim();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _onConfirm() async {
    if (_name.isEmpty) {
      return;
    }

    final name = _name;
    await UserLocalService.saveName(name);

    if (!mounted) {
      return;
    }

    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        pageBuilder: (_, __, ___) => OnboardingWelcomePage(name: name),
        transitionsBuilder: (_, anim, __, child) =>
            FadeTransition(opacity: anim, child: child),
        transitionDuration: const Duration(milliseconds: 500),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: AppColors.scaffoldBackground,
      body: Stack(
        children: [
          const OnboardingNameStarField(),
          
          SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(
                      horizontal: Sizes.wXLarge,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const SizedBox(height: Sizes.hXLarge),

                        const OnboardingNameHeader(),

                        const SizedBox(height: Sizes.hXLarge),

                        OnboardingNameTextField(
                          controller: _controller,
                          maxLength: _maxLength,
                          onChanged: (_) => setState(() {}),
                        ),

                        const SizedBox(height: Sizes.hXLarge),
                      ],
                    ),
                  ),
                ),

                OnboardingNameConfirmButton(name: _name, onConfirm: _onConfirm),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
