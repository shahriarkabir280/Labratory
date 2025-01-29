import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:testapp/Models/DataModel.dart'; // Import the DataModel
import 'package:provider/provider.dart';
import 'package:testapp/backend_connections/api services/features/Expense_Tracking.dart';

import '../../../Models/UserState.dart';

class CreateBudgetScreen extends StatefulWidget {
  const CreateBudgetScreen({super.key});

  @override
  _CreateBudgetScreenState createState() => _CreateBudgetScreenState();
}

class _CreateBudgetScreenState extends State<CreateBudgetScreen> {
  final TextEditingController amountController = TextEditingController();
  final List<String> categories = [
    'Groceries',
    'Shopping',
    'Education',
    'Transport',
    'Bills',
    'Medical',
    'Others',
  ];
  String selectedCategory = 'Education';
  DateTime? selectedMonth;

  Future<void> _selectMonth(BuildContext context) async {
    final DateTime now = DateTime.now();
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime(now.year, now.month, 1),
      firstDate: DateTime(2020, 1, 1),
      lastDate: DateTime(2030, 12, 31),
      helpText: 'Select Month',
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Colors.teal,
              onPrimary: Colors.white,
              onSurface: Colors.teal,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        selectedMonth = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create New Budget'),
        backgroundColor: Colors.teal,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: () => _selectMonth(context),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade400),
                  borderRadius: BorderRadius.circular(12),
                  color: Colors.white,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      selectedMonth != null
                          ? DateFormat.yMMMM().format(selectedMonth!)
                          : 'Select a Month',
                      style: TextStyle(fontSize: 16, color: Colors.grey.shade700),
                    ),
                    const Icon(Icons.calendar_today, color: Colors.teal),
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
    if (selectedMonth != null && amountController.text.isNotEmpty) {

      final currentGroupCode = Provider.of<UserState>(context, listen: false).currentUser?.currentGroup?.groupCode;
      if (currentGroupCode == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("No current group selected")),
        );
        return;
      }

    final budget = Budget(
      id: '',
    category: selectedCategory,
    month: selectedMonth!,
    amount: double.parse(amountController.text),
    spent: 0.0,
      groupCode: currentGroupCode,
    );

    // Upload budget to the server
    bool success = await BudgetService.uploadBudget(budget);

    if (success) {
    Navigator.pop(context, budget); // Return the budget to the previous screen
    } else {
    ScaffoldMessenger.of(context).showSnackBar(
    const SnackBar(content: Text('Failed to save the budget')),
    );
    }
    } else {
    ScaffoldMessenger.of(context).showSnackBar(
    const SnackBar(content: Text('Please complete all fields')),
    );
    }
    },
    child: const Text('Save Budget'),
    ),
          ],
        ),
      ),
    );
  }
}
