import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:testapp/Models/DataModel.dart';

class ExpensePieChart extends StatelessWidget {
  final DataModel dataModel;

  ExpensePieChart({required this.dataModel});

  @override
  Widget build(BuildContext context) {
    final budgets = dataModel.budgets;

    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        gradient: LinearGradient(
          colors: [Colors.teal.shade50, Colors.teal.shade100],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.teal.shade100.withOpacity(0.5),
            blurRadius: 10,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            height: 200,
            child: PieChart(
              PieChartData(
                sections: _buildPieSections(budgets),
                sectionsSpace: 6,
                centerSpaceRadius: 40,
                startDegreeOffset: -90,
                borderData: FlBorderData(show: false),
              ),
            ),
          ),
          SizedBox(height: 16),
          _buildLegend(budgets),
        ],
      ),
    );
  }

  List<PieChartSectionData> _buildPieSections(List<Map<String, dynamic>> budgets) {
    return budgets.map((budget) {
      double percentage = (budget['spent'] / budget['amount']) * 100;
      return PieChartSectionData(
        value: percentage,
        color: _getCategoryColor(budget['category']),
        title: '${percentage.toStringAsFixed(1)}%',
        titleStyle: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
        radius: 50,
      );
    }).toList();
  }

  Widget _buildLegend(List<Map<String, dynamic>> budgets) {
    return Wrap(
      alignment: WrapAlignment.center,
      spacing: 16,
      children: budgets.map((budget) {
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 12,
              height: 12,
              decoration: BoxDecoration(
                color: _getCategoryColor(budget['category']),
                shape: BoxShape.circle,
              ),
            ),
            SizedBox(width: 8),
            Text(
              budget['category'],
              style: TextStyle(fontSize: 12, color: Colors.grey.shade800),
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
      default:
        return Colors.grey;
    }
  }
}
