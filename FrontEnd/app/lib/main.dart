import 'package:flutter/material.dart';

import 'core/constants/app_theme.dart';
import 'routes/routes.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

 
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Books Demo',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      
      initialRoute: AppRoutes.pageview, // Set initial screen
      onGenerateRoute: (settings) {
        return AppRouter.generateRoute(settings); // Handle routes
      },
      // home: Scaffold(
      //   appBar: AppBar(
      //     title: const Text('Material3 Theme'),
      //   ),
      //   body: const Center(
      //     child: Text(
      //       'Hello World',
      //       style: TextStyle(fontSize: 24),
      //     ),
      //   ),
      // ),
    );
  }
}

