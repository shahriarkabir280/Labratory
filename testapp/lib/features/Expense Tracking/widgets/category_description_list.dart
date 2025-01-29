import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:testapp/Models/DataModel.dart';

class CategoryDescriptionList extends StatelessWidget {
  final DataModel dataModel;
  final DateTime selectedDate;

  const CategoryDescriptionList({
    Key? key,
    required this.dataModel,
    required this.selectedDate,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final budgets = dataModel.getBudgetsForMonth(selectedDate);
    final categoryExpenses = dataModel.getCategoryWiseExpensesForMonth(selectedDate);

    if (budgets.isEmpty) {
      return Center(
        child: Text(
          'No budgets found for this month',
          style: TextStyle(
            fontSize: 16,
            color: Colors.grey.shade600,
          ),
        ),
      );
    }

    return ListView.builder(
      physics: BouncingScrollPhysics(),
      itemCount: budgets.length,
      itemBuilder: (context, index) {
        final budget = budgets[index];
        final spent = categoryExpenses[budget.category] ?? 0.0;
        final remaining = budget.amount - spent;
        final percentage = budget.amount > 0
            ? ((spent / budget.amount) * 100).clamp(0, 100).toInt()
            : 0;

        // Determine color based on spending percentage
        final Color percentageColor = percentage >= 100
            ? Colors.red
            : percentage >= 80
            ? Colors.orange
            : Colors.teal;

        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.2),
                  blurRadius: 10,
                  offset: Offset(0, 5),
                ),
              ],
            ),
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundColor: percentageColor.withOpacity(0.2),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '$percentage%',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: percentageColor,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        budget.category,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey.shade800,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Budget: ${NumberFormat.currency(symbol: '\৳').format(budget.amount)}',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey.shade600,
                        ),
                      ),
                      Text(
                        'Spent: ${NumberFormat.currency(symbol: '\৳').format(spent)}',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey.shade600,
                        ),
                      ),
                      Text(
                        'Remaining: ${NumberFormat.currency(symbol: '\৳').format(remaining)}',
                        style: TextStyle(
                          fontSize: 14,
                          color: remaining < 0 ? Colors.red : Colors.grey.shade600,
                          fontWeight: remaining < 0 ? FontWeight.bold : FontWeight.normal,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}