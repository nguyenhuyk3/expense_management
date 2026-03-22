import 'package:flutter/material.dart';

import '../../../../../core/theme/colors.dart';
import '../../../../../core/theme/sizes.dart';

/// Widget nút tròn có thể tái sử dụng với viền và nền
class AddExpenseCircleBtn extends StatelessWidget {
  final Widget child;
  final VoidCallback onTap;

  const AddExpenseCircleBtn({
    super.key,
    required this.child,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: Sizes.sheetHandleWidth,
        height: Sizes.sheetHandleWidth,
        decoration: BoxDecoration(
          color: AppColors.cardBackground,
          borderRadius: BorderRadius.circular(Sizes.hLarge),
          border: Border.all(color: AppColors.inputBorderIdle),
        ),
        child: Center(child: child),
      ),
    );
  }
}
