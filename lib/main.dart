import 'package:flutter/material.dart';

import 'screens/main.dart';

void main() {
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CashflowView',
      theme: ThemeData(
        primarySwatch: Colors.pink,
      ),
      home: const MainScreen()
    );
  }
}
