 import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class MonthWiseAnalyzePage extends StatefulWidget {
  @override
  _MonthWiseAnalyzePageState createState() => _MonthWiseAnalyzePageState();
}

class _MonthWiseAnalyzePageState extends State<MonthWiseAnalyzePage> {
  final List<double> monthsExpense = [20, 30, 15, 40, 50, 60, 25, 35, 45, 55, 65, 0];
  final List<double> monthsBudget = [30, 40, 25, 45, 55, 65, 35, 45, 55, 60, 70, 0];
  final List<double> categoriesExpense = [50, 30, 40, 60, 20, 30, 10];
  final List<double> categoriesBudget = [60, 35, 45, 70, 25, 35, 15];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Main Title
            Text(
              'Analyzed Data',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20),

            // Explanation about line colors
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildLegend(color: Colors.orange.shade900, label: "Expense"),
                SizedBox(width: 30),
                _buildLegend(color: Colors.purple.shade900, label: "Budget"),
              ],
            ),
            SizedBox(height: 30),

            // Title for Line Graph (Monthly Expense vs Budget)
            Text(
              'Monthly Expense vs Budget Analysis',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 40),

            // Line Graph (Month-wise Expense vs Budget)
            AspectRatio(
              aspectRatio: 1.75,
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
                          final months = [
                            'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
                          ];
                          return Text(
                            months[value.toInt()],
                            style: TextStyle(fontSize: 12),
                          );
                        },
                      ),
                    ),
                    topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  ),
                  borderData: FlBorderData(
                    show: true,
                    border: Border.all(color: Colors.grey),
                  ),
                  lineBarsData: [
                    _generateLineChartBarData(monthsExpense, Colors.orange.shade900, 'Expense'),
                    _generateLineChartBarData(monthsBudget, Colors.purple.shade900, 'Budget'),
                  ],
                ),
              ),
            ),

            SizedBox(height: 40),

            // Title for Bar Graph (Category-wise Expense vs Budget)
            Text(
              'Expense & Budget Insights by Category',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 50),

            // Bar Graph (Category-wise Expense vs Budget)
            AspectRatio(
              aspectRatio: 1.75,
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
                        reservedSize: 60,
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
                    topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  ),
                  borderData: FlBorderData(
                    show: true,
                    border: Border.all(color: Colors.grey),
                  ),
                  barGroups: _generateBarChartGroups(categoriesExpense, categoriesBudget),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLegend({required Color color, required String label}) {
    return Row(
      children: [
        Container(width: 20, height: 20, color: color),
        SizedBox(width: 8),
        Text(
          label,
          style: TextStyle(fontSize: 14),
        ),
      ],
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
      belowBarData: BarAreaData(
        show: true,
        gradient: LinearGradient(
          colors: [
            color.withOpacity(0.3), // Faded shadow color
            Colors.transparent,    // Gradual fade to transparent
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
    );
  }


  List<BarChartGroupData> _generateBarChartGroups(List<double> expenseData, List<double> budgetData) {
    List<BarChartGroupData> groups = [];
    for (int i = 0; i < expenseData.length; i++) {
      groups.add(
        BarChartGroupData(
          x: i,
          barRods: [
            // Expense bar with shadow
            BarChartRodData(
              toY: expenseData[i],
              color: Colors.orange.shade900,
              width: 20,
              borderRadius: BorderRadius.zero,
              rodStackItems: [
                BarChartRodStackItem(0, expenseData[i], Colors.orange.withOpacity(0.3)),
              ],
            ),
            // Budget bar with shadow
            BarChartRodData(
              toY: budgetData[i],
              color: Colors.purple.shade900,
              width: 20,
              borderRadius: BorderRadius.zero,
              rodStackItems: [
                BarChartRodStackItem(0, budgetData[i], Colors.purple.withOpacity(0.9)),
              ],
            ),
          ],
        ),
      );
    }
    return groups;
  }

}
