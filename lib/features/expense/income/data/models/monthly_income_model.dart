import '../../domain/entities/monthly_income_entity.dart';

class MonthlyIncomeModel extends MonthlyIncomeEntity {
  const MonthlyIncomeModel({
    required super.id,
    required super.income,
    required super.period,
    required super.createdAt,
    required super.updatedAt,
  });

  factory MonthlyIncomeModel.fromEntity(MonthlyIncomeEntity entity) =>
      MonthlyIncomeModel(
        id: entity.id,
        income: entity.income,
        period: entity.period,
        createdAt: entity.createdAt,
        updatedAt: entity.updatedAt,
      );

  factory MonthlyIncomeModel.fromMap(Map<dynamic, dynamic> map) =>
      MonthlyIncomeModel(
        id: map['id'] as String,
        income: map['income'] as int,
        period: map['period'] as String,
        createdAt: DateTime.fromMillisecondsSinceEpoch(map['createdAt'] as int),
        updatedAt: DateTime.fromMillisecondsSinceEpoch(map['updatedAt'] as int),
      );

  Map<String, dynamic> toMap() => {
    'id': id,
    'income': income,
    'period': period,
    'createdAt': createdAt.millisecondsSinceEpoch,
    'updatedAt': updatedAt.millisecondsSinceEpoch,
  };
}
