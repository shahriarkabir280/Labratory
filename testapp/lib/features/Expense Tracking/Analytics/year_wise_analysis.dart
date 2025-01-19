import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:provider/provider.dart';
import '../../../Models/DataModel.dart';

class YearWiseAnalysisPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final dataModel = Provider.of<DataModel>(context);
    final currentYear = DateTime.now().year;
    final years = List.generate(5, (index) => currentYear + index);

    // Defining all categories explicitly, even if they are missing in the data
    final categories = [
      'Groceries',
      'Shopping',
      'Education',
      'Transport',
      'Bills',
      'Medical',
      'Others'
    ];

    // Fetching dynamically updated data for line graph
    final yearsExpense = years.map((year) => dataModel.getTotalExpensesForYear(year)).toList();
    final yearsBudget = years.map((year) => dataModel.getTotalBudgetsForYear(year)).toList();

    // Fetching expenses for each category, including zero values where applicable
    final categoriesExpense = categories.map((category) {
      double totalExpense = 0.0;
      for (final year in years) {
        final expensesForYear = dataModel.getCategoryWiseExpensesForYear(year);
        totalExpense += expensesForYear[category] ?? 0.0;  // Ensure zero if no data
      }
      return totalExpense;
    }).toList();

    // Fetching budgets for each category, including zero values where applicable
    final categoriesBudget = categories.map((category) {
      double totalBudget = 0.0;
      for (final year in years) {
        final budgetsForYear = dataModel.getCategoryWiseBudgetsForYear(year);
        totalBudget += budgetsForYear[category] ?? 0.0;  // Ensure zero if no data
      }
      return totalBudget;
    }).toList();

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'Analyzed Data',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),

            // Explanation about line colors
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 20,
                  height: 20,
                  color: Colors.blue.shade900,
                ),
                SizedBox(width: 8),
                Text('Expense', style: TextStyle(fontSize: 14)),
                SizedBox(width: 30),
                Container(
                  width: 20,
                  height: 20,
                  color: Colors.green.shade900,
                ),
                SizedBox(width: 8),
                Text('Budget', style: TextStyle(fontSize: 14)),
              ],
            ),
            SizedBox(height: 20),
            Text(
              'Yearly Expense vs Budget Analysis',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 40),

            // First Line Graph (Year-wise Expense vs Budget)
            AspectRatio(
              aspectRatio: 2,
              child: LineChart(
                LineChartData(
                  gridData: FlGridData(show: true),
                  titlesData: FlTitlesData(
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          return Text(
                            '৳${value.toInt()}',
                            style: TextStyle(fontSize: 5),
                          );
                        },
                      ),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          if (value.toInt() >= 0 && value.toInt() < years.length) {
                            return Text('${years[value.toInt()]}', style: TextStyle(fontSize: 12));
                          }
                          return Container(); // Return an empty container for any other values
                        },
                        interval: 1, // Optional: to set the interval between labels, if needed
                      ),
                    ),
                    topTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    rightTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                  ),
                  borderData: FlBorderData(show: true, border: Border.all(color: Colors.grey)),
                  lineBarsData: [
                    _generateLineChartBarData(yearsExpense, Colors.blue.shade900, 'Expense'),
                    _generateLineChartBarData(yearsBudget, Colors.green.shade900, 'Budget'),
                  ],
                ),
              ),
            ),
            SizedBox(height: 30), // Space between the graphs
            Text(
              'Expense & Budget Insights by Category',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 50),
            // Second Bar Graph (Category-wise Expense vs Budget)
            AspectRatio(
              aspectRatio: 2,
              child: BarChart(
                BarChartData(
                  gridData: FlGridData(show: true),
                  titlesData: FlTitlesData(
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          return Text(
                            '৳${value.toInt()}',
                            style: TextStyle(fontSize: 7),
                          );
                        },
                      ),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 60, // Increased space for category names
                        getTitlesWidget: (value, meta) {
                          if (value.toInt() >= 0 && value.toInt() < categories.length) {
                            return RotatedBox(
                              quarterTurns: 1, // Rotate the category names
                              child: Text(
                                categories[value.toInt()],
                                style: TextStyle(fontSize: 12, color: Colors.black),
                              ),
                            );
                          }
                          return Container(); // Return an empty container for any other values
                        },
                      ),
                    ),
                    topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
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

  LineChartBarData _generateLineChartBarData(List<double> data, Color color, String label) {
    return LineChartBarData(
      spots: data.asMap().entries.map((e) => FlSpot(e.key.toDouble(), e.value)).toList(),
      isCurved: true,
      color: color,
      barWidth: 3,
      isStrokeCapRound: true,
      dotData: FlDotData(show: true),
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
              borderRadius: BorderRadius.zero,
            ),
            BarChartRodData(
              toY: budgetData[i],
              color: Colors.green.shade900,
              width: 20,
              borderRadius: BorderRadius.zero,
            ),
          ],
        ),
      );
    }
    return groups;
  }
}
