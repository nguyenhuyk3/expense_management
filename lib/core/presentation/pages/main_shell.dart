import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../features/expense/add/presentation/pages/add_expense_page.dart';
import '../../../features/expense/income/presentation/pages/monthly_income_page.dart';
import '../../../features/home/presentation/pages/home_page.dart';
import '../../../features/profile/presentation/pages/profile_page.dart';
import '../../../features/stats/presentation/pages/stats_page.dart';
import '../../theme/colors.dart';
import '../widgets/app_bottom_nav_bar.dart';

/// Shell chứa bottom navigation bar và quản lý các tabs chính.
///
/// Tabs:
///   0 → Trang chủ [HomePage]
///   1 → Thu nhập [MonthlyIncomePage]
///   2 → [FAB] Mở AddExpensePage qua route
///   3 → Thống kê [StatsPage]
///   4 → Hồ sơ [ProfilePage]
class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  /// Index hiện tại: 0, 1, 3 hoặc 4 (2 = FAB, không dùng cho tab).
  int _selectedIndex = 0;

  /// Tăng mỗi khi rời tab Thu nhập → buộc MonthlyIncomePage rebuild khi quay lại.
  int _incomeRebuildKey = 0;

  /// Chuyển nav-index (0,1,3,4) sang page-index (0,1,2,3)
  int get _pageIndex {
    if (_selectedIndex >= 3) {
      return _selectedIndex - 1;
    }

    return _selectedIndex;
  }

  void _onTabSelected(int navIndex) {
    if (navIndex == 2) {
      return; // FAB, bỏ qua
    }
    // Rời tab Thu nhập (1) sang tab khác → reset income page
    if (_selectedIndex == 1 && navIndex != 1) {
      _incomeRebuildKey++;
    }

    HapticFeedback.selectionClick();

    setState(() => _selectedIndex = navIndex);
  }

  Future<void> _onAddTap() async {
    HapticFeedback.mediumImpact();

    await Navigator.of(context).push<void>(
      PageRouteBuilder(
        pageBuilder: (_, animation, __) => const AddExpensePage(),
        transitionsBuilder: (_, animation, __, child) {
          final curved = CurvedAnimation(
            parent: animation,
            curve: Curves.easeOutCubic,
          );

          return SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(0, 1),
              end: Offset.zero,
            ).animate(curved),
            child: child,
          );
        },
        transitionDuration: const Duration(milliseconds: 380),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground,
      body: IndexedStack(
        index: _pageIndex,
        children: [
          const HomePage(),
          MonthlyIncomePage(key: ValueKey(_incomeRebuildKey)),
          const StatsPage(),
          const ProfilePage(),
        ],
      ),
      bottomNavigationBar: AppBottomNavBar(
        selectedIndex: _selectedIndex,
        onTabSelected: _onTabSelected,
        onAddTap: _onAddTap,
      ),
    );
  }
}
