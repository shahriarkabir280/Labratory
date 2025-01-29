import 'package:flutter/material.dart';

import '../backend_connections/api services/features/Expense_Tracking.dart';

class Budget {
  final String? id;
  final String category;
  final DateTime month;
  double amount;
  double spent;
  final String groupCode;

  Budget({
    this.id,
    required this.category,
    required this.month,
    required this.amount,
    this.spent = 0.0,
    required this.groupCode,
  });

  factory Budget.fromJson(Map<String, dynamic> json) {
    return Budget(
      id: json['id'],
      category: json['category'],
      month: DateTime.parse(json['month']),
      amount: json['amount'],
      spent: json['spent'] ?? 0.0,
      groupCode: json['groupCode'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,  // Only include id if it's not null
      'category': category,
      'month': month.toIso8601String(),
      'amount': amount,
      'spent': spent,
      'groupCode': groupCode,
    };
  }
}

class Expense {
  final String? id;
  final String category;
  final DateTime date;
  final double amount;
  final String groupCode;

  Expense({
    this.id,
    required this.category,
    required this.date,
    required this.amount,
    required this.groupCode
  });

  factory Expense.fromJson(Map<String, dynamic> json) {
    return Expense(
      id: json['id'],
      category: json['category'],
      date: DateTime.parse(json['date']),
      amount: json['amount'],
      groupCode: json['groupCode'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,  // Only include id if it's not null
      'category': category,
      'date': date.toIso8601String(),
      'amount': amount,
      'groupCode': groupCode,
    };
  }
}

class DataModel extends ChangeNotifier {
  List<Expense> expenses = [];
  List<Budget> budgets = [];
//date time
  DateTime _selectedDate = DateTime.now();

  DateTime get selectedDate => _selectedDate;

  void updateSelectedDate(DateTime date) {
    _selectedDate = date;
    notifyListeners();
  }


  //datetime
  List<Budget> getBudgets() => budgets;

  void setBudgets(List<Budget> newBudgets) {
    budgets = newBudgets;
    notifyListeners();
  }

  void setExpenses(List<Expense> newExpenses) {
    expenses = newExpenses;
    notifyListeners();
  }

  void addExpense(Expense expense) {
    expenses.add(expense);

    for (var budget in budgets) {
      if (budget.category == expense.category &&
          budget.month.month == expense.date.month &&
          budget.month.year == expense.date.year) {
        budget.spent += expense.amount;
        break;
      }
    }
    notifyListeners();
  }

  void deleteExpense(Expense expense) {
    expenses.remove(expense);
    notifyListeners();
  }

  void addBudget(Budget budget) {
    int index = budgets.indexWhere((b) =>
    b.category == budget.category &&
        b.month.month == budget.month.month &&
        b.month.year == budget.month.year);

    if (index != -1) {
      budgets[index].amount = budget.amount;
    } else {
      budgets.add(budget);
    }

    notifyListeners();
  }

  // void deleteBudget(Budget budget) {
  //   budgets.remove(budget);
  //   notifyListeners();
  // }

  double getTotalBudget() {
    final now = DateTime.now();
    return budgets
        .where((budget) =>
    budget.month.month == now.month && budget.month.year == now.year)
        .fold(0.0, (sum, budget) => sum + budget.amount);
  }

  double getTotalExpenses() {
    final now = DateTime.now();
    return expenses
        .where((expense) =>
    expense.date.month == now.month && expense.date.year == now.year)
        .fold(0.0, (sum, expense) => sum + expense.amount);
  }

  double getRemainingBudget(String category) {
    final now = DateTime.now();
    final budget = budgets.firstWhere(
          (b) =>
      b.category == category &&
          b.month.month == now.month &&
          b.month.year == now.year,
      orElse: () => Budget(category: category, month: now, amount: 0.0, id: '', groupCode: ''),
    );
    return budget.amount - budget.spent;
  }

  List<Budget> getCategoryBudgets() {
    final now = DateTime.now();
    return budgets
        .where((budget) =>
    budget.month.month == now.month && budget.month.year == now.year)
        .toList();
  }

  List<Expense> getExpensesForMonth(DateTime? month) {
    if (month == null) return [];
    return expenses
        .where((expense) =>
    expense.date.month == month.month && expense.date.year == month.year)
        .toList();
  }


  List<Budget> getBudgetsForMonth(DateTime? selectedMonth) {
    if (selectedMonth == null) return budgets; // Return all budgets if no month is selected
    return budgets.where((budget) {
      return budget.month.year == selectedMonth.year && budget.month.month == selectedMonth.month;
    }).toList();
  }

  Map<String, double> getCategoryWiseExpensesForMonth(DateTime? month) {
    if (month == null) return {};
    final filteredExpenses = getExpensesForMonth(month);

    return {
      for (var expense in filteredExpenses)
        expense.category: filteredExpenses
            .where((e) => e.category == expense.category)
            .fold(0.0, (sum, e) => sum + e.amount),
    };
  }

  double getTotalBudgetsForYear(int year) {
    return budgets
        .where((budget) => budget.month.year == year)
        .fold(0.0, (sum, budget) => sum + budget.amount);
  }

  double getTotalExpensesForYear(int year) {
    return expenses
        .where((expense) => expense.date.year == year)
        .fold(0.0, (sum, expense) => sum + expense.amount);
  }

  Map<String, double> getCategoryWiseBudgetsForYear(int year) {
    final filteredBudgets = budgets.where((budget) => budget.month.year == year);

    return {
      for (var budget in filteredBudgets)
        budget.category: filteredBudgets
            .where((b) => b.category == budget.category)
            .fold(0.0, (sum, b) => sum + b.amount),
    };
  }

  Map<String, double> getCategoryWiseExpensesForYear(int year) {
    final filteredExpenses =
    expenses.where((expense) => expense.date.year == year);

    return {
      for (var expense in filteredExpenses)
        expense.category: filteredExpenses
            .where((e) => e.category == expense.category)
            .fold(0.0, (sum, e) => sum + e.amount),
    };
  }

  // Future<void> deleteBudget(Budget budget) async {
  //   if (budget.id == null) return;
  //
  //   final success = await BudgetService.deleteBudget(budget.id!);
  //   if (success) {
  //     budgets.remove(budget);
  //     notifyListeners();
  //   }
  // }
  Future<void> deleteBudget(Budget budget) async {
    if (budget.id == null) {
      print('Budget ID is null');
      return;
    }

    print('Deleting budget with ID: ${budget.id}');
    final success = await BudgetService.deleteBudget(budget.id!);
    if (success) {
      print('Budget deleted successfully');
      budgets.remove(budget);
      notifyListeners();
    } else {
      print('Failed to delete budget on the server');
    }
  }

  Future<void> renameBudget(Budget budget, String newCategory) async {
    if (budget.id == null) return;
  
    final success = await BudgetService.renameBudget(budget.id!, newCategory);
    if (success) {
      int index = budgets.indexOf(budget);
      if (index != -1) {
        budgets[index] = Budget(
          id: budget.id,
          category: newCategory,
          month: budget.month,
          amount: budget.amount,
          spent: budget.spent,
          groupCode: budget.groupCode,
        );
        notifyListeners();
      }
    }
  }
}