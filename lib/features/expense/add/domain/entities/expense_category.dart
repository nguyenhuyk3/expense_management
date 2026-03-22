import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class ExpenseCategory extends Equatable {
  final String id;
  final String icon;
  final String label;
  final Color color;

  const ExpenseCategory({
    required this.id,
    required this.icon,
    required this.label,
    required this.color,
  });

  // ── Static catalogue ──────────────────────────────────────────────────────
  static const List<ExpenseCategory> all = [
    ExpenseCategory(
      id: 'food',
      icon: '🍜',
      label: 'Ăn uống',
      color: Color(0xFFFF6B6B),
    ),
    ExpenseCategory(
      id: 'transport',
      icon: '🚗',
      label: 'Di chuyển',
      color: Color(0xFF4ECDC4),
    ),
    ExpenseCategory(
      id: 'shopping',
      icon: '🛍️',
      label: 'Mua sắm',
      color: Color(0xFFFFD93D),
    ),
    ExpenseCategory(
      id: 'health',
      icon: '💊',
      label: 'Sức khỏe',
      color: Color(0xFF6BCB77),
    ),
    ExpenseCategory(
      id: 'fun',
      icon: '🎮',
      label: 'Giải trí',
      color: Color(0xFFC77DFF),
    ),
    ExpenseCategory(
      id: 'education',
      icon: '📚',
      label: 'Học tập',
      color: Color(0xFF74C0FC),
    ),
    ExpenseCategory(
      id: 'housing',
      icon: '🏠',
      label: 'Nhà ở',
      color: Color(0xFFFFA94D),
    ),
    ExpenseCategory(
      id: 'travel',
      icon: '✈️',
      label: 'Du lịch',
      color: Color(0xFF63E6BE),
    ),
  ];

  static const List<Map<String, String>> paymentMethods = [
    {'id': 'cash', 'icon': '💵', 'label': 'Tiền mặt'},
    {'id': 'card', 'icon': '💳', 'label': 'Thẻ'},
    {'id': 'ewallet', 'icon': '📱', 'label': 'Ví điện tử'},
  ];

  static ExpenseCategory? findById(String id) {
    try {
      return all.firstWhere((c) => c.id == id);
    } catch (_) {
      return null;
    }
  }

  @override
  List<Object?> get props => [id, icon, label, color];
}
