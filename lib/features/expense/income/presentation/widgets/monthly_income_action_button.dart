import 'package:flutter/material.dart';

import '../../../../../core/theme/colors.dart';
import '../../../../../core/theme/sizes.dart';

/// Nút hành động chính ở cuối màn hình — Lưu, Cập nhật, hoặc Chỉnh sửa.
class MonthlyIncomeActionButton extends StatelessWidget {
  final bool canSave;
  final bool hasExistingIncome;
  final bool isEditing;
  final VoidCallback onSave;
  final VoidCallback onStartEdit;
  final VoidCallback onCancelEdit;

  const MonthlyIncomeActionButton({
    super.key,
    required this.canSave,
    required this.hasExistingIncome,
    required this.isEditing,
    required this.onSave,
    required this.onStartEdit,
    required this.onCancelEdit,
  });

  @override
  Widget build(BuildContext context) {
    // Chế độ xem (có dữ liệu, chưa nhấn chỉnh sửa)
    if (hasExistingIncome && !isEditing) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: Sizes.wLarge),
        child: SizedBox(
          width: double.infinity,
          height: Sizes.buttonHeight,
          child: ElevatedButton.icon(
            onPressed: onStartEdit,
            icon: const Icon(Icons.edit_outlined, size: Sizes.iconMedium),
            label: const Text('Chỉnh sửa thu nhập'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.surface,
              foregroundColor: AppColors.textAppName,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(Sizes.radiusButton),
                side: const BorderSide(
                  color: AppColors.inputBorderIdle,
                  width: Sizes.borderThin,
                ),
              ),
              textStyle: const TextStyle(
                fontSize: Sizes.textMedium,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ),
      );
    }
    // Chế độ nhập / chỉnh sửa
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: Sizes.wLarge),
      child: Column(
        children: [
          SizedBox(
            width: double.infinity,
            height: Sizes.buttonHeight,
            child: ElevatedButton(
              onPressed: canSave ? onSave : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: canSave
                    ? AppColors.primary
                    : AppColors.surface,
                foregroundColor: canSave
                    ? AppColors.scaffoldBackground
                    : AppColors.textHint,
                disabledBackgroundColor: AppColors.surface,
                disabledForegroundColor: AppColors.textHint,
                elevation: canSave ? 4 : 0,
                shadowColor: AppColors.primary.withValues(alpha: 0.35),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(Sizes.radiusButton),
                  side: canSave
                      ? BorderSide.none
                      : const BorderSide(
                          color: AppColors.borderSubtle,
                          width: Sizes.borderThin,
                        ),
                ),
                textStyle: const TextStyle(
                  fontSize: Sizes.textMedium,
                  fontWeight: FontWeight.w800,
                ),
              ),
              child: Text(
                hasExistingIncome
                    ? 'Cập nhật thu nhập'
                    : (canSave
                          ? 'Lưu thu nhập tháng này'
                          : 'Nhập thu nhập của bạn'),
              ),
            ),
          ),
          if (isEditing) ...[
            const SizedBox(height: Sizes.hMedium),

            SizedBox(
              width: double.infinity,
              height: Sizes.buttonHeight,
              child: TextButton(
                onPressed: onCancelEdit,
                style: TextButton.styleFrom(
                  foregroundColor: AppColors.textSecondary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(Sizes.radiusButton),
                    side: const BorderSide(
                      color: AppColors.borderSubtle,
                      width: Sizes.borderThin,
                    ),
                  ),
                  textStyle: const TextStyle(
                    fontSize: Sizes.textRegular,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                child: const Text('Hủy chỉnh sửa'),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
