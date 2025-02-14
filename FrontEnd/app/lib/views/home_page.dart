import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../state/user_provider.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
     final userProvider = Provider.of<UserProvider>(context);
    return Scaffold(
      appBar: AppBar(title: Text("Welcome ${userProvider.user?.username ?? 'Guest'}")),
      body: Column(
        children: [
          Text("Balance: \$${userProvider.user?.balance.toStringAsFixed(2) ?? '0.00'}"),
          ElevatedButton(
            onPressed: () {
              userProvider.updateBalance(10.0);
            },
            child: Text("Add \$10 to Balance"),
          ),
        ],
      ),
    );
  }
}