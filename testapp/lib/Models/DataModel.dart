 import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DataModel extends ChangeNotifier {
  final List<Map<String, dynamic>> budgets = [];
  final List<Map<String, dynamic>> expenses = [];

  // Add a new budget
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

    notifyListeners(); // Notify listeners for dynamic updates
  }
  void deleteExpense(Map<String, dynamic> expense) {
    expenses.remove(expense);
    notifyListeners(); // Notify listeners for dynamic updates
  }
  void addBudget(Map<String, dynamic> budget) {
    int index = budgets.indexWhere((b) =>
    b['category'] == budget['category'] &&
        b['month'].month == budget['month'].month &&
        b['month'].year == budget['month'].year);

    if (index != -1) {
      budgets[index]['amount'] += budget['amount'];
    } else {
      budgets.add(budget);
    }

    notifyListeners(); // Notify listeners for dynamic updates
  }
  // DataModel.dart
  void deleteBudget(Map<String, dynamic> budget) {
    budgets.remove(budget);
    notifyListeners(); // Notify listeners for dynamic updates
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

  // Get expenses for a specific month -1
  List<Map<String, dynamic>> getExpensesForMonth(DateTime? month) {
    if (month == null) return [];

    return expenses.where((expense) {
      final expenseDate = expense['date'];
      return expenseDate.month == month.month && expenseDate.year == month.year;
    }).toList();
  }

  // Get budgets for a specific month -2
  List<Map<String, dynamic>> getBudgetsForMonth(DateTime? month) {
    if (month == null) return [];

    return budgets.where((budget) {
      final budgetDate = budget['month'];
      return budgetDate.month == month.month && budgetDate.year == month.year;
    }).toList();
  }

  // Get category-wise budgets for a specific month
  Map<String, double> getCategoryWiseBudgetsForSpecificMonth(DateTime? month) {
    if (month == null) return {};

    final filteredBudgets = budgets.where((budget) {
      final budgetDate = budget['month'];
      return budgetDate.month == month.month && budgetDate.year == month.year;
    });

    // Group budgets by category and sum their amounts
    Map<String, double> categoryWiseBudgets = {};
    for (var budget in filteredBudgets) {
      final category = budget['category'];
      final amount = budget['amount'] ?? 0.0;

      if (categoryWiseBudgets.containsKey(category)) {
        categoryWiseBudgets[category] = categoryWiseBudgets[category]! + amount;
      } else {
        categoryWiseBudgets[category] = amount;
      }
    }

    return categoryWiseBudgets;
  }

  Map<String, double> getCategoryWiseExpensesForSpecificMonth(DateTime? month) {
    if (month == null) return {};

    // Filter expenses for the given month
    final filteredExpenses = expenses.where((expense) {
      final expenseDate = expense['date'];
      return expenseDate.month == month.month && expenseDate.year == month.year;
    });

    // Group expenses by category and sum their amounts
    Map<String, double> categoryWiseExpenses = {};
    for (var expense in filteredExpenses) {
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

  // Get category-wise expenses for the current month
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

  // Year-wise total budgets
  double getTotalBudgetsForYear(int year) {
    return budgets
        .where((budget) => budget['month'].year == year)
        .fold(0.0, (sum, budget) => sum + budget['amount']);
  }

  // Year-wise total expenses
  double getTotalExpensesForYear(int year) {
    return expenses
        .where((expense) => expense['date'].year == year)
        .fold(0.0, (sum, expense) => sum + expense['amount']);
  }

  // Year-wise category-wise budgets
  Map<String, double> getCategoryWiseBudgetsForYear(int year) {
    final filteredBudgets = budgets.where((budget) => budget['month'].year == year);

    Map<String, double> categoryWiseBudgets = {};
    for (var budget in filteredBudgets) {
      final category = budget['category'];
      final amount = budget['amount'] ?? 0.0;

      if (categoryWiseBudgets.containsKey(category)) {
        categoryWiseBudgets[category] = categoryWiseBudgets[category]! + amount;
      } else {
        categoryWiseBudgets[category] = amount;
      }
    }

    return categoryWiseBudgets;
  }

  // Year-wise category-wise expenses
  Map<String, double> getCategoryWiseExpensesForYear(int year) {
    final filteredExpenses = expenses.where((expense) => expense['date'].year == year);

    Map<String, double> categoryWiseExpenses = {};
    for (var expense in filteredExpenses) {
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
