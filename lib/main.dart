import 'package:flutter/material.dart';
import 'package:postsampleapp/ui/employee_screen.dart';

main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: EmployeeScreen(),
    );
  }
}
