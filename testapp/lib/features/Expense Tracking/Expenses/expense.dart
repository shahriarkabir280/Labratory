import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:testapp/Models/DataModel.dart';
import 'package:testapp/features/Expense Tracking/Expenses/add_expense.dart';
import 'package:testapp/features/Expense Tracking/Expenses/expense_list.dart';
import '../../../Models/UserState.dart';
import '../../../backend_connections/api services/features/Expense_Tracking.dart';

class ExpenseScreen extends StatefulWidget {
  const ExpenseScreen({super.key});

  @override
  _ExpenseScreenState createState() => _ExpenseScreenState();
}

class _ExpenseScreenState extends State<ExpenseScreen> {
  DateTime? selectedMonth;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    // Set the selectedMonth to the current month by default
    selectedMonth = DateTime.now();
    _fetchExpenses();
  }

  Future<void> _selectMonth(BuildContext context) async {
    final DateTime now = DateTime.now();
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedMonth ?? DateTime(now.year, now.month, 1),
      firstDate: DateTime(2020, 1, 1),
      lastDate: DateTime(2030, 12, 31),
      helpText: 'Select Month',
    );
    if (picked != null) {
      setState(() {
        selectedMonth = picked;
      });
      await _fetchExpenses();
    }
  }

  Future<void> _fetchExpenses() async {
    if (selectedMonth != null) {
      setState(() {
        isLoading = true;
      });

      final groupCode = Provider.of<UserState>(context, listen: false).currentUser?.currentGroup?.groupCode;
      if (groupCode == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("No current group selected")),
        );
        setState(() {
          isLoading = false;
        });
        return;
      }

      try {
        final expenses = await BudgetService.fetchExpenses(groupCode);
        if (mounted) {
          Provider.of<DataModel>(context, listen: false).setExpenses(expenses);
        }
      } catch (e) {
        // Handle errors (e.g., network issues)
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Error fetching expenses")),
        );
      } finally {
        if (mounted) {
          setState(() {
            isLoading = false;
          });
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final dataModel = Provider.of<DataModel>(context);
    final expenses = dataModel.getExpensesForMonth(selectedMonth);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Expenses'),
        backgroundColor: Colors.teal,
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () async {
              final newExpense = await Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AddExpenseScreen()),
              );
              if (newExpense != null) {
                dataModel.addExpense(newExpense);
              }
            },
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header: Month Selector
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    'Expenses for ${selectedMonth != null ? "${selectedMonth!.month}/${selectedMonth!.year}" : "this month"}',
                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                GestureDetector(
                  onTap: () => _selectMonth(context),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey.shade400),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.shade300,
                          blurRadius: 10,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Text(
                          selectedMonth != null
                              ? "${selectedMonth!.month}/${selectedMonth!.year}"
                              : 'Select Month',
                          style: TextStyle(fontSize: 16, color: Colors.grey.shade800),
                        ),
                        const SizedBox(width: 8),
                        const Icon(Icons.calendar_today, color: Colors.teal, size: 18),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Loading Indicator
          if (isLoading)
            const Center(child: CircularProgressIndicator()),
          // Expense List
          if (!isLoading)
            Expanded(
              child: ExpenseList(
                expenses: expenses,
                onDeleteExpense: (expense) {
                  dataModel.deleteExpense(expense);
                },
              ),
            ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
