import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:testapp/Models/DataModel.dart';

import '../../../Models/UserState.dart';
import '../../../backend_connections/api services/features/Expense_Tracking.dart';

class AddExpenseScreen extends StatefulWidget {
  const AddExpenseScreen({super.key});

  @override
  _AddExpenseScreenState createState() => _AddExpenseScreenState();
}

class _AddExpenseScreenState extends State<AddExpenseScreen> {
  final TextEditingController amountController = TextEditingController();
  final List<String> categories = ['Groceries', 'Shopping', 'Education', 'Transport', 'Bills', 'Medical', 'Others'];
  String selectedCategory = 'Education';
  DateTime selectedDate = DateTime.now();

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2020, 1, 1),
      lastDate: DateTime(2030, 12, 31),
    );
    if (picked != null) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Expense'),
        backgroundColor: Colors.teal,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: () => _selectDate(context),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${selectedDate.year}-${selectedDate.month}-${selectedDate.day}',
                    ),
                    const Icon(Icons.calendar_today),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: selectedCategory,
              items: categories.map((category) {
                return DropdownMenuItem(value: category, child: Text(category));
              }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedCategory = value!;
                });
              },
              decoration: const InputDecoration(
                labelText: 'Category',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: amountController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Amount',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () async {
                if (amountController.text.isNotEmpty) {
                  final currentGroupCode = Provider.of<UserState>(context, listen: false).currentUser?.currentGroup?.groupCode;
                  if (currentGroupCode == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("No current group selected")),
                    );
                    return;
                  }
                  final expense = Expense(
                    id: '', // Placeholder for server-generated ID
                    category: selectedCategory,
                    date: selectedDate,
                    amount: double.parse(amountController.text),
                    groupCode: currentGroupCode,
                  );

                  // Upload expense to the server
                  final success = await BudgetService.uploadExpense(expense);
                  if (success) {
                    // Add expense locally if upload is successful
                    Provider.of<DataModel>(context, listen: false).addExpense(expense);
                    Navigator.pop(context);
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Failed to upload expense.')),
                    );
                  }
                }
              },
              child: const Text('Add Expense'),
            ),
          ],
        ),
      ),
    );
  }
}
