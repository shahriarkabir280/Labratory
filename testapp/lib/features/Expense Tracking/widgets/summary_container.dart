import 'package:flutter/material.dart';

class SummaryContainer extends StatelessWidget {
  final double totalBudget;
  final double totalSpent;
  final double remaining;

  SummaryContainer({
    required this.totalBudget,
    required this.totalSpent,
    required this.remaining,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: LinearGradient(
          colors: [Colors.teal.shade50, Colors.teal.shade100],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.teal.shade100.withOpacity(0.4),
            blurRadius: 10,
            offset: Offset(0, 5),
          ),
        ],
      ),
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 25),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildSummaryItem(
            label: 'Budget',
            amount: totalBudget.toStringAsFixed(2),
            color: Colors.blueAccent,
            icon: Icons.account_balance_wallet_outlined,
          ),
          _buildSummaryItem(
            label: 'Expense',
            amount: totalSpent.toStringAsFixed(2),
            color: Colors.orangeAccent,
            icon: Icons.shopping_cart_outlined,
          ),
          _buildSummaryItem(
            label: 'Remaining',
            amount: remaining.toStringAsFixed(2),
            color: Colors.greenAccent,
            icon: Icons.savings_outlined,
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryItem({
    required String label,
    required String amount,
    required Color color,
    required IconData icon,
  }) {
    return Column(
      children: [
        // Icon with Label
        Row(
          children: [
            Icon(icon, size: 18, color: color),
            SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
                color: Colors.grey.shade800,
              ),
            ),
          ],
        ),
        SizedBox(height: 10),
        // Amount Display
        Text(
          '\$$amount',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        SizedBox(height: 10),
        // Progress Bar
        Stack(
          alignment: Alignment.center,
          children: [
            SizedBox(
              width: 50,
              height: 50,
              child: CircularProgressIndicator(
                value: _calculateProgress(label),
                backgroundColor: Colors.grey.shade300,
                valueColor: AlwaysStoppedAnimation<Color>(color),
                strokeWidth: 6,
              ),
            ),
            Text(
              '${(_calculateProgress(label) * 100).toInt()}%',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: Colors.grey.shade800,
              ),
            ),
          ],
        ),
      ],
    );
  }

  // Helper function to calculate progress
  double _calculateProgress(String label) {
    switch (label) {
      case 'Budget':
        return 1.0;
      case 'Expense':
        return totalBudget == 0 ? 0 : totalSpent / totalBudget;
      case 'Remaining':
        return totalBudget == 0 ? 0 : remaining / totalBudget;
      default:
        return 0;
    }
  }
}
