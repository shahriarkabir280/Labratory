import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:testapp/features/Expense Tracking/widgets/summary_container.dart';
import 'package:testapp/features/Expense Tracking/widgets/expense_pie_chart.dart';
import 'package:testapp/features/Expense Tracking/widgets/category_description_list.dart';
import 'package:testapp/features/Expense Tracking/widgets/navigation_bar.dart';
import 'package:testapp/features/Expense Tracking/Budgets/budget.dart';
import 'package:testapp/features/Expense Tracking/Expenses/add_expense.dart';
import 'package:testapp/Models/DataModel.dart';
import 'package:testapp/Models/UserState.dart';
import 'package:testapp/features/HomepageHandling/mainHomepage.dart';
import '../../backend_connections/api services/features/Expense_Tracking.dart';

class ExpenseTrackingScreen extends StatefulWidget {
  @override
  _ExpenseTrackingScreenState createState() => _ExpenseTrackingScreenState();
}

class _ExpenseTrackingScreenState extends State<ExpenseTrackingScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final dataModel = Provider.of<DataModel>(context, listen: false);
      final now = DateTime.now();
      dataModel.updateSelectedDate(DateTime(now.year, now.month, 1));
      Future.microtask(() => _fetchData(context));
    });
  }

  Future<void> _fetchData(BuildContext context) async {
    final groupCode = Provider.of<UserState>(context, listen: false)
        .currentUser?.currentGroup?.groupCode;
    if (groupCode == null) return;

    try {
      final budgets = await BudgetService.fetchBudgets(groupCode);
      if (!mounted) return;

      final expenses = await BudgetService.fetchExpenses(groupCode);
      if (!mounted) return;

      final dataModel = Provider.of<DataModel>(context, listen: false);
      dataModel.setBudgets(budgets);
      dataModel.setExpenses(expenses);
    } catch (e) {
      if (!mounted) return;
      print('Error fetching data: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error loading data. Please try again.')),
      );
    }
  }

  Future<void> _selectMonth(BuildContext context, DataModel dataModel) async {
    final currentDate = dataModel.selectedDate;

    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Select Month'),
          content: SizedBox(
            width: 300,
            height: 300,
            child: CalendarDatePicker(
              initialDate: currentDate,
              firstDate: DateTime(2020),
              lastDate: DateTime(2030),
              initialCalendarMode: DatePickerMode.year,
              onDateChanged: (DateTime date) {
                final newDate = DateTime(currentDate.year, date.month, 1);
                dataModel.updateSelectedDate(newDate);
                _fetchData(context);
                Navigator.of(context).pop();
              },
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<DataModel>(
      builder: (context, dataModel, child) {
        final budgets = dataModel.getBudgetsForMonth(dataModel.selectedDate);
        final expenses = dataModel.getExpensesForMonth(dataModel.selectedDate);
        final totalBudget = budgets.fold(0.0, (sum, budget) => sum + budget.amount);
        final totalSpent = expenses.fold(0.0, (sum, expense) => sum + expense.amount);
        final remaining = totalBudget - totalSpent;

        return Scaffold(
          appBar: AppBar(
            title: Text('Expense Tracking'),
            backgroundColor: Colors.teal.shade400,
            actions: [
              Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Text(
                    DateFormat('MMMM yyyy').format(dataModel.selectedDate),
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              IconButton(
                icon: Icon(Icons.calendar_today),
                onPressed: () => _selectMonth(context, dataModel),
              ),
            ],
          ),
          body: RefreshIndicator(
            onRefresh: () => _fetchData(context),
            child: SingleChildScrollView(
              physics: AlwaysScrollableScrollPhysics(),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: SummaryContainer(
                      totalBudget: totalBudget,
                      totalSpent: totalSpent,
                      remaining: remaining,
                    ),
                  ),
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
                  budgets.isEmpty
                      ? Center(child: Text("No budgets available."))
                      : expenses.isEmpty
                      ? Center(child: Text("No expenses recorded."))
                      : Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: ExpensePieChart(selectedDate: dataModel.selectedDate),
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.5,
                        child: CategoryDescriptionList(
                          dataModel: dataModel,
                          selectedDate: dataModel.selectedDate,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          bottomNavigationBar: NavigationBarWidget(),
        );
      },
    );
  }
}
