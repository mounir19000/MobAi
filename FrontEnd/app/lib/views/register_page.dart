import 'package:app/core/services/auth_sevice.dart';
import 'package:app/routes/routes.dart';
import 'package:flutter/material.dart';

import '../core/constants/app_theme.dart';
import '../core/services/responsive.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _fullnameController = TextEditingController();
  final TextEditingController _numberController = TextEditingController();
  final AuthService _authService = AuthService();
// Error messages
  String? emailAddressError;
  String? passwordError;
  String? fullnameError;
  String? numberdError;

  void validateInputs() {
    setState(() {
      emailAddressError =
          _emailController.text.isEmpty ? "Email is required" : null;
      passwordError =
          _passwordController.text.isEmpty ? "Password is required" : null;
      fullnameError =
          _fullnameController.text.isEmpty ? "Full name is required" : null;
      numberdError =
          _numberController.text.isEmpty ? "Number is required" : null;
      
    });

    if (emailAddressError == null && passwordError == null && numberdError == null && fullnameError == null) {
      // Navigator.pushReplacementNamed(context, AppRoutes.strorelist);
     // _register();
    }
  }
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset:
            true, // Ensures the layout adjusts for the keyboard
        // backgroundColor: Colors.white,
        body: Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: Responsive.getAuthMaxWidth(context),
            ),
            child: SingleChildScrollView(
              // Make the entire body scrollable
              child: Container(
                margin: const EdgeInsets.all(20),
                padding: const EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20),
                    Text(
                      "Hello, welcome!",
                      style: const TextStyle(
                          fontSize: 28, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      "Create your account",
                      style: const TextStyle(
                          fontSize: 16, color: Color(0xFFA1A1A1)),
                    ),
                    const SizedBox(height: 60),
                    TextField(
                      controller: _fullnameController,
                      keyboardType: TextInputType.text,
                      decoration: Inputdeco.getDeco(
                          "Full name",
                          "Enter your full name",fullnameError),
                    ),
                    SizedBox(height: 15),
                    TextField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: Inputdeco.getDeco(
                         "Email", "Enter your email",emailAddressError),
                    ),
                    SizedBox(height: 15),
                    TextField(
                      controller: _numberController,
                      keyboardType: TextInputType.number,
                      decoration: Inputdeco.getDeco(
                          "Phone number",
                          "Enter your phone number",numberdError),
                    ),
                    SizedBox(height: 15),
                    TextField(
                      controller: _passwordController,
                      obscureText: true,
                      decoration: Inputdeco.getDeco(
                          "Password",
                          "Enter your password",passwordError),
                    ),
                    SizedBox(height: 50),
                    Column(
                      children: [
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            minimumSize: Size(double.infinity, 55),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          onPressed: () {
                            Navigator.pushReplacementNamed(
                                context, AppRoutes.homepage);
                          },
                          child: Text(
                            "Sign up",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                        SizedBox(height: 15),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            elevation: 0,
                            backgroundColor: Colors.transparent,
                            minimumSize: Size(double.infinity, 55),
                            side:
                                BorderSide(color: Color(0xffE9EBED), width: 1),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          onPressed: () {
                            Navigator.pushReplacementNamed(context, AppRoutes.login);
                          },
                          child: Text(
                            "Already have an account?",
                            style: TextStyle(color: Color(0xFF818181)),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
