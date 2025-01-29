import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:provider/provider.dart';
import '../../../Models/DataModel.dart';

class YearWiseAnalysisPage extends StatelessWidget {
  const YearWiseAnalysisPage({super.key});

  @override
  Widget build(BuildContext context) {
    final dataModel = Provider.of<DataModel>(context);
    final currentYear = DateTime.now().year;
    final years = List.generate(5, (index) => currentYear + index);

    // Categories explicitly defined
    final categories = [
      'Groceries',
      'Shopping',
      'Education',
      'Transport',
      'Bills',
      'Medical',
      'Others'
    ];

    // Fetch year-wise data for line graph
    final yearsExpense = years.map((year) => dataModel.getTotalExpensesForYear(year)).toList();
    final yearsBudget = years.map((year) => dataModel.getTotalBudgetsForYear(year)).toList();

    // Fetch category-wise aggregated data
    final categoriesExpense = categories.map((category) {
      double totalExpense = 0.0;
      for (final year in years) {
        final expensesForYear = dataModel.getCategoryWiseExpensesForYear(year);
        totalExpense += expensesForYear[category] ?? 0.0;
      }
      return totalExpense;
    }).toList();

    final categoriesBudget = categories.map((category) {
      double totalBudget = 0.0;
      for (final year in years) {
        final budgetsForYear = dataModel.getCategoryWiseBudgetsForYear(year);
        totalBudget += budgetsForYear[category] ?? 0.0;
      }
      return totalBudget;
    }).toList();

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
              'Analyzed Data',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 20,
                  height: 20,
                  color: Colors.blue.shade900,
                ),
                const SizedBox(width: 8),
                const Text('Expense', style: TextStyle(fontSize: 14)),
                const SizedBox(width: 30),
                Container(
                  width: 20,
                  height: 20,
                  color: Colors.green.shade900,
                ),
                const SizedBox(width: 8),
                const Text('Budget', style: TextStyle(fontSize: 14)),
              ],
            ),
            const SizedBox(height: 20),
            const Text(
              'Yearly Expense vs Budget Analysis',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 40),
            AspectRatio(
              aspectRatio: 2,
              child: LineChart(
                LineChartData(
                  gridData: const FlGridData(show: true),
                  titlesData: FlTitlesData(
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) => Text(
                          '৳${value.toInt()}',
                          style: const TextStyle(fontSize: 8),
                        ),
                      ),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          if (value.toInt() >= 0 && value.toInt() < years.length) {
                            return Text('${years[value.toInt()]}', style: const TextStyle(fontSize: 12));
                          }
                          return Container();
                        },
                      ),
                    ),
                  ),
                  borderData: FlBorderData(show: true, border: Border.all(color: Colors.grey)),
                  lineBarsData: [
                    _generateLineChartBarData(yearsExpense, Colors.blue.shade900),
                    _generateLineChartBarData(yearsBudget, Colors.green.shade900),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 30),
            const Text(
              'Expense & Budget Insights by Category',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 50),
            AspectRatio(
              aspectRatio: 2,
              child: BarChart(
                BarChartData(
                  gridData: const FlGridData(show: true),
                  titlesData: FlTitlesData(
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) => Text(
                          '৳${value.toInt()}',
                          style: const TextStyle(fontSize: 8),
                        ),
                      ),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          if (value.toInt() >= 0 && value.toInt() < categories.length) {
                            return RotatedBox(
                              quarterTurns: 1,
                              child: Text(categories[value.toInt()], style: const TextStyle(fontSize: 12)),
                            );
                          }
                          return Container();
                        },
                      ),
                    ),
                  ),
                  borderData: FlBorderData(show: true, border: Border.all(color: Colors.grey)),
                  barGroups: _generateBarChartGroups(categoriesExpense, categoriesBudget),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  LineChartBarData _generateLineChartBarData(List<double> data, Color color) {
    return LineChartBarData(
      spots: data.asMap().entries.map((e) => FlSpot(e.key.toDouble(), e.value)).toList(),
      isCurved: true,
      color: color,
      barWidth: 3,
      isStrokeCapRound: true,
      dotData: const FlDotData(show: true),
      belowBarData: BarAreaData(show: false),
    );
  }

  List<BarChartGroupData> _generateBarChartGroups(List<double> expenseData, List<double> budgetData) {
    List<BarChartGroupData> groups = [];
    for (int i = 0; i < expenseData.length; i++) {
      groups.add(
        BarChartGroupData(
          x: i,
          barRods: [
            BarChartRodData(
              toY: expenseData[i],
              color: Colors.blue.shade900,
              width: 20,
            ),
            BarChartRodData(
              toY: budgetData[i],
              color: Colors.green.shade900,
              width: 20,
            ),
          ],
        ),
      );
    }
    return groups;
  }
}
