import 'package:flutter/material.dart';
import 'common/constants.dart';
import 'screens/country_list_screen.dart';

/// Entry point - Lanseaza aplicatia Flutter
void main() {
  runApp(const MyApp());
}

/// Radacina aplicatiei - Configureaza tema si navigarea
///
/// Functioneaza ca StatelessWidget deoarece nu are state dinamic
/// Tema se aplica global pe toata aplicatia
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: AppConstants.appTitle,
      // Ascunde banner-ul de debug din dreapta sus
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        // Culoare primara: Albastru pentru design modern
        primarySwatch: Colors.blue,
        // Foloseste Material Design 3 pentru componente moderne
        useMaterial3: true,
        // Font custom din constants
        fontFamily: AppConstants.fontFamily,
      ),
      // Ecranul initial: Lista cu toate tarile
      home: const CountryListScreen(),
    );
  }
}
