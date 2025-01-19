import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:provider/provider.dart';
import '../../../Models/DataModel.dart';

class MonthWiseAnalyzePage extends StatefulWidget {
  @override
  _MonthWiseAnalyzePageState createState() => _MonthWiseAnalyzePageState();
}
class _MonthWiseAnalyzePageState extends State<MonthWiseAnalyzePage> {
  final List<double> monthsExpense = List.filled(12, 0.0);
  final List<double> monthsBudget = List.filled(12, 0.0);
  final List<double> categoriesExpense = List.filled(7, 0.0);
  final List<double> categoriesBudget = List.filled(7, 0.0);

  @override
  Widget build(BuildContext context) {
    return Consumer<DataModel>(
      builder: (context, dataModel, child) {
        _updateGraphData(dataModel);
        return Scaffold(
          body: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Main Title
                Text(
                  'Analyzed Data',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 20),

                // Legend for line graph colors
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildLegend(
                      color: Colors.orange.shade900,
                      label: "Expense",
                    ),
                    SizedBox(width: 30),
                    _buildLegend(
                      color: Colors.purple.shade900,
                      label: "Budget",
                    ),
                  ],
                ),
                SizedBox(height: 30),

                // Title for the line graph
                Text(
                  'Monthly Expense vs Budget Analysis',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 40),

                // Line Graph
                AspectRatio(
                  aspectRatio:  2,
                  child: LineChart(
                    LineChartData(
                      gridData: FlGridData(show: true),
                      titlesData: FlTitlesData(
                        leftTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            getTitlesWidget: (value, meta) {
                              return Text('৳${value.toInt()}',
                                  style: TextStyle(fontSize: 8));
                            },
                          ),
                        ),
                        bottomTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            getTitlesWidget: (value, meta) {
                              final months = [
                                'Jan',
                                'Feb',
                                'Mar',
                                'Apr',
                                'May',
                                'Jun',
                                'Jul',
                                'Aug',
                                'Sep',
                                'Oct',
                                'Nov',
                                'Dec'
                              ];
                              return Text(
                                months[value.toInt()],
                                style: TextStyle(fontSize: 12),
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
                      borderData: FlBorderData(
                        show: true,
                        border: Border.all(color: Colors.grey),
                      ),
                      lineBarsData: [
                        _generateLineChartBarData(
                            monthsExpense, Colors.orange.shade900, 'Expense'),
                        _generateLineChartBarData(
                            monthsBudget, Colors.purple.shade900, 'Budget'),
                      ],
                    ),
                  ),
                ),

                SizedBox(height: 40),

                // Title for the bar graph
                Text(
                  'Expense & Budget Insights by Category',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 50),

                // Bar Graph
                AspectRatio(
                  aspectRatio:2,
                  child: BarChart(
                    BarChartData(
                      gridData: FlGridData(show: true),
                      titlesData: FlTitlesData(
                        leftTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            getTitlesWidget: (value, meta) {
                              return Text('৳${value.toInt()}',
                                  style: TextStyle(fontSize: 7));
                            },
                          ),
                        ),
                        bottomTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            reservedSize: 60,
                            getTitlesWidget: (value, meta) {
                              final categories = [
                                'Groceries',
                                'Shopping',
                                'Education',
                                'Transport',
                                'Bills',
                                'Medical',
                                'Others'
                              ];
                              return RotatedBox(
                                quarterTurns: 1,
                                child: Text(
                                  categories[value.toInt()],
                                  style: TextStyle(
                                      fontSize: 12, color: Colors.black),
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
                      borderData: FlBorderData(
                        show: true,
                        border: Border.all(color: Colors.grey),
                      ),
                      barGroups: _generateBarChartGroups(
                          categoriesExpense, categoriesBudget),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildLegend({required Color color, required String label}) {
    return Row(
      children: [
        Container(width: 20, height: 20, color: color),
        SizedBox(width: 8),
        Text(label, style: TextStyle(fontSize: 14)),
      ],
    );
  }

  LineChartBarData _generateLineChartBarData(
      List<double> data, Color color, String label) {
    return LineChartBarData(
      spots: data
          .asMap()
          .entries
          .map((e) => FlSpot(e.key.toDouble(), e.value))
          .toList(),
      isCurved: true,
      color: color,
      barWidth: 3,
      isStrokeCapRound: true,
      dotData: FlDotData(show: true),
      belowBarData: BarAreaData(
        show: true,
        gradient: LinearGradient(
          colors: [
            color.withOpacity(0.3),
            Colors.transparent,
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
    );
  }

  List<BarChartGroupData> _generateBarChartGroups(
      List<double> expenseData, List<double> budgetData) {
    List<BarChartGroupData> groups = [];
    for (int i = 0; i < expenseData.length; i++) {
      groups.add(
        BarChartGroupData(
          x: i,
          barRods: [
            BarChartRodData(
              toY: expenseData[i],
              color: Colors.orange.shade900,
              width: 20,
              borderRadius: BorderRadius.zero, // Ensure rectangular bars
            ),
            BarChartRodData(
              toY: budgetData[i],
              color: Colors.purple.shade900,
              width: 20,
              borderRadius: BorderRadius.zero, // Ensure rectangular bars
            ),
          ],
        ),
      );
    }
    return groups;
  }


  void _updateGraphData(DataModel dataModel) {
    for (int i = 0; i < 12; i++) {
      final month = DateTime(DateTime.now().year, i + 1);
      monthsExpense[i] = dataModel
          .getExpensesForMonth(month)
          .fold(0.0, (sum, expense) => sum + expense['amount']);
      monthsBudget[i] = dataModel
          .getBudgetsForMonth(month)
          .fold(0.0, (sum, budget) => sum + budget['amount']);
    }

    Map<String, double> yearlyExpenses = {};
    Map<String, double> yearlyBudgets = {};

    for (int i = 0; i < 12; i++) {
      final month = DateTime(DateTime.now().year, i + 1);
      final monthlyExpenses =
      dataModel.getCategoryWiseExpensesForSpecificMonth(month);
      final monthlyBudgets =
      dataModel.getCategoryWiseBudgetsForSpecificMonth(month);

      monthlyExpenses.forEach((category, amount) {
        yearlyExpenses[category] = (yearlyExpenses[category] ?? 0) + amount;
      });

      monthlyBudgets.forEach((category, amount) {
        yearlyBudgets[category] = (yearlyBudgets[category] ?? 0) + amount;
      });
    }

    final categories = [
      'Groceries',
      'Shopping',
      'Education',
      'Transport',
      'Bills',
      'Medical',
      'Others'
    ];

    for (int i = 0; i < categories.length; i++) {
      categoriesExpense[i] = yearlyExpenses[categories[i]] ?? 0.0;
      categoriesBudget[i] = yearlyBudgets[categories[i]] ?? 0.0;
    }
  }
}
