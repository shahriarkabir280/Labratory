import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:provider/provider.dart';
import 'package:testapp/Models/DataModel.dart';

class ExpensePieChart extends StatelessWidget {
  final DateTime selectedDate;

  const ExpensePieChart({super.key, required this.selectedDate});

  @override
  Widget build(BuildContext context) {
    return Consumer<DataModel>(
      builder: (context, dataModel, child) {
        // Use the selectedDate passed from the parent widget
        final categoryExpenses = dataModel.getCategoryWiseExpensesForMonth(selectedDate);
        final totalSpent = categoryExpenses.values.fold(0.0, (sum, value) => sum + value);

        List<PieChartSectionData> buildPieSections() {
          return categoryExpenses.entries.map((entry) {
            final String category = entry.key;
            final double amount = entry.value;
            final double percentage = (amount / totalSpent) * 100;

            return PieChartSectionData(
              value: amount,
              title: '${percentage.toStringAsFixed(1)}%',
              color: _getCategoryColor(category),
              titleStyle: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
              radius: 60,
            );
          }).toList();
        }

        return Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.teal.shade50, Colors.teal.shade100],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(15),
            boxShadow: [
              BoxShadow(
                color: Colors.teal.shade100.withOpacity(0.5),
                blurRadius: 10,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              SizedBox(
                height: 200,
                child: PieChart(
                  PieChartData(
                    sections: buildPieSections(),
                    sectionsSpace: 4,
                    centerSpaceRadius: 40,
                    startDegreeOffset: -90,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              _buildLegend(categoryExpenses),
            ],
          ),
        );
      },
    );
  }

  Widget _buildLegend(Map<String, double> categoryExpenses) {
    return Wrap(
      spacing: 12,
      runSpacing: 8,
      children: categoryExpenses.keys.map((category) {
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 12,
              height: 12,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: _getCategoryColor(category),
              ),
            ),
            const SizedBox(width: 8),
            Text(
              category,
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
            ),
          ],
        );
      }).toList(),
    );
  }

  Color _getCategoryColor(String category) {
    switch (category) {
      case 'Education':
        return Colors.blueAccent;
      case 'Shopping':
        return Colors.orangeAccent;
      case 'Groceries':
        return Colors.greenAccent;
      case 'Transport':
        return Colors.purpleAccent;
      case 'Bills':
        return Colors.redAccent;
      case 'Medical':
        return Colors.tealAccent;
      default:
        return Colors.grey;
    }
  }
}