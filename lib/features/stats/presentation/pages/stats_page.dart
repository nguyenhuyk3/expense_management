import 'package:flutter/material.dart';

import '../../../../../core/theme/colors.dart';
import '../../../../../core/theme/sizes.dart';

/// Trang thống kê — placeholder chờ implement.
class StatsPage extends StatelessWidget {
  const StatsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: Sizes.wLarge),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: Sizes.hXLarge),
              const Text(
                'Thống kê',
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: Sizes.text2XLarge,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -0.5,
                ),
              ),
              const Expanded(child: _StatsComingSoon()),
            ],
          ),
        ),
      ),
    );
  }
}

/// Placeholder "sắp ra mắt".
class _StatsComingSoon extends StatelessWidget {
  const _StatsComingSoon();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('📊', style: TextStyle(fontSize: Sizes.emojiMedium)),
          SizedBox(height: Sizes.hLarge),
          Text(
            'Sắp ra mắt',
            style: TextStyle(
              color: AppColors.textSecondary,
              fontSize: Sizes.textMedium,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: Sizes.hSmall),
          Text(
            'Biểu đồ thống kê đang được xây dựng',
            style: TextStyle(
              color: AppColors.textHint,
              fontSize: Sizes.textSmall,
            ),
          ),
        ],
      ),
    );
  }
}
