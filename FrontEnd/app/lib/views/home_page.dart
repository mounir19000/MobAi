import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../core/constants/top_curve.dart';
import '../state/user_provider.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
     final userProvider = Provider.of<UserProvider>(context);

    return SafeArea(
      child: Scaffold(
       
        body: Stack(
          children: [
            ClipPath(
                    clipper: OnboardingClipper(),
                    child: Container(
                      height: MediaQuery.of(context).size.height * 0.25,
                      width: double.infinity,
                      color: Colors.redAccent,
                    ),
                  ),
                  SingleChildScrollView(
                    child: Center(
                      child: Column(
                        children: [
                          const SizedBox(height: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children:[
                              Image.asset(
                                "lib/assets/images/Logo.png",
                                height: 50,
                                width: 50,
                              ),
                              const SizedBox(width: 20),
                            ]
                          ),
                          
                        ],
                      ),
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}