import 'package:flutter/material.dart';
import 'month_wise_analysis.dart'; // Adjust path if needed
import 'year_wise_analysis.dart'; // Adjust path if needed

class AnalyticsScreen extends StatelessWidget {
  const AnalyticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2, // We have two tabs: Month-wise and Year-wise analysis
      child: Scaffold(
        appBar: AppBar(
          toolbarHeight: 40,
          title: const Text(
            'Analytics',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
          backgroundColor: Colors.teal,
          bottom: const TabBar(
            tabs: [
              Tab(
                icon: Icon(Icons.calendar_month),
                text: 'Month-wise',
              ),
              Tab(
                icon: Icon(Icons.calendar_today),
                text: 'Year-wise',
              ),
            ],
          ),
        ),
        body: const Padding(
          padding: EdgeInsets.all(16.0),
          child: TabBarView(
            children: [
              // Month-wise Analysis Page
              MonthWiseAnalyzePage(), // Ensure this class is properly defined

              // Year-wise Analysis Page
              YearWiseAnalysisPage(), // Ensure this class is properly defined
            ],
          ),
        ),
      ),
    );
  }
}
