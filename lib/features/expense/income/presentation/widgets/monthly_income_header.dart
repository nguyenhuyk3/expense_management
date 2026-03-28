import 'package:flutter/material.dart';

import '../../../../../core/theme/colors.dart';
import '../../../../../core/theme/sizes.dart';

/// Header màn hình thu nhập với tiêu đề thay đổi theo trạng thái.
class MonthlyIncomeHeader extends StatelessWidget {
  final bool hasExistingIncome;
  final bool isEditing;

  const MonthlyIncomeHeader({
    required this.hasExistingIncome,
    required this.isEditing,
    super.key,
  });

  String get _subtitle {
    if (isEditing) {
      return 'Đang chỉnh sửa';
    }
    if (hasExistingIncome) {
      return 'Đã lưu ✓';
    }

    return '';
  }

  String get _title {
    if (!hasExistingIncome) {
      return 'Thu nhập hàng tháng';
    }
    if (isEditing) {
      return 'Cập nhật thu nhập';
    }

    return 'Thu nhập của bạn';
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        Sizes.wLarge,
        Sizes.hLarge,
        Sizes.wLarge,
        0,
      ),
      child: Row(
        children: [
          if (Navigator.canPop(context)) ...[
            GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Container(
                width: 38,
                height: 38,
                margin: const EdgeInsets.only(right: Sizes.wMedium),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(Sizes.radiusMedium),
                  border: Border.all(
                    color: AppColors.borderSubtle,
                    width: Sizes.borderThin,
                  ),
                ),
                child: const Icon(
                  Icons.arrow_back_ios_new_rounded,
                  color: AppColors.textSecondary,
                  size: Sizes.iconSmall + 2,
                ),
              ),
            ),
          ],

          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (_subtitle.isNotEmpty) ...[
                Text(
                  _subtitle,
                  style: const TextStyle(
                    color: AppColors.textHint,
                    fontSize: Sizes.textSmall,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 1.2,
                  ),
                ),
              ],

              Text(
                _title,
                style: const TextStyle(
                  color: AppColors.textAppName,
                  fontSize: Sizes.textXLarge,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -0.5,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
