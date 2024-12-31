import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:testapp/Models/DataModel.dart';
import 'package:testapp/features/Expense Tracking/Expenses/add_expense.dart';
import 'package:testapp/features/Expense Tracking/Expenses/expense_list.dart';

class ExpenseScreen extends StatefulWidget {
  @override
  _ExpenseScreenState createState() => _ExpenseScreenState();
}

class _ExpenseScreenState extends State<ExpenseScreen> {
  DateTime? selectedMonth;

  @override
  void initState() {
    super.initState();
    selectedMonth = DateTime.now();
  }

  Future<void> _selectMonth(BuildContext context) async {
    final DateTime now = DateTime.now();
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedMonth ?? DateTime(now.year, now.month, 1),
      firstDate: DateTime(2020, 1, 1),
      lastDate: DateTime(2030, 12, 31),
      helpText: 'Select Month',
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
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
    final dataModel = Provider.of<DataModel>(context);
    final expenses = dataModel.getExpensesForMonth(selectedMonth);

    return Scaffold(
      appBar: AppBar(
        title: Text('Expenses'),
        backgroundColor: Colors.teal,
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () async {
              final newExpense = await Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AddExpenseScreen()),
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
                Text(
                  'Expenses for ${selectedMonth != null ? "${selectedMonth!.month}/${selectedMonth!.year}" : "this month"}',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                GestureDetector(
                  onTap: () => _selectMonth(context),
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey.shade400),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.shade300,
                          blurRadius: 10,
                          offset: Offset(0, 5),
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
                        SizedBox(width: 8),
                        Icon(Icons.calendar_today, color: Colors.teal, size: 18),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Expense List
          Expanded(
            child: ExpenseList(expenses: expenses),
          ),
        ],
      ),
    );
  }
}
