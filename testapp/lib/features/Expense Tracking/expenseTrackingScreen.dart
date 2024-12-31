import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:testapp/features/Expense Tracking/widgets/summary_container.dart';
import 'package:testapp/features/Expense Tracking/widgets/expense_pie_chart.dart';
import 'package:testapp/features/Expense Tracking/widgets/category_description_list.dart';
import 'package:testapp/features/Expense Tracking/widgets/navigation_bar.dart';
import 'package:testapp/features/Expense Tracking/Budgets/budget.dart';
import 'package:testapp/features/Expense Tracking/Expenses/add_expense.dart';
import 'package:testapp/Models/DataModel.dart';
import 'package:testapp/features/mainHomepage.dart';

class ExpenseTrackingScreen extends StatelessWidget {
  //final String groupName;

  //ExpenseTrackingScreen({required this.groupName});

  @override
  Widget build(BuildContext context) {
    final dataModel = Provider.of<DataModel>(context);

    // Calculate dynamic values
    final budgets = dataModel.budgets;
    final expenses = dataModel.expenses;
    double totalBudget = budgets.fold(0.0, (sum, b) => sum + b['amount']);
    double totalSpent = budgets.fold(0.0, (sum, b) => sum + b['spent']);
    double remaining = totalBudget - totalSpent;

    return Scaffold(
      appBar: AppBar(
       // leading: null, // Removes the default back button
        //automaticallyImplyLeading: false, // Ensures no back button is added
        title: Text(
          'Expense Tracking',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        backgroundColor: Colors.teal.shade400,
        elevation: 5,
      ),
      body: Column(
        children: [
          // Always show the SummaryContainer
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: SummaryContainer(
              totalBudget: totalBudget,
              totalSpent: totalSpent,
              remaining: remaining,
            ),
          ),

          // "Expense Overview" header
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Expenses Overview',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.grey.shade800,
              ),
            ),
          ),

          // Conditional rendering based on budgets and expenses
          if (budgets.isEmpty) ...[
            Expanded(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.account_balance_wallet_outlined,
                      size: 80,
                      color: Colors.grey.shade400,
                    ),
                    SizedBox(height: 16),
                    Text(
                      "You haven’t set a budget yet.",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey.shade600,
                      ),
                    ),
                    SizedBox(height: 8),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.teal.shade400,
                        foregroundColor: Colors.white,
                        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        elevation: 5,
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => BudgetScreen()),
                        );
                      },
                      child: Text("Add Budget"),
                    ),
                  ],
                ),
              ),
            ),
          ] else if (expenses.isEmpty) ...[
            Expanded(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.pie_chart,
                      size: 80,
                      color: Colors.grey.shade400,
                    ),
                    SizedBox(height: 16),
                    Text(
                      "No expense to display.",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey.shade600,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      "Start by adding your first expense!",
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade500,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 16),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.teal.shade400,
                        foregroundColor: Colors.white,
                        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        elevation: 5,
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => AddExpenseScreen()),
                        );
                      },
                      child: Text("Add Expense"),
                    ),
                  ],
                ),
              ),
            ),
          ] else ...[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: ExpensePieChart(
                dataModel: dataModel,
              ),
            ),
            Expanded(
              child: CategoryDescriptionList(
                dataModel: dataModel,
              ),
            ),
          ],
        ],
      ),
      bottomNavigationBar: NavigationBarWidget(),
    );
  }
}
