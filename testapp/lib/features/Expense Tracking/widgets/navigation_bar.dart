import 'package:flutter/material.dart';
import 'package:testapp/features/Expense Tracking/Budgets/budget.dart';
import 'package:testapp/features/Expense Tracking/Expenses/expense.dart';

import 'package:testapp/features/Expense Tracking/Analytics/analytics.dart';

class NavigationBarWidget extends StatelessWidget {
  const NavigationBarWidget({super.key});

  /*final String groupName;
  
  NavigationBarWidget({required this.groupName});*/
  
  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      backgroundColor: Colors.white,
      selectedItemColor: Colors.teal.shade400,
      unselectedItemColor: Colors.grey.shade600,
      elevation: 10,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.account_balance_wallet_outlined),
          label: 'Budget',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.list_alt_outlined),
          label: 'Expenses',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.bar_chart_outlined),
          label: 'Analytics',
        ),
      ],
      onTap: (index) {
        switch (index) {
          case 0:
          // Navigate to Budget Screen
           /* Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => mainHomepage()),
            );*/
            break;
          case 1:
          // Navigate to Budget Screen
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const BudgetScreen()),
            );
            break;
          case 2:
          // Navigate to Expenses Screen
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const ExpenseScreen()),
            );

            break;
          case 3:
           // Navigate to Analytics Screen
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const AnalyticsScreen()),
            );
            break;
          default:
            break;
        }
      },
    );
  }
}
