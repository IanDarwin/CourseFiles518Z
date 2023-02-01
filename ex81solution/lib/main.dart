import 'package:flutter/material.dart';
import 'customer/customer_list_view.dart';

void main() async {
  runApp(const MyApp());
}

/// The Widget that configures your application.
class MyApp extends StatelessWidget {
  const MyApp({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    // Glue the SettingsController to the MaterialApp.
    return MaterialApp(
      restorationScopeId: 'app',
      theme: ThemeData(),
      home: const CustomerListView(),
    );
  }
}

