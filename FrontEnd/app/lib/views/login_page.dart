import 'package:app/routes/routes.dart';
import 'package:flutter/material.dart';

import '../core/constants/app_theme.dart';
import '../core/services/auth_sevice.dart';
import '../core/services/responsive.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final AuthService _authService = AuthService();

// Error messages
  String? emailAddressError;
  String? passwordError;

  void validateInputs() {
    setState(() {
      emailAddressError =
          _emailController.text.isEmpty ? "Email is required" : null;
      passwordError =
          _passwordController.text.isEmpty ? "Password is required" : null;
      
    });

    if (emailAddressError == null && passwordError == null) {
      // Navigator.pushReplacementNamed(context, AppRoutes.strorelist);
     // _login();
    }
  }

  bool _isLoading = false;
  String? _errorMessage;

  void _login() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    final result = await _authService.login(
      _emailController.text.trim(),
      _passwordController.text.trim(),
    );

    setState(() {
      _isLoading = false;
    });

    if (result["error"] == true) {
      setState(() {
        _errorMessage = result["message"];
      });
    } else {
      final token = result["token"];
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Login successful! Token: $token")),
      );
      // Navigate to the next screen or save the token as needed
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        // backgroundColor: Colors.white,
        body: Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: Responsive.getAuthMaxWidth(context),
            ),
            child: Stack(
              children: [
                //Align(alignment:Alignment.topCenter, child: ),
                SingleChildScrollView(
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
                          "Sign in to your account",
                          style: const TextStyle(
                              fontSize: 16, color: Color(0xFFA1A1A1)),
                        ),
                        const SizedBox(height: 60),
                        TextField(
                          controller: _emailController,
                          keyboardType: TextInputType.emailAddress,
                          decoration: Inputdeco.getDeco(
                              "Email",
                              "Enter your email",
                              emailAddressError),
                        ),
                        SizedBox(height: 26),
                        TextField(
                          controller: _passwordController,
                          obscureText: true,
                          decoration: Inputdeco.getDeco(
                              "Password",
                              "Enter your password",passwordError),
                        ),
                        SizedBox(height: 24),
                        Text(
                          "Forget your password ?",
                          style: const TextStyle(
                              fontSize: 12, color: Color(0xFFA1A1A1)),
                        ),
                      ],
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: EdgeInsets.only(
                        right: 30,
                        left: 30,
                        bottom: MediaQuery.of(context).viewInsets.bottom + 50),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (_isLoading)
                          CircularProgressIndicator()
                        else
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              minimumSize: Size(double.infinity, 55),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            onPressed: () {},
                            child: Text(
                              "login",
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        if (_errorMessage != null) ...[
                          SizedBox(height: 16),
                          Text(
                            _errorMessage!,
                            style: TextStyle(color: Colors.red),
                          ),
                        ],
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
                            Navigator.pushReplacementNamed(
                                context, AppRoutes.register);
                          },
                          child: Text(
                            "Sign up",
                            style: TextStyle(color: Color(0xFF818181)),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
