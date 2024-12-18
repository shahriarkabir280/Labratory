import 'dart:math';
// Function to generate password
String generatePassword() {
  const String alphabets = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ";
  const String numbers = "0123456789";
  const String specialChars = "!@#\$%^&*()-_=+[]{}|;:,.<>?";
  const String allChars = alphabets + numbers + specialChars;

  final Random random = Random();
  int length = random.nextInt(4) + 14; // length 14 15 16 hotel parbe
  String password = "";

  for (int i = 0; i < length; i++) {
    password += allChars[random.nextInt(allChars.length)];
  }

  return password;
}