import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'expense_model.dart';
import 'expenses.dart';

class AddRecurringExpenseSheet extends ConsumerStatefulWidget {
  @override
  _AddRecurringExpenseSheetState createState() => _AddRecurringExpenseSheetState();
}

class _AddRecurringExpenseSheetState extends ConsumerState<AddRecurringExpenseSheet> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();
  String _selectedCategory = 'Groceries';
  String _selectedFrequency = 'Monthly';
  DateTime _selectedDate = DateTime.now();
  bool _isImportant = false;

  void _saveExpense() {
    if (_formKey.currentState!.validate()) {
      final expense = RecurringExpense(
        title: _titleController.text,
        amount: double.parse(_amountController.text),
        category: _selectedCategory,
        frequency: _selectedFrequency,
        startDate: _selectedDate,
        isImportant: _isImportant,
      );
      ref.read(recurringExpensesProvider.notifier).addExpense(expense);
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: _titleController,
              decoration: InputDecoration(labelText: 'Expense Title'),
              validator: (value) => value!.isEmpty ? 'Enter a title' : null,
            ),
            TextFormField(
              controller: _amountController,
              decoration: InputDecoration(labelText: 'Amount'),
              keyboardType: TextInputType.number,
              validator: (value) => value!.isEmpty ? 'Enter amount' : null,
            ),
            DropdownButtonFormField(
              value: _selectedCategory,
              items: ['Groceries', 'Rent', 'Utilities'].map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
              onChanged: (val) => setState(() => _selectedCategory = val!),
              decoration: InputDecoration(labelText: 'Category'),
            ),
            DropdownButtonFormField(
              value: _selectedFrequency,
              items: ['Daily', 'Weekly', 'Monthly', 'Yearly'].map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
              onChanged: (val) => setState(() => _selectedFrequency = val!),
              decoration: InputDecoration(labelText: 'Frequency'),
            ),
            SwitchListTile(
              title: Text('Mark as Important'),
              value: _isImportant,
              onChanged: (val) => setState(() => _isImportant = val),
            ),
            ElevatedButton(
              onPressed: _saveExpense,
              child: Text('Save Expense'),
            ),
          ],
        ),
      ),
    );
  }
}
