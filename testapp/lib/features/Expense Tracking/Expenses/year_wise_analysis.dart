import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class YearWiseAnalysisPage extends StatelessWidget {
  final List<double> yearsExpense = [250, 300, 350, 400, 450]; // Yearly expenses
  final List<double> yearsBudget = [280, 320, 370, 420, 460]; // Yearly budgets
  final List<double> categoriesExpense = [50, 30, 40, 60, 20, 30, 10];
  final List<double> categoriesBudget = [60, 35, 45, 70, 25, 35, 15];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(10.0),
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
                            style: TextStyle(fontSize: 12),
                          );
                        },
                      ),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          final years = ['2020', '2021', '2022', '2023', '2024'];
                          if (value.toInt() >= 0 && value.toInt() < years.length) {
                            return Text(years[value.toInt()], style: TextStyle(fontSize: 12));
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
                            style: TextStyle(fontSize: 12),
                          );
                        },
                      ),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 60, // Increased space for category names
                        getTitlesWidget: (value, meta) {
                          final categories = [
                            'Groceries', 'Shopping', 'Education', 'Transport', 'Bills', 'Medical', 'Others'
                          ];
                          return RotatedBox(
                            quarterTurns: 1, // Rotate the category names
                            child: Text(
                              categories[value.toInt()],
                              style: TextStyle(fontSize: 12, color: Colors.black),
                            ),
                          );
                        },
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
