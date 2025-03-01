import 'package:hive/hive.dart';

part 'expense_model.g.dart'; // Ensure this part statement matches the filename

@HiveType(typeId: 0)
class RecurringExpense extends HiveObject {
  @HiveField(0)
  final String title;

  @HiveField(1)
  final double amount;

  @HiveField(2)
  final String category;

  @HiveField(3)
  final String frequency;

  @HiveField(4)
  final DateTime startDate;

  @HiveField(5)
  final bool isImportant;

  @HiveField(6) // New field added
  bool isActive; // Must be non-final to allow modifications

  RecurringExpense({
    required this.title,
    required this.amount,
    required this.category,
    required this.frequency,
    required this.startDate,
    this.isImportant = false,
    this.isActive = true, // Default to active
  });
}
