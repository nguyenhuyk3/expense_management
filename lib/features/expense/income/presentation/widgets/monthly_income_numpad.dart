import 'package:flutter/material.dart';

import '../../../../../core/theme/colors.dart';
import '../../../../../core/theme/sizes.dart';

/// Bàn phím số dùng để nhập thu nhập hàng tháng.
/// Giao diện 3×4, các phím: 1-9, 000, 0, ⌫.
class MonthlyIncomeNumpad extends StatelessWidget {
  final ValueChanged<String> onKey;

  const MonthlyIncomeNumpad({super.key, required this.onKey});

  static const List<List<String>> _rows = [
    ['1', '2', '3'],
    ['4', '5', '6'],
    ['7', '8', '9'],
    ['000', '0', '⌫'],
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: Sizes.wLarge),
      child: Column(
        children: [for (int r = 0; r < _rows.length; r++) ..._buildRow(r)],
      ),
    );
  }

  List<Widget> _buildRow(int rowIndex) {
    final row = _rows[rowIndex];

    return [
      Expanded(
        child: Row(
          children: [
            for (int c = 0; c < row.length; c++) ...[
              if (c > 0) ...[const SizedBox(width: Sizes.wMedium)],

              Expanded(
                child: _NumpadKey(
                  key: ValueKey('${row[c]}_$rowIndex'),
                  keyLabel: row[c],
                  onTap: onKey,
                ),
              ),
            ],
          ],
        ),
      ),

      if (rowIndex < _rows.length - 1) ...[
        const SizedBox(height: Sizes.hMedium),
      ],
    ];
  }
}

/// Một ô bàn phím.
class _NumpadKey extends StatefulWidget {
  final String keyLabel;
  final ValueChanged<String> onTap;

  const _NumpadKey({super.key, required this.keyLabel, required this.onTap});

  @override
  State<_NumpadKey> createState() => _NumpadKeyState();
}

class _NumpadKeyState extends State<_NumpadKey> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final isBackspace = widget.keyLabel == '⌫';

    return GestureDetector(
      onTapDown: (_) => setState(() => _pressed = true),
      onTapUp: (_) {
        setState(() => _pressed = false);

        widget.onTap(widget.keyLabel);
      },
      onTapCancel: () => setState(() => _pressed = false),
      child: AnimatedScale(
        scale: _pressed ? 0.92 : 1.0,
        duration: const Duration(milliseconds: 80),
        child: Container(
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: isBackspace ? AppColors.cardBackground : AppColors.surface,
            borderRadius: BorderRadius.circular(Sizes.radiusInput),
            border: Border.all(
              color: isBackspace
                  ? AppColors.primary.withValues(alpha: 0.15)
                  : AppColors.borderSubtle,
              width: Sizes.borderThin,
            ),
          ),
          child: Text(
            widget.keyLabel,
            style: TextStyle(
              color: isBackspace ? AppColors.primary : AppColors.textAppName,
              fontSize: Sizes.textLarge,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ),
    );
  }
}
