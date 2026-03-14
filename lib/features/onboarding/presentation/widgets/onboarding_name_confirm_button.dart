import 'package:flutter/material.dart';

import '../../../../core/theme/colors.dart';
import '../../../../core/theme/sizes.dart';

/// Animated confirm button pinned at the bottom of the Onboarding Name page.
class OnboardingNameConfirmButton extends StatelessWidget {
  final String name;
  final VoidCallback onConfirm;

  const OnboardingNameConfirmButton({
    super.key,
    required this.name,
    required this.onConfirm,
  });

  @override
  Widget build(BuildContext context) {
    final isEmpty = name.isEmpty;

    return Padding(
      padding: const EdgeInsets.fromLTRB(
        Sizes.wXLarge,
        0,
        Sizes.wXLarge,
        Sizes.hXLarge,
      ),
      child: AnimatedSlide(
        offset: isEmpty ? const Offset(0, 0.15) : Offset.zero,
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOut,
        child: AnimatedOpacity(
          opacity: isEmpty ? 0.4 : 1.0,
          duration: const Duration(milliseconds: 200),
          child: GestureDetector(
            onTap: isEmpty ? null : onConfirm,
            child: Container(
              height: Sizes.headerHeight + 8,
              padding: const EdgeInsets.symmetric(horizontal: Sizes.wLarge),
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(Sizes.hXLarge),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (!isEmpty) ...[
                    Flexible(
                      child: Text(
                        'Bắt đầu với tên "$name"',
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        style: const TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: Sizes.textMedium,
                        ),
                      ),
                    ),

                    const SizedBox(width: Sizes.wSmall),

                    const Text(
                      '→',
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: Sizes.textXLarge,
                      ),
                    ),
                  ] else ...[
                    const Text(
                      'Bắt đầu',
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: Sizes.textMedium,
                      ),
                    ),

                    const SizedBox(width: Sizes.wSmall),
                    
                    const Text(
                      '→',
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: Sizes.textXLarge,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
