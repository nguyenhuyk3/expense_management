import 'package:flutter/material.dart';

import '../../../../../core/services/user_local_service.dart';
import '../../../../../core/theme/colors.dart';
import '../../../../../core/theme/sizes.dart';

/// Trang chủ — placeholder, sẽ hiển thị tổng quan chi tiêu.
class HomePage extends StatelessWidget {
  const HomePage({super.key});

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
              _HomeGreeting(name: name),
              const SizedBox(height: Sizes.hXLarge),
              const _HomeSummaryCard(),
              const SizedBox(height: Sizes.hLarge),
              const _HomeRecentLabel(),
              const SizedBox(height: Sizes.hLarge),
              const _HomeEmptyRecent(),
            ],
          ),
        ),
      ),
    );
  }
}

/// Lời chào theo tên người dùng.
class _HomeGreeting extends StatelessWidget {
  final String name;
  const _HomeGreeting({required this.name});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Xin chào, $name 👋',
          style: const TextStyle(
            color: AppColors.textPrimary,
            fontSize: Sizes.text2XLarge,
            fontWeight: FontWeight.w800,
            letterSpacing: -0.5,
          ),
        ),
        const SizedBox(height: Sizes.hSmall),
        const Text(
          'Hôm nay bạn chi tiêu thế nào?',
          style: TextStyle(
            color: AppColors.textSecondary,
            fontSize: Sizes.textRegular,
          ),
        ),
      ],
    );
  }
}

/// Card tóm tắt thu nhập / chi tiêu tháng (placeholder).
class _HomeSummaryCard extends StatelessWidget {
  const _HomeSummaryCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(Sizes.wXLarge),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF1E1A2E), Color(0xFF252040)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(Sizes.radiusCard),
        border: Border.all(
          color: AppColors.primary.withValues(alpha: 0.15),
          width: Sizes.borderThin,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'TỔNG QUAN THÁNG NÀY',
            style: TextStyle(
              color: AppColors.textHint,
              fontSize: Sizes.textSmall,
              fontWeight: FontWeight.w600,
              letterSpacing: 1.2,
            ),
          ),
          const SizedBox(height: Sizes.hMedium),
          const Text(
            '— ₫',
            style: TextStyle(
              color: AppColors.textAppName,
              fontSize: Sizes.text3XLarge,
              fontWeight: FontWeight.w800,
              letterSpacing: -1,
            ),
          ),
          const SizedBox(height: Sizes.hLarge),
          Row(
            children: [
              _SummaryChip(
                label: 'Thu nhập',
                value: '— ₫',
                color: AppColors.success,
              ),
              const SizedBox(width: Sizes.wMedium),
              _SummaryChip(
                label: 'Chi tiêu',
                value: '— ₫',
                color: AppColors.error,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// Chip nhỏ trong SummaryCard.
class _SummaryChip extends StatelessWidget {
  final String label;
  final String value;
  final Color color;

  const _SummaryChip({
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: Sizes.wMedium,
          vertical: Sizes.hMedium,
        ),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(Sizes.radiusMedium),
          border: Border.all(
            color: color.withValues(alpha: 0.2),
            width: Sizes.borderThin,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: TextStyle(
                color: color,
                fontSize: Sizes.textSmall,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              value,
              style: const TextStyle(
                color: AppColors.textPrimary,
                fontSize: Sizes.textRegular,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Nhãn "Chi tiêu gần đây".
class _HomeRecentLabel extends StatelessWidget {
  const _HomeRecentLabel();

  @override
  Widget build(BuildContext context) {
    return const Text(
      'Chi tiêu gần đây',
      style: TextStyle(
        color: AppColors.textPrimary,
        fontSize: Sizes.textMedium,
        fontWeight: FontWeight.w700,
      ),
    );
  }
}

/// Trạng thái rỗng khi chưa có chi tiêu.
class _HomeEmptyRecent extends StatelessWidget {
  const _HomeEmptyRecent();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          const SizedBox(height: Sizes.hXLarge),
          const Text('💸', style: TextStyle(fontSize: Sizes.emojiMedium)),
          const SizedBox(height: Sizes.hLarge),
          const Text(
            'Chưa có giao dịch nào',
            style: TextStyle(
              color: AppColors.textSecondary,
              fontSize: Sizes.textRegular,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: Sizes.hSmall),
          Text(
            'Nhấn + để ghi chi tiêu đầu tiên',
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
