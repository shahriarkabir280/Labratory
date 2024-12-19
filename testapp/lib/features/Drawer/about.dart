import 'package:flutter/material.dart';

class About extends StatelessWidget {
  const About({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors. teal,
        title: const Text('About'),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Displaying the image
            Image.asset(
              'assets/authentications/famNestlogo.png', // Update the path if necessary
              width: 150,
              height: 150,
              fit: BoxFit.cover,
            ),
            const SizedBox(height: 20),
            // Adding some text
            const Text(
              'Welcome to Famnest!',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            const Text('FemNest is your all-in-one solution for managing life '
                'essential tasks and memories. Designed with families in mind,'
                ' the app helps you seamlessly store important documents, track expenses, '
                'and create a personal time capsule to preserve precious moments. '
               ,
              style: TextStyle(fontSize: 16),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
