import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:testapp/Models/DataModel.dart';
import '../../../Models/UserState.dart';
import 'create_budget.dart';
import 'package:testapp/features/Expense Tracking/Budgets/budget_list.dart';
import 'package:provider/provider.dart'; // Import for Provider
import 'package:testapp/backend_connections/api services/features/Expense_Tracking.dart';

class BudgetScreen extends StatefulWidget {
  const BudgetScreen({super.key});

  @override
  _BudgetScreenState createState() => _BudgetScreenState();
}

class _BudgetScreenState extends State<BudgetScreen> {
  DateTime? selectedMonth;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    selectedMonth = DateTime.now(); // Default to current month
    _fetchBudgets();
  }

  void _fetchBudgets() async {
    final dataModel = Provider.of<DataModel>(context, listen: false);
    final userState = Provider.of<UserState>(context, listen: false);
    final groupCode = userState.currentUser?.currentGroup?.groupCode;

    if (groupCode == null || groupCode.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("No current group selected")),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final budgets = await BudgetService.fetchBudgets(groupCode);
      if (!mounted) return;
      dataModel.setBudgets(budgets);
    } catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error fetching budgets: $error")),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _selectMonth(BuildContext context) async {
    final dataModel = Provider.of<DataModel>(context, listen: false);
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedMonth ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
      helpText: 'Select Month',
    );

    if (picked != null) {
      setState(() {
        selectedMonth = picked; // Update local state
      });
      dataModel.updateSelectedDate(picked); // Update DataModel
      _fetchBudgets(); // Refresh data (optional, if you want to refetch)
    }
  }

  Future<void> _renameBudget(BuildContext context, Budget budget) async {
    final newCategory = await showDialog<String>(
      context: context,
      builder: (context) {
        String newCategory = budget.category;
        return AlertDialog(
          title: const Text('Rename Budget'),
          content: TextField(
            autofocus: true,
            decoration: const InputDecoration(labelText: 'New Category'),
            onChanged: (value) {
              newCategory = value;
            },
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, newCategory),
              child: const Text('Save'),
            ),
          ],
        );
      },
    );

    if (newCategory != null && newCategory.isNotEmpty) {
      final dataModel = Provider.of<DataModel>(context, listen: false);
      await dataModel.renameBudget(budget, newCategory);
    }
  }

  @override
  Widget build(BuildContext context) {
    final dataModel = Provider.of<DataModel>(context);
    final filteredBudgets = dataModel.getBudgetsForMonth(selectedMonth);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Budgets'),
        backgroundColor: Colors.teal,
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () async {
              final newBudget = await Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const CreateBudgetScreen()),
              );
              if (newBudget != null) {
                dataModel.addBudget(newBudget);
              }
            },
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Your Budgets',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.teal.shade900,
                  ),
                ),
                GestureDetector(
                  onTap: () => _selectMonth(context),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey.shade400),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.shade300,
                          blurRadius: 10,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Text(
                          selectedMonth != null
                              ? DateFormat.yMMMM().format(selectedMonth!)
                              : 'Select Month',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey.shade800,
                          ),
                        ),
                        const SizedBox(width: 8),
                        const Icon(Icons.calendar_today, color: Colors.teal, size: 18),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: filteredBudgets.isEmpty
                ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.inbox,
                    size: 80,
                    color: Colors.teal.shade300,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No budgets found for the selected month.',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            )
                : BudgetList(
              budgets: filteredBudgets,
              onEditBudget: dataModel.addBudget,
              onDeleteBudget: (budget) async {
                await dataModel.deleteBudget(budget);
              },
              onRenameBudget: (budget) async {
                await _renameBudget(context, budget);
              },
            ),
          ),
        ],
      ),
    );
  }
}