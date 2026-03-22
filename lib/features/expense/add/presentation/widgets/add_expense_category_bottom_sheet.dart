import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../../core/theme/colors.dart';
import '../../../../../core/theme/sizes.dart';
import '../../domain/entities/expense_category.dart';

/// Category Bottom Sheet widget cho việc chọn danh mục chi tiêu
class AddExpenseCategoryBottomSheet extends StatelessWidget {
  final String? selectedId;
  final void Function(String id) onSelect;

  const AddExpenseCategoryBottomSheet({
    super.key,
    this.selectedId,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.scaffoldBackground,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(Sizes.radiusLarge),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: Sizes.hMedium),
          // Thanh kéo để người dùng biết có thể kéo xuống để đóng bottom sheet
          Container(
            width: Sizes.sheetHandleWidth,
            height: Sizes.hSmall,
            decoration: BoxDecoration(
              color: AppColors.inputBorderIdle,
              borderRadius: BorderRadius.circular(Sizes.hSmall / 2),
            ),
          ),

          const SizedBox(height: Sizes.hLarge + 2),

          const Text(
            'Chọn danh mục',
            style: TextStyle(
              color: AppColors.textPrimary,
              fontSize: Sizes.textMedium,
              fontWeight: FontWeight.w800,
              letterSpacing: -0.3,
            ),
          ),

          const SizedBox(height: Sizes.hLarge),

          Padding(
            padding: EdgeInsets.symmetric(horizontal: Sizes.wLarge),
            child: GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 4,
              crossAxisSpacing: Sizes.wMedium,
              mainAxisSpacing: Sizes.hLarge,
              childAspectRatio: 0.85,
              children: ExpenseCategory.all.map((cat) {
                final sel = cat.id == selectedId;

                return GestureDetector(
                  onTap: () {
                    HapticFeedback.selectionClick();

                    onSelect(cat.id);
                  },
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 150),
                        width: 56,
                        height: 56,
                        decoration: BoxDecoration(
                          color: sel
                              ? cat.color.withOpacity(0.2)
                              : AppColors.cardBackground,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: sel ? cat.color : AppColors.inputBorderIdle,
                            width: sel ? 2 : 1.5,
                          ),
                          boxShadow: sel
                              ? [
                                  BoxShadow(
                                    color: cat.color.withOpacity(0.28),
                                    blurRadius: 12,
                                  ),
                                ]
                              : null,
                        ),
                        child: Center(
                          child: Text(
                            cat.icon,
                            style: const TextStyle(fontSize: 26),
                          ),
                        ),
                      ),

                      const SizedBox(height: Sizes.hSmall + 2),

                      Text(
                        cat.label,
                        style: TextStyle(
                          color: sel
                              ? AppColors.textPrimary
                              : AppColors.textHint,
                          fontSize: Sizes.textSmall - 1,
                          fontWeight: sel ? FontWeight.w700 : FontWeight.w500,
                        ),
                        textAlign: TextAlign.center,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),

          const SizedBox(height: 36),
        ],
      ),
    );
  }
}
