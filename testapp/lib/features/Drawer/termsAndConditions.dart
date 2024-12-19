import 'package:flutter/material.dart';

class TermsAndConditions extends StatelessWidget {
  const TermsAndConditions({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.teal,
        title: Text(
          'Terms And Conditions',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
        ),
        centerTitle: true,
        iconTheme: IconThemeData(color: Colors.white),
        // This centers the title text
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Terms and Conditions',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.teal,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Text(
                  'Welcome to FemNest, your family’s go-to platform for managing important moments, finances, and memories. '
                  'These Terms and Conditions (“Terms”) govern your access and use of the FemNest app and services. By using FemNest, '
                  'you agree to comply with these Terms. Please read them carefully before proceeding. If you disagree with any part of the Terms, '
                  'discontinue using the app.\n\n',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16),
            _buildSectionTitle('1. Acceptance of Terms'),
            _buildText(
              'By creating an account or using FemNest, you agree to abide by these Terms and our Privacy Policy. These Terms apply to all users, '
                  'including individual family members who share access to the platform.\n\n',
            ),
            _buildDivider(),
            _buildSectionTitle('2. Services Provided'),
            _buildText(
              'FemNest offers features designed to help families stay organized and connected:\n'
                  '- Securely store and access important family documents.\n'
                  '- Manage and monitor family finances.\n'
                  '- Preserve memories like photos, videos, and messages for the future.\n'
                  '- Organize family events with shared calendars and to-do lists.\n'
                  '- Store and relive cherished moments.\n'
                  '- Maintain a directory of important family contacts.\n\n'
                  'These services are meant for personal and lawful use only.\n\n',
            ),
            _buildDivider(),
            _buildSectionTitle('3. Account Responsibilities'),
            _buildText(
              'To use FemNest, you must create an account. You agree to:\n'
                  '- Provide accurate and up-to-date information.\n'
                  '- Keep your login credentials secure.\n'
                  '- Notify us immediately of any unauthorized access to your account.\n'
                  '- Be responsible for all activities under your account.\n\n'
                  'FemNest is not liable for losses resulting from unauthorized use of your account.\n\n',
            ),
            _buildDivider(),
            _buildSectionTitle('4. User Conduct'),
            _buildText(
              'By using FemNest, you agree not to:\n'
                  '- Violate any applicable laws or regulations.\n'
                  '- Upload or share content that is offensive, illegal, or violates intellectual property rights.\n'
                  '- Attempt to reverse-engineer, hack, or disrupt the platform.\n'
                  '- Use FemNest for commercial purposes without explicit permission.\n\n'
                  'Violation of these rules may result in account suspension or termination.\n\n',
            ),
            _buildDivider(),
            _buildSectionTitle('5. Content Ownership'),
            _buildText(
              'You retain ownership of any content you upload to FemNest, such as photos, videos, and documents. '
                  'By uploading content, you grant FemNest a non-exclusive license to store and display it for your use within the app.\n\n'
                  'FemNest is not responsible for lost or deleted content. We recommend you maintain backups of important files.\n\n',
            ),
            _buildDivider(),
            _buildSectionTitle('6. Privacy and Data Usage'),
            _buildText(
              'Your privacy is important to us. By using FemNest, you consent to the collection and use of your data as outlined in our Privacy Policy. '
                  'We use your data only to enhance your experience and do not share it with third parties without your explicit consent.\n\n',
            ),
            _buildDivider(),
            _buildSectionTitle('7. Payment and Subscriptions'),
            _buildText(
              'Certain features of FemNest may require a subscription. If applicable:\n'
                  '- Payment terms will be clearly outlined at the point of purchase.\n'
                  '- Subscriptions automatically renew unless canceled before the renewal date.\n'
                  '- Refunds are not provided for unused portions of a subscription period.\n\n',
            ),
            _buildDivider(),
            _buildSectionTitle('8. Termination of Services'),
            _buildText(
              'FemNest reserves the right to suspend or terminate your account if you:\n'
                  '- Violate these Terms.\n'
                  '- Engage in fraudulent or illegal activities.\n'
                  '- Use the app in a manner that negatively impacts other users.\n\n'
                  'Upon termination, access to your data and account features will be revoked.\n\n',
            ),
            _buildDivider(),
            _buildSectionTitle('9. Limitation of Liability'),
            _buildText(
              'FemNest is provided on an “as-is” and “as-available” basis. While we strive to provide a reliable service, we are not liable for:\n'
                  '- Service interruptions or technical issues.\n'
                  '- Loss of data due to user actions or unforeseen circumstances.\n'
                  '- Indirect, incidental, or consequential damages.\n\n'
                  'Your use of the app is at your own risk.\n\n',
            ),
            _buildDivider(),
            _buildSectionTitle('10. Updates to Terms'),
            _buildText(
              'FemNest may update these Terms periodically. Users will be notified of significant changes through the app. '
                  'Continued use of FemNest after changes signifies acceptance of the updated Terms.\n\n',
            ),
            _buildDivider(),
            _buildSectionTitle('11. Governing Law'),
            _buildText(
              'These Terms are governed by the laws of your jurisdiction. Any disputes will be resolved exclusively in the courts located in your region.\n\n',
            ),
            _buildDivider(),
            _buildSectionTitle('12. Contact Us'),
            _buildText(
              'For questions, concerns, or feedback regarding these Terms or the app, contact us at support@femnest.com.\n\n',
            ),
            _buildDivider(),
            _buildText(
              'By signing up and using FemNest, you acknowledge that you have read, understood, and agree to these Terms and Conditions. '
                  'Thank you for trusting FemNest to help your family stay connected and organized!',
            //  style: TextStyle(fontSize: 16),
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
