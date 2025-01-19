import 'package:flutter/material.dart';

class BudgetList extends StatelessWidget {
  final List<Map<String, dynamic>> budgets;
  final Function(Map<String, dynamic>) onEditBudget;
  final Function(Map<String, dynamic>) onDeleteBudget;

  BudgetList({
    required this.budgets,
    required this.onEditBudget,
    required this.onDeleteBudget,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: budgets.length,
      itemBuilder: (context, index) {
        final budget = budgets[index];
        final percentage = (budget['spent'] / budget['amount']) * 100;

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
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
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        budget['category'],
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey.shade800,
                        ),
                      ),
                      SizedBox(height: 8),
                      LinearProgressIndicator(
                        value: percentage / 100,
                        backgroundColor: Colors.grey.shade200,
                        color: Colors.teal,
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Spent ${budget['spent']} of ${budget['amount']}',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.delete, color: Colors.red),
                  onPressed: () {
                    onDeleteBudget(budget);
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
