import 'package:flutter/material.dart';
import '../core/constants/app_theme.dart';
import '../core/constants/top_curve.dart';
import '../core/services/auth_service.dart';
import '../core/services/responsive.dart';
import '../routes/routes.dart';

class ForgetPassPage extends StatefulWidget {
  const ForgetPassPage({super.key});

  @override
  State<ForgetPassPage> createState() => _ForgetPassPageState();
}

class _ForgetPassPageState extends State<ForgetPassPage> {
  final TextEditingController _emailController = TextEditingController();
  final AuthService _authService = AuthService();

  // Error messages
  String? emailAddressError;
  bool _isLoading = false;
  String? _errorMessage;

  void validateInputs() {
    setState(() {
      emailAddressError =
          _emailController.text.isEmpty ? "Email is required" : null;
    });

    // if (emailAddressError == null) {
    //   setState(() {
    //     _isLoading = true;
    //     _errorMessage = null;
    //   });

    //   _authService.sendPasswordResetEmail(_emailController.text).then((value) {
    //     setState(() {
    //       _isLoading = false;
    //       _errorMessage = value ? "Email sent successfully" : "Failed to send email";
    //     });
    //   }).catchError((error) {
    //     setState(() {
    //       _isLoading = false;
    //       _errorMessage = error.message;
    //     });
    //   });
    // }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: true,
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
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(75, 55, 0, 0),
                      child: Text(
                        "Reset password?",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),

                SingleChildScrollView(
                  child: Container(
                    margin: const EdgeInsets.all(20),
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                       SizedBox(height: MediaQuery.of(context).size.height * 0.25),
                        Text(
                          "Enter your email address below to reset your password",
                          style: TextStyle(
                            fontSize: 16,
                            // fontWeight: FontWeight.w500,
                          ),
                        ),
                        SizedBox(height: 25),
                        TextField(
                          controller: _emailController,
                          keyboardType: TextInputType.emailAddress,
                          decoration: InputDecoration(
                            labelText: "Email",
                            hintText: "",
                            errorText: emailAddressError,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
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
                          const CircularProgressIndicator()
                        else
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              minimumSize: const Size(double.infinity, 55),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                            ),
                            onPressed: validateInputs, 
                            child: const Text(
                              "Send email",
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        if (_errorMessage != null) ...[
                          const SizedBox(height: 16),
                          Text(
                            _errorMessage!,
                            style: const TextStyle(color: Colors.red),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),

                 Align(
                  alignment: Alignment.topLeft,
                   child: Padding(
                     padding: const EdgeInsets.fromLTRB(20, 50, 0, 0),
                     child: IconButton(icon: Icon(Icons.arrow_back,color: Colors.white, size: 35),
                            onPressed: () {
                              Navigator.pushReplacementNamed(
                                    context, AppRoutes.login);
                            },),
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
