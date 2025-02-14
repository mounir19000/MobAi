import 'package:app/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'core/constants/app_theme.dart';
import 'routes/routes.dart';
import 'state/book_provider.dart';
import 'state/order_provider.dart';
import 'state/user_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
await Firebase.initializeApp(
  options: DefaultFirebaseOptions.currentPlatform,
);
  WidgetsFlutterBinding.ensureInitialized();
  final userProvider = UserProvider();
  await userProvider.loadUser(); // Fetch user data before app starts
  
  final bookProvider = BookProvider();
  if (userProvider.user != null) {
    await bookProvider.loadBooksForUser(userProvider.user);
  }
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => UserProvider()),
      ChangeNotifierProvider(create: (_) => BookProvider()),
      ChangeNotifierProvider(create: (_) => OrderProvider()),
    ],
    child: MyApp(),
  ));
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
    );
  }
}
