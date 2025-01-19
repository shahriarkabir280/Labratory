import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:my_app/Models/DataModel.dart';
import 'create_budget.dart';
import 'package:my_app/features/Expense Tracking/Budgets/budget_list.dart';
import 'package:provider/provider.dart';
class BudgetScreen extends StatefulWidget {
  @override
  _BudgetScreenState createState() => _BudgetScreenState();
}

class _BudgetScreenState extends State<BudgetScreen> {
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
      initialDate: selectedMonth ?? now,
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
    final filteredBudgets = dataModel.budgets.where((budget) {
      return budget['month'].month == selectedMonth?.month &&
          budget['month'].year == selectedMonth?.year;
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text('Budgets'),
        backgroundColor: Colors.teal,
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () async {
              final newBudget = await Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => CreateBudgetScreen()),
              );
              if (newBudget != null) {
                dataModel.addBudget(newBudget);
              }
            },
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Your Budgets',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.teal.shade900,
                  ),
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
                              ? DateFormat.yMMMM().format(selectedMonth!)
                              : 'Select Month',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey.shade800,
                          ),
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
          Expanded(
            child: filteredBudgets.isEmpty
                ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.inbox,
                    size: 80,
                    color: Colors.teal.shade300,
                  ),
                  SizedBox(height: 16),
                  Text(
                    'No budgets found for the selected month.',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            )
                : BudgetList(
              budgets: filteredBudgets,
              onEditBudget: dataModel.addBudget,
              onDeleteBudget: (budget) {
                dataModel.deleteBudget(budget);
              },
            ),
          ),
        ],
      ),
    );
  }
}
