import 'package:flutter/material.dart';

import '../../../../../core/services/user_local_service.dart';
import '../../../../../core/theme/colors.dart';
import '../../../../../core/theme/sizes.dart';

/// Trang hồ sơ người dùng — placeholder chờ implement.
class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final name = UserLocalService.getName();

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
                'Hồ sơ',
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: Sizes.text2XLarge,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -0.5,
                ),
              ),
              Expanded(child: _ProfileContent(name: name)),
            ],
          ),
        ),
      ),
    );
  }
}

/// Nội dung màn hình hồ sơ.
class _ProfileContent extends StatelessWidget {
  final String name;
  const _ProfileContent({required this.name});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: Sizes.hXLarge),
        _ProfileAvatar(name: name),
        const SizedBox(height: Sizes.hLarge),
        Text(
          name,
          style: const TextStyle(
            color: AppColors.textPrimary,
            fontSize: Sizes.textXLarge,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: Sizes.hXLarge),
        const _ProfileComingSoon(),
      ],
    );
  }
}

/// Avatar hiển thị chữ cái đầu của tên.
class _ProfileAvatar extends StatelessWidget {
  final String name;
  const _ProfileAvatar({required this.name});

  @override
  Widget build(BuildContext context) {
    final initial = name.isNotEmpty ? name[0].toUpperCase() : '?';
    return Container(
      width: Sizes.containerLarge,
      height: Sizes.containerLarge,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: AppColors.primary.withValues(alpha: 0.15),
        border: Border.all(
          color: AppColors.primary.withValues(alpha: 0.4),
          width: Sizes.borderThick,
        ),
      ),
      child: Center(
        child: Text(
          initial,
          style: const TextStyle(
            color: AppColors.primary,
            fontSize: Sizes.text2XLarge,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
    );
  }
}

/// Placeholder "sắp ra mắt".
class _ProfileComingSoon extends StatelessWidget {
  const _ProfileComingSoon();

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        Text('⚙️', style: TextStyle(fontSize: Sizes.emojiMedium)),
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
          'Tùy chỉnh hồ sơ đang được xây dựng',
          style: TextStyle(
            color: AppColors.textHint,
            fontSize: Sizes.textSmall,
          ),
        ),
      ],
    );
  }
}
