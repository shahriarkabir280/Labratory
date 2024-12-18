import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:testapp/authentications/validator.dart'; // Import the validators.dart file
import 'package:testapp/authentications/termsofServicesandPrivacyPolicy.dart';
import 'package:testapp/authentications/loginScreen.dart';
import 'package:testapp/backend_connections/FASTAPI.dart';
final FASTAPIhere FastAPIonthego = FASTAPIhere();

class signupScreen extends StatefulWidget {
  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<signupScreen> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  // fastapi ke msg pathacchi
  // Future<void> sendDataTofastAPI(String email, String pass) async {
  //   final String url = 'http://10.0.2.2:8000/save-input/'; // default android emu url diye connect hocchi
  //
  //   final response = await http.post(
  //     Uri.parse(url),
  //     headers: {'Content-Type': 'application/json'},
  //     body: json.encode({"email": email, "password":pass}),
  //   );
  //
  //   if (response.statusCode == 200) {
  //     final responseData = json.decode(response.body);
  //
  //     // Show message from the response
  //     if(responseData['message']=="Successfully Registered")
  //     {ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(content: Text(responseData['message']),backgroundColor: Colors.lightGreen),
  //     );}
  //     else {
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         SnackBar(content: Text(responseData['message']),backgroundColor: Colors.redAccent),
  //       );
  //     }
  //   } else {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(content: Text('Failed to save data')),
  //     );
  //   }
  // }
  bool _isChecked = false;
  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;

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
              // Circular Image Decoration
              ClipOval(
                child: SizedBox(
                  width: 150,
                  height: 150,
                  child: Image.asset(
                    'assets/authentications/test.png', // Replace with your SVG or image path
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              // Page Title
              Text(
                "Create Your Account",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.teal[800],
                ),
              ),
              const SizedBox(height: 10),
              Text(
                "Join FamNest and manage your family's life in one place!",
                style: TextStyle(fontSize: 16, color: Colors.teal[600]),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 30),
              // Input Fields
              _buildTextField(
                controller: _nameController,
                label: "Name",
                icon: Icons.person,
              ),
              const SizedBox(height: 15),
              _buildTextField(
                controller: _emailController,
                label: "Email",
                icon: Icons.email,
              ),
              const SizedBox(height: 15),
              _buildTextField1(
                controller: _passwordController,
                label: "Password",
                icon: Icons.lock,
                isPassword: true,
              ),
              const SizedBox(height: 15),
              _buildTextField2(
                controller: _confirmPasswordController,
                label: "Confirm Password",
                icon: Icons.lock,
                isPassword: true,
              ),
              const SizedBox(height: 20),
              // Terms and Conditions
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Checkbox(
                    value: _isChecked,
                    onChanged: (value) {
                      setState(() {
                        _isChecked = value!;
                      });
                    },
                  ),
                  Expanded(
                    child: RichText(
                      text: TextSpan(
                        text: "I have read and agree to the ",
                        style: TextStyle(color: Colors.teal[600], fontSize: 14),
                        children: [
                          TextSpan(
                            text: "Terms of Services",
                            style: TextStyle(
                              color: Colors.teal[800],
                              fontWeight: FontWeight.bold,
                              decoration: TextDecoration.underline,
                            ),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                //Validators.showSnackBar(context, "Navigate to Terms of Services");
                                termsOfServicesAndPrivacyPolicy.showTermsOfServices(context);
                              },
                          ),
                          TextSpan(text: " and "),
                          TextSpan(
                            text: "Privacy Policy",
                            style: TextStyle(
                              color: Colors.teal[800],
                              fontWeight: FontWeight.bold,
                              decoration: TextDecoration.underline,
                            ),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                //Validators.showSnackBar(context, "Navigate to Privacy Policy");
                                termsOfServicesAndPrivacyPolicy.showPrivacyPolicy(context);
                              },
                          ),
                          TextSpan(text: "."),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              // Sign-Up Button
              ElevatedButton(
                onPressed: () {
                  final nothavingName=Validators.validateFullName(_nameController.text);
                  final emailError = Validators.validateEmail(_emailController.text);
                  final passwordError = Validators.validatePassword(_passwordController.text);
                  final confirmPasswordError = Validators.validateConfirmPassword(
                    _passwordController.text,
                    _confirmPasswordController.text,
                  );
                  final inputText = _nameController.text;

                  if(nothavingName!=null){
                    Validators.showSnackBar(context, nothavingName);
                    return;
                  }

                  if (emailError != null) {
                    Validators.showSnackBar(context, emailError);
                    return;
                  }

                  if (passwordError != null) {
                    Validators.showSnackBar(context, passwordError);
                    return;
                  }

                  if (confirmPasswordError != null) {
                    Validators.showSnackBar(context, confirmPasswordError);
                    return;
                  }

                  if (!_isChecked) {
                    Validators.showSnackBar(context, "You must agree to the Terms and Privacy Policy");
                    return;
                  }

                  if (_emailController.text.isNotEmpty) {
                    FastAPIonthego.user_register(context,_nameController.text, _emailController.text , _passwordController.text);// Send the input text to the FastAPI backend
                    } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Please enter Username')),
                    );
                  }

                  //all ok
                  // Validators.showSnackBar(context, "Successfully registered", backgroundColor: Colors.lightGreen);

                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal[700],
                  padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: const Text(
                  "Sign Up",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                ),
              ),
              const SizedBox(height: 20),
              // Already Have an Account
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Already have an account?",
                    style: TextStyle(fontSize: 16, color: Colors.teal[600]),
                  ),
                  TextButton(
                    onPressed: () {
                      // Navigate to Sign-In Page
                      Navigator.pushReplacement(
                        context,
                      MaterialPageRoute(builder: (context)=>loginScreen()),
                      );
                    },
                    child: Text(
                      "login",
                      style: TextStyle(fontSize: 16, color: Colors.teal[700], fontWeight: FontWeight.bold),
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

  // Helper Widget for Text Fields
  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    bool isPassword = false,
  }) {
    return TextField(
      controller: controller,
      obscureText: isPassword,
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

      ),
    );
  }

  // helper widget for password text field
  Widget _buildTextField1({
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

  //helper text field for confirm password field
  Widget _buildTextField2({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    bool isPassword = false,
  }) {
    return TextField(
      controller: controller,
      obscureText: isPassword ? !_isConfirmPasswordVisible : false,
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
            _isConfirmPasswordVisible ? Icons.visibility_off : Icons.visibility,
            color: Colors.teal,
          ),
          onPressed: () {
            setState(() {
              _isConfirmPasswordVisible = !_isConfirmPasswordVisible;
            });
          },
        )
            : null,
      ),
    );
  }
}
