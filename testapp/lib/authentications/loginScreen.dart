import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:testapp/backend_connections/FASTAPI.dart';
import 'package:testapp/Models/UserState.dart';
import 'package:testapp/features/HomepageHandling/mainHomepage.dart';
import 'package:testapp/features/GroupsHandling/createOrJoinGroup.dart';
import 'package:testapp/authentications/signupScreen.dart';
import 'package:testapp/authentications/forgetPasswordScreen.dart';

class loginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<loginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final FASTAPI fastAPI = FASTAPI(); // Using the FASTAPI class
  bool _isLoading = false;
  bool _isPasswordVisible = false; // Track password visibility

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.teal[50],
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 50),
              ClipOval(
                child: SizedBox(
                  width: 150,
                  height: 150,
                  child: Image.asset('assets/authentications/test.png', fit: BoxFit.cover),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                "Welcome Back",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.teal[800],
                ),
              ),
              const SizedBox(height: 10),
              Text(
                "Log in to your FamNest account.",
                style: TextStyle(fontSize: 16, color: Colors.teal[600]),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 30),
              _buildTextField(
                controller: _emailController,
                label: "Email",
                icon: Icons.email,
              ),
              const SizedBox(height: 15),
              _buildTextField(
                controller: _passwordController,
                label: "Password",
                icon: Icons.lock,
                isPassword: true,
              ),
              const SizedBox(height: 20),
              Align(
                alignment: Alignment.centerLeft,
                child: TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ForgotPasswordScreen()),
                    );
                  },
                  child: Text(
                    "Forgot Password?",
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.teal[700],
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              _isLoading
                  ? CircularProgressIndicator(color: Colors.teal[700])
                  : ElevatedButton(
                onPressed: () => _handleLogin(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal[700],
                  padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                ),
                child: const Text(
                  "Login",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Don't have an account?",
                    style: TextStyle(fontSize: 16, color: Colors.teal[600]),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => signUpScreen()),
                      );
                    },
                    child: Text(
                      "Sign Up",
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.teal[700],
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    bool isPassword = false,
  }) {
    return TextField(
      controller: controller,
      obscureText: isPassword ? !_isPasswordVisible : false,
      decoration: InputDecoration(
        prefixIcon: Icon(icon, color: Colors.teal),
        labelText: label,
        labelStyle: TextStyle(color: Colors.teal[600]),
        filled: true,
        fillColor: Colors.white,
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.teal[700]!),
          borderRadius: BorderRadius.circular(10),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.teal[300]!),
          borderRadius: BorderRadius.circular(10),
        ),
        suffixIcon: isPassword
            ? IconButton(
          icon: Icon(
            _isPasswordVisible ? Icons.visibility_off : Icons.visibility,
            color: Colors.teal,
          ),
          onPressed: () {
            setState(() {
              _isPasswordVisible = !_isPasswordVisible;
            });
          },
        )
            : null,
      ),
    );
  }

  Future<void> _handleLogin(BuildContext context) async {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Email and password cannot be empty")),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final loginResponse = await fastAPI.loginUser(context, email, password);

      if (loginResponse.containsKey("access_token")) {
        final userState = Provider.of<UserState>(context, listen: false);
        final userData = await fastAPI.getUserData(context, email);

        userState.updateUser(User(
          name: userData['name'],
          email: userData['email'],
          //password: '', // Avoid storing the password locally for security
          groups: (userData['groups'] as List<dynamic>)
              .map((group) => Group.fromJson(group))
              .toList(),
          currentGroup: userData['current_group'] != null
              ? Group.fromJson(userData['current_group'])
              : null,
          loginStatus: userData['login_status'],
          createdAt: userData['created_at'],
          profilePictureUrl: userData['profile_picture_url'],
        ));



        if (userData['groups'] != null && userData['groups'].isNotEmpty) {

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Login Successful."),backgroundColor: Colors.lightGreen),
          );

          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => mainHomepage()),
          );
        } else {

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Login Successful."),backgroundColor: Colors.lightGreen),
          );

          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => CreateOrJoinGroup()),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Login failed. Please try again.")),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e"),backgroundColor: Colors.redAccent),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }
}
