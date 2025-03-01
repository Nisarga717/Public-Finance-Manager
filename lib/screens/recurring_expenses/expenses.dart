import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:hive/hive.dart';
import 'expense_sheet.dart';
import 'expense_model.dart';

final recurringExpensesProvider =
    StateNotifierProvider<RecurringExpensesNotifier, List<RecurringExpense>>(
  (ref) => RecurringExpensesNotifier(),
);

class RecurringExpensesNotifier extends StateNotifier<List<RecurringExpense>> {
  RecurringExpensesNotifier() : super([]) {
    _loadExpenses();
  }

  void _loadExpenses() async {
    final box = await Hive.openBox<RecurringExpense>('recurring_expenses');
    state = box.values.toList();
  }

  void addExpense(RecurringExpense expense) async {
    final box = await Hive.openBox<RecurringExpense>('recurring_expenses');
    box.add(expense);
    state = [...box.values];
  }

  void removeExpense(int index) async {
    final box = await Hive.openBox<RecurringExpense>('recurring_expenses');
    box.deleteAt(index);
    state = [...box.values];
  }

  void toggleExpense(int index) async {
    state[index].isActive = !state[index].isActive;
    state[index].save();
    state = [...state];
  }
}

class RecurringExpenses extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final expenses = ref.watch(recurringExpensesProvider);

    return Scaffold(
      appBar: AppBar(title: Text('Recurring Expenses')),
      body: ListView.builder(
        itemCount: expenses.length,
        itemBuilder: (context, index) {
          final expense = expenses[index];
          return Slidable(
            endActionPane: ActionPane(
              motion: ScrollMotion(),
              children: [
                SlidableAction(
                  onPressed: (_) => ref
                      .read(recurringExpensesProvider.notifier)
                      .removeExpense(index),
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                  icon: Icons.delete,
                  label: 'Delete',
                ),
              ],
            ),
            child: Card(
              child: ListTile(
                title: Text(expense.title),
                subtitle: Text('\$${expense.amount} - ${expense.frequency}'),
                trailing: Switch(
                  value: expense.isActive,
                  onChanged: (_) => ref
                      .read(recurringExpensesProvider.notifier)
                      .toggleExpense(index),
                ),
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () => showModalBottomSheet(
          context: context,
          builder: (context) => AddRecurringExpenseSheet(),
        ),
      ),
    );
  }
}
