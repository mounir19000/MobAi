import 'package:app/routes/routes.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../core/constants/app_theme.dart';
import '../core/constants/top_curve.dart';
import '../core/services/auth_service.dart';
import '../core/services/responsive.dart';
import '../state/book_provider.dart';
import '../state/order_provider.dart';
import '../state/user_provider.dart';

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
      _login();
    }
  }

  bool _isLoading = false;
  String? _errorMessage;

  void _login() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    final result = await _authService.signIn(
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
      var _user = result['user'];

      // Set user in UserProvider
      Provider.of<UserProvider>(context, listen: false).setUser(_user!);

      // Load books based on the user
      Provider.of<BookProvider>(context, listen: false)
          .loadBooksForUser(_user!);
      Navigator.pushReplacementNamed(context, AppRoutes.homepage);
      // Load orders for the user
      Provider.of<OrderProvider>(context, listen: false)
          .loadOrdersForUser(_user!.userId);
      Navigator.pushReplacementNamed(context, AppRoutes.homepage);
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
                ClipPath(
                  clipper: OnboardingClipper(),
                  child: Container(
                    height: MediaQuery.of(context).size.height * 0.25,
                    width: double.infinity,
                    color: Colors.redAccent,
                    padding: EdgeInsets.only(bottom: 50),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          "Welcome to",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 26,
                          
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Image.asset(
                          "lib/assets/images/logo-white.png", // Adjust the path if needed
                          width: 500, // Adjust size if necessary
                        ),
                      ],
                    ),
                  ),
                ),
                SingleChildScrollView(
                  child: Container(
                    margin: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                    padding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(
                            height: MediaQuery.of(context).size.height * 0.25),
                        TextField(
                          controller: _emailController,
                          keyboardType: TextInputType.emailAddress,
                          decoration: Inputdeco.getDeco(
                              "Email", "Enter your email", emailAddressError),
                        ),
                        SizedBox(height: 26),
                        TextField(
                          controller: _passwordController,
                          obscureText: true,
                          decoration: Inputdeco.getDeco(
                              "Password", "Enter your password", passwordError),
                        ),
                        SizedBox(height: 24),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            TextButton(
                              onPressed: () {
                                Navigator.pushReplacementNamed(
                                    context, AppRoutes.forgetpass);
                              },
                              child: Center(
                                child: Text(
                                  "Forget your password ?",
                                  style: const TextStyle(
                                      decoration: TextDecoration.underline,
                                      fontSize: 12,
                                      color: Color.fromARGB(255, 0, 0, 0)),
                                ),
                              ),
                            ),
                          ],
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
                      bottom: MediaQuery.of(context).viewInsets.bottom + 50,
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      
                      children: [
                        if (_isLoading)
                          CircularProgressIndicator()
                        else
                          SizedBox(
                            width: 230, // Fixed width for both buttons
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                minimumSize: Size(
                                    700, 55), // Ensuring same width and height
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                              ),
                              onPressed: () {
                                validateInputs();
                              },
                              child: Text(
                                "Login",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18), // Uniform font size
                              ),
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
                        SizedBox(
                          width: 230, // Fixed width for both buttons
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              elevation: 0,
                              backgroundColor: Colors.transparent,
                              minimumSize: Size(
                                  700, 55), // Ensuring same width and height
                              side: BorderSide(
                                color: AppTheme.primaryColor,
                                width: 2,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                            ),
                            onPressed: () {
                              Navigator.pushReplacementNamed(
                                  context, AppRoutes.register);
                            },
                            child: Text(
                              "Sign up",
                              style: TextStyle(
                                  color: AppTheme.primaryColor,
                                  fontSize: 18), // Uniform font size
                            ),
                          ),
                        
                        ),
                        SizedBox(height: 150,)
                      ],
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Image.asset("lib/assets/images/logo-pink.png"),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
