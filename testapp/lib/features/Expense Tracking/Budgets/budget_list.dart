import 'package:flutter/material.dart';
import 'package:testapp/Models/DataModel.dart'; // Import your data model file here

class BudgetList extends StatelessWidget {
  final List<Budget> budgets;
  final Function(Budget) onEditBudget;
  final Function(Budget) onDeleteBudget;
  final Function(Budget) onRenameBudget;

  const BudgetList({
    required this.budgets,
    required this.onEditBudget,
    required this.onDeleteBudget,
    required this.onRenameBudget,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: budgets.length,
      itemBuilder: (context, index) {
        final budget = budgets[index];
        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          elevation: 3,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            title: Text(
              budget.category,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            subtitle: Text(
              'Amount: ৳${budget.amount.toStringAsFixed(2)}',
              style: const TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),
            // Removed the trailing icons for delete and rename
          ),
        );
      },
    );
  }
}