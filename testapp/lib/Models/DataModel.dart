import 'package:flutter/material.dart';
import 'package:intl/intl.dart';


class DataModel extends ChangeNotifier {
  final List<Map<String, dynamic>> budgets = [];
  final List<Map<String, dynamic>> expenses = [];

  // Add a new budget
  void addBudget(Map<String, dynamic> budget) {
    int index = budgets.indexWhere((b) =>
    b['category'] == budget['category'] &&
        b['month'].month == budget['month'].month &&
        b['month'].year == budget['month'].year
    );

    if (index != -1) {
      // If the budget for the category and month exists, update it
      budgets[index]['amount'] += budget['amount'];
    } else {
      // Otherwise, add a new budget
      budgets.add(budget);
    }
    notifyListeners();
  }

  // Add a new expense
  void addExpense(Map<String, dynamic> expense) {
    expenses.add(expense);

    // Deduct the expense from the relevant budget
    for (var budget in budgets) {
      if (budget['category'] == expense['category'] &&
          budget['month'].month == expense['date'].month &&
          budget['month'].year == expense['date'].year) {
        budget['spent'] += expense['amount'];
      }
    }
    notifyListeners();
  }

  // Calculate the total budget for the current month
  double getTotalBudget() {
    final now = DateTime.now();
    return budgets
        .where((budget) =>
    budget['month'].month == now.month &&
        budget['month'].year == now.year)
        .fold(0.0, (sum, budget) => sum + budget['amount']);
  }

  // Calculate the total expenses for the current month
  double getTotalExpenses() {
    final now = DateTime.now();
    return budgets
        .where((budget) =>
    budget['month'].month == now.month &&
        budget['month'].year == now.year)
        .fold(0.0, (sum, budget) => sum + budget['spent']);
  }

  // Get remaining budget for a specific category for the current month
  double getRemainingBudget(String category) {
    final now = DateTime.now();
    final budget = budgets.firstWhere(
          (b) =>
      b['category'] == category &&
          b['month'].month == now.month &&
          b['month'].year == now.year,
      orElse: () => {},
    );

    if (budget.isEmpty) return 0.0;

    return budget['amount'] - budget['spent'];
  }

  // Get category-wise budgets for the current month
  List<Map<String, dynamic>> getCategoryBudgets() {
    final now = DateTime.now();
    return budgets
        .where((budget) =>
    budget['month'].month == now.month &&
        budget['month'].year == now.year)
        .toList();
  }

  // Get expenses for a specific month
  List<Map<String, dynamic>> getExpensesForMonth(DateTime? month) {
    if (month == null) return [];

    return expenses.where((expense) {
      final expenseDate = expense['date'];
      return expenseDate.month == month.month && expenseDate.year == month.year;
    }).toList();
  }

  Map<String, double> getCategoryWiseExpensesForCurrentMonth() {
    final now = DateTime.now();

    // Filter expenses for the current month
    final currentMonthExpenses = expenses.where((expense) {
      final date = expense['date'];
      return date.month == now.month && date.year == now.year;
    });

    // Group expenses by category and sum their amounts
    Map<String, double> categoryWiseExpenses = {};
    for (var expense in currentMonthExpenses) {
      final category = expense['category'];
      final amount = expense['amount'] ?? 0.0;

      if (categoryWiseExpenses.containsKey(category)) {
        categoryWiseExpenses[category] = categoryWiseExpenses[category]! + amount;
      } else {
        categoryWiseExpenses[category] = amount;
      }
    }

    return categoryWiseExpenses;
  }


}


