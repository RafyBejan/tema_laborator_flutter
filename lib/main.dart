import 'package:flutter/material.dart';
import 'common/constants.dart';
import 'screens/country_list_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: AppConstants.appTitle,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
        fontFamily: AppConstants.fontFamily,
      ),
      home: const CountryListScreen(),
    );
  }
}
