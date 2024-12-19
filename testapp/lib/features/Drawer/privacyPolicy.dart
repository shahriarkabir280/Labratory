import 'package:flutter/material.dart';

class Privacy extends StatelessWidget {
  const Privacy({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.teal,
        title: const Text(
          'Privacy Policy',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
        ),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Privacy Policy',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.teal,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            _buildSectionTitle('**Last Updated: December 10, 2024**'),
            _buildText(
              'Welcome to FamNest! This Privacy Policy outlines how we handle your personal information when you use the FamNest app. '
                  'By accessing or using our services, you consent to the terms outlined here.\n\n',
            ),
            _buildDivider(),
            _buildSectionTitle('1. Information Collection'),
            _buildText(
              'We collect information to provide better services to our users. This includes:\n'
                  '- Personal data provided during account creation, such as name, email, and family role.\n'
                  '- Data related to family activities, such as events, expenses, and shared memories.\n'
                  '- Usage information, such as app interactions and preferences.\n\n',
            ),
            _buildDivider(),
            _buildSectionTitle('2. Use of Collected Information'),
            _buildText(
              'We use the collected data to:\n'
                  '- Enhance and personalize your app experience.\n'
                  '- Provide features like shared calendars, financial tracking, and secure storage.\n'
                  '- Improve app functionality through analytics.\n'
                  '- Communicate important updates or changes to our services.\n\n',
            ),
            _buildDivider(),
            _buildSectionTitle('3. Data Sharing and Security'),
            _buildText(
              'Your data is shared only in the following scenarios:\n'
                  '- With your family members as part of the shared platform features.\n'
                  '- With trusted third parties to enable app functionality (e.g., cloud storage services).\n'
                  '- When required by law or to prevent fraud or harm.\n\n'
                  'We implement industry-standard security measures to protect your data from unauthorized access or disclosure.\n\n',
            ),
            _buildDivider(),
            _buildSectionTitle('4. User Rights'),
            _buildText(
              'As a user, you have the right to:\n'
                  '- Access and update your personal data through the app.\n'
                  '- Request the deletion of your account and associated data.\n'
                  '- Opt-out of non-essential data processing, such as analytics.\n\n'
                  'To exercise these rights, contact us at support@famnest.com.\n\n',
            ),
            _buildDivider(),
            _buildSectionTitle('5. Changes to Privacy Policy'),
            _buildText(
              'We may update this Privacy Policy periodically. Any significant changes will be communicated through the app. Continued use of FamNest after changes '
                  'indicates your acceptance of the updated terms.\n\n',
            ),
            _buildDivider(),
            _buildSectionTitle('6. Contact Us'),
            _buildText(
              'For questions, concerns, or feedback regarding this Privacy Policy or our data practices, please reach out to us at support@famnest.com.\n\n',
            ),
            _buildDivider(),
            _buildText(
              'By using FamNest, you agree to the terms outlined in this Privacy Policy. Thank you for trusting us to help your family stay organized and connected!',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(top: 16.0, bottom: 8.0),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.teal,
        ),
      ),
    );
  }

  Widget _buildText(String text) {
    return Text(
      text,
      style: const TextStyle(fontSize: 16),
      textAlign: TextAlign.justify,
    );
  }

  Widget _buildDivider() {
    return const Divider(
      color: Colors.grey,
      thickness: 0.5,
    );
  }
}
