import 'package:flutter/material.dart';

import '../../theme/colors.dart';
import '../../theme/sizes.dart';

/// Model cho một tab thông thường trong bottom nav bar.
class AppNavItem {
  final IconData icon;
  final IconData activeIcon;
  final String label;

  const AppNavItem({
    required this.icon,
    required this.activeIcon,
    required this.label,
  });
}

/// Bottom navigation bar kiểu floating với nút + ở giữa nổi lên trên.
/// Layout: [item0] [item1] [        FAB        ] [item2] [item3]
///
/// [selectedIndex] nhận giá trị 0, 1, 3, 4 (2 = FAB, không thể selected).
class AppBottomNavBar extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onTabSelected;
  final VoidCallback onAddTap;

  static const List<AppNavItem> items = [
    AppNavItem(
      icon: Icons.home_outlined,
      activeIcon: Icons.home_rounded,
      label: 'Trang chủ',
    ),
    AppNavItem(
      icon: Icons.account_balance_wallet_outlined,
      activeIcon: Icons.account_balance_wallet_rounded,
      label: 'Thu nhập',
    ),
    AppNavItem(
      icon: Icons.bar_chart_outlined,
      activeIcon: Icons.bar_chart_rounded,
      label: 'Thống kê',
    ),
    AppNavItem(
      icon: Icons.person_outline_rounded,
      activeIcon: Icons.person_rounded,
      label: 'Hồ sơ',
    ),
  ];

  // map: navIndex → items index (skip slot 2 for FAB)
  static int _itemToNav(int itemIndex) =>
      itemIndex >= 2 ? itemIndex + 1 : itemIndex;

  const AppBottomNavBar({
    super.key,
    required this.selectedIndex,
    required this.onTabSelected,
    required this.onAddTap,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 82,
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.topCenter,
        children: [
          // ── Bar ──────────────────────────────────────────────────────────
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            top: 16,
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.cardBackground,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(Sizes.radiusCard),
                  topRight: Radius.circular(Sizes.radiusCard),
                ),
                border: Border(
                  top: BorderSide(
                    color: AppColors.primary.withValues(alpha: 0.12),
                    width: Sizes.borderThin,
                  ),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.35),
                    blurRadius: 24,
                    offset: const Offset(0, -4),
                  ),
                ],
              ),
              child: Row(
                children: [
                  // Left 2 items
                  _NavBarItem(
                    item: items[0],
                    isSelected: selectedIndex == _itemToNav(0),
                    onTap: () => onTabSelected(_itemToNav(0)),
                  ),
                  _NavBarItem(
                    item: items[1],
                    isSelected: selectedIndex == _itemToNav(1),
                    onTap: () => onTabSelected(_itemToNav(1)),
                  ),
                  // Center spacer for FAB
                  const Expanded(flex: 2, child: SizedBox.shrink()),
                  // Right 2 items
                  _NavBarItem(
                    item: items[2],
                    isSelected: selectedIndex == _itemToNav(2),
                    onTap: () => onTabSelected(_itemToNav(2)),
                  ),
                  _NavBarItem(
                    item: items[3],
                    isSelected: selectedIndex == _itemToNav(3),
                    onTap: () => onTabSelected(_itemToNav(3)),
                  ),
                ],
              ),
            ),
          ),
          // ── Center FAB ───────────────────────────────────────────────────
          Positioned(top: 0, child: _AddFab(onTap: onAddTap)),
        ],
      ),
    );
  }
}

// ──────────────────────────────────────────────────────────────────────────────

/// Một tab thông thường trong bar.
class _NavBarItem extends StatelessWidget {
  final AppNavItem item;
  final bool isSelected;
  final VoidCallback onTap;

  const _NavBarItem({
    required this.item,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 200),
              child: Icon(
                isSelected ? item.activeIcon : item.icon,
                key: ValueKey(isSelected),
                size: Sizes.iconMedium,
                color: isSelected ? AppColors.primary : AppColors.textHint,
              ),
            ),

            const SizedBox(height: 2),

            AnimatedDefaultTextStyle(
              duration: const Duration(milliseconds: 200),
              style: TextStyle(
                fontSize: 10,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                color: isSelected ? AppColors.primary : AppColors.textHint,
              ),
              child: Text(item.label),
            ),
          ],
        ),
      ),
    );
  }
}

/// Nút FAB ở giữa với hiệu ứng nhấn.
class _AddFab extends StatefulWidget {
  final VoidCallback onTap;
  const _AddFab({required this.onTap});

  @override
  State<_AddFab> createState() => _AddFabState();
}

class _AddFabState extends State<_AddFab> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _pressed = true),
      onTapUp: (_) {
        setState(() => _pressed = false);
        widget.onTap();
      },
      onTapCancel: () => setState(() => _pressed = false),
      child: AnimatedScale(
        scale: _pressed ? 0.90 : 1.0,
        duration: const Duration(milliseconds: 100),
        child: Container(
          width: 58,
          height: 58,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: AppColors.primary,
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withValues(alpha: 0.40),
                blurRadius: 18,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: const Icon(
            Icons.add_rounded,
            color: AppColors.scaffoldBackground,
            size: 30,
          ),
        ),
      ),
    );
  }
}
