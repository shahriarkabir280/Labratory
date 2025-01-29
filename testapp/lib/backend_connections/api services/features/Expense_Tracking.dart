import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:testapp/Models/DataModel.dart';

class BudgetService {
  static const String baseUrl='https://famnest.onrender.com';

  // BudgetService({required this.baseUrl});

  /// Uploads a budget to the server
  static Future<bool> uploadBudget(Budget budget) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/budget'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(budget.toJson()),
      );

      if (response.statusCode == 200) {
        return true;
      } else {
        print('Failed to upload budget: ${response.body}');
        return false;
      }
    } catch (e) {
      print('Error uploading budget: $e');
      return false;
    }
  }

  /// Uploads an expense to the server
  static Future<bool> uploadExpense(Expense expense) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/expense'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(expense.toJson()),
      );

      if (response.statusCode == 200) {
        return true;
      } else {
        print('Failed to upload expense: ${response.body}');
        return false;
      }
    } catch (e) {
      print('Error uploading expense: $e');
      return false;
    }
  }

  /*
  /// Fetches all budgets for a given group code
  static Future<List<Budget>> fetchBudgets(String groupCode) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/budget?groupCode=$groupCode'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        print("Budgets fetched: $data");
        return data.map((json) => Budget.fromJson(json)).toList();
      } else {
        print("Failed to fetch budgets: ${response.body}");
        throw Exception("Error: ${response.body}");
      }
    } catch (e) {
      print('Error fetching budgets: $e');
      return [];
    }
  }
*/
  // Flutter code
  // static Future<List<Budget>> fetchBudgets(String groupCode) async {
  //   try {
  //     final encodedGroupCode = Uri.encodeComponent(groupCode); // Single encode
  //     print('Encoded group code: $encodedGroupCode');
  //
  //     final response = await http.get(
  //       Uri.parse('$baseUrl/budget?groupCode=$encodedGroupCode'),
  //       headers: {'Content-Type': 'application/json'},
  //     );
  //
  //     print('Response status: ${response.statusCode}');
  //     print('Response body: ${response.body}');
  //
  //     if (response.statusCode == 200) {
  //       final List<dynamic> jsonData = json.decode(response.body);
  //       return jsonData.map((json) => Budget.fromJson(json)).toList();
  //     } else if (response.statusCode == 404) {
  //       // Handle 404 (No data found)
  //       return [];
  //     } else {
  //       throw Exception('Failed to fetch budgets: ${response.body}');
  //     }
  //   } catch (e) {
  //     print('Error fetching budgets: $e');
  //     rethrow;
  //   }
  // }

  static Future<List<Budget>> fetchBudgets(String groupCode) async {
    try {
      // Single encode the groupCode
      final encodedGroupCode = Uri.encodeComponent(groupCode);
      print('Encoded group code: $encodedGroupCode');

      final response = await http.get(
        Uri.parse('$baseUrl/budget?groupCode=$encodedGroupCode'),
        headers: {'Content-Type': 'application/json'},
      );

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final List<dynamic> jsonData = json.decode(response.body);
        return jsonData.map((json) => Budget.fromJson(json)).toList();
      } else if (response.statusCode == 404) {
        // Handle 404 (No data found)
        return [];
      } else {
        throw Exception('Failed to fetch budgets: ${response.body}');
      }
    } catch (e) {
      print('Error fetching budgets: $e');
      rethrow;
    }
  }

  static Future<List<Expense>> fetchExpenses(String groupCode) async {
    try {
      final encodedGroupCode = Uri.encodeComponent(groupCode); // Single encode
      print('Encoded group code for expenses: $encodedGroupCode');

      final response = await http.get(
        Uri.parse('$baseUrl/expense?groupCode=$encodedGroupCode'),
        headers: {'Content-Type': 'application/json'},
      );

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final List<dynamic> jsonData = json.decode(response.body);
        return jsonData.map((json) => Expense.fromJson(json)).toList();
      } else if (response.statusCode == 404) {
        // Handle 404 (No data found)
        return [];
      } else {
        throw Exception('Failed to fetch expenses: ${response.body}');
      }
    } catch (e) {
      print('Error fetching expenses: $e');
      rethrow;
    }
  }
  // static Future<List<Budget>> fetchBudgets(String groupCode) async {
  //   try {
  //     final response = await http.get(
  //       Uri.parse('$baseUrl/get-budgets/$groupCode'),
  //       headers: {'Content-Type': 'application/json'},
  //     );
  //
  //     if (response.statusCode == 200) {
  //       final List<dynamic> data = jsonDecode(response.body);
  //       print("Budgets fetched: $data");
  //       return data.map((json) => Budget.fromJson(json)).toList();
  //     } else {
  //       print("Failed to fetch budgets: ${response.body}");
  //       throw Exception("Error: ${response.body}");
  //     }
  //   } catch (e) {
  //     print('Error fetching budgets: $e');
  //     return [];
  //   }
  // }
  // static Future<List<Budget>> fetchBudgets(String groupCode) async {
  //   try {
  //     final response = await http.get(
  //       Uri.parse('$baseUrl/get-budgets/$groupCode'),
  //       headers: {'Content-Type': 'application/json'},
  //     );
  //
  //     if (response.statusCode == 200) {
  //       final List<dynamic> data = jsonDecode(response.body);
  //       return data.map((json) => Budget.fromJson(json)).toList();
  //     } else {
  //       throw Exception("Error: ${response.body}");
  //     }
  //   } catch (e) {
  //     print('Error fetching budgets: $e');
  //     return [];
  //   }
  // }

  // static Future<List<Expense>> fetchExpenses(String groupCode) async {
  //   try {
  //     // Double encode to handle special characters
  //     final encodedGroupCode = Uri.encodeComponent(Uri.encodeComponent(groupCode));
  //     print('Encoded group code for expenses: $encodedGroupCode');
  //
  //     final response = await http.get(
  //       Uri.parse('$baseUrl/expense?groupCode=$encodedGroupCode'),
  //       headers: {'Content-Type': 'application/json'},
  //     );
  //
  //     print('Response status: ${response.statusCode}');
  //     print('Response body: ${response.body}');
  //
  //     if (response.statusCode == 200) {
  //       final List<dynamic> jsonData = json.decode(response.body);
  //       return jsonData.map((json) => Expense.fromJson(json)).toList();
  //     } else {
  //       throw Exception('Failed to fetch expenses: ${response.body}');
  //     }
  //   } catch (e) {
  //     print('Error fetching expenses: $e');
  //     rethrow;
  //   }
  // }

  static Future<bool> deleteBudget(String budgetId) async {
    try {
      final response = await http.delete(
        Uri.parse('$baseUrl/budget/$budgetId'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        return true;
      } else {
        print('Failed to delete budget: ${response.body}');
        return false;
      }
    } catch (e) {
      print('Error deleting budget: $e');
      return false;
    }
  }

  /// Renames a budget on the server
  static Future<bool> renameBudget(String budgetId, String newCategory) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/budget/$budgetId'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'category': newCategory}),
      );

      if (response.statusCode == 200) {
        return true;
      } else {
        print('Failed to rename budget: ${response.body}');
        return false;
      }
    } catch (e) {
      print('Error renaming budget: $e');
      return false;
    }
  }

}