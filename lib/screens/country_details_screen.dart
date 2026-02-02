import 'package:flutter/material.dart';
import '../models/country.dart';
import '../utils/formatters.dart';
import '../widgets/flag_card.dart';
import '../widgets/info_section.dart';
import '../widgets/info_row.dart';
import '../widgets/api_footer.dart';
import '../common/constants.dart';

/// Ecranul de detalii - Afiseaza informatii complete despre o tara
///
/// Primeste o tara ca parametru si afiseaza:
/// - Steagul mari al tarii
/// - Informatii generale (capitala, populatie, suprafata, regiune)
/// - Informatii culturale (moneda, limba)
/// - Footer cu atribuire API
class CountryDetailsScreen extends StatelessWidget {
  /// Obiectul Country pentru care se afiseaza detaliile
  final Country country;

  const CountryDetailsScreen({super.key, required this.country});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        // Gradient albastru ca fundal (acelasi ca pe list screen)
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.blue.shade700, Colors.blue.shade900],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Header cu buton back si titlul tarii
              _buildAppBar(context),
              // Continutul principal scrollabil
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      // Steagul mare al tarii
                      FlagCard(flagUrl: country.flag),
                      // Informatii generale
                      _buildGeneralInfo(),
                      // Informatii culturale
                      _buildCulturalInfo(),
                      // Footer cu atribuire la API
                      const ApiFooter(),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Construieste app bar-ul cu buton back si titlu
  Widget _buildAppBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppConstants.marginNormal),
      child: Row(
        children: [
          // Buton back pentru a reveni la lista
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.arrow_back, color: Colors.white),
          ),
          const SizedBox(width: 8),
          // Titlu: Numele tarii
          Expanded(
            child: Text(
              country.name,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  /// Construieste sectiunea de informatii generale
  ///
  /// Afiseaza: Capitala, Populatie, Suprafata, Regiune, Subregiune
  /// Foloseste InfoRow pentru fiecare linie de informatie
  Widget _buildGeneralInfo() {
    return InfoSection(
      title: AppConstants.generalInfoTitle,
      children: [
        // Capitala
        InfoRow(
          icon: Icons.location_city,
          label: AppConstants.capitalLabel,
          value: country.capital,
        ),
        // Populatie formatata (ex: "19.05 milioane")
        InfoRow(
          icon: Icons.people,
          label: AppConstants.populationLabel,
          value: CountryFormatter.formatPopulation(country.population),
        ),
        // Suprafata formatata (ex: "238.39 k km²")
        InfoRow(
          icon: Icons.terrain,
          label: AppConstants.areaLabel,
          value: CountryFormatter.formatArea(country.area),
        ),
        // Regiune continentala
        InfoRow(
          icon: Icons.public,
          label: AppConstants.regionLabel,
          value: country.region,
        ),
        // Subregiune (daca exista)
        if (country.subregion.isNotEmpty)
          InfoRow(
            icon: Icons.map,
            label: AppConstants.subregionLabel,
            value: country.subregion,
          ),
      ],
    );
  }

  /// Construieste sectiunea de informatii culturale
  ///
  /// Afiseaza: Moneda, Limba
  Widget _buildCulturalInfo() {
    return InfoSection(
      title: AppConstants.culturalInfoTitle,
      children: [
        // Moneda si simbolul
        InfoRow(
          icon: Icons.monetization_on,
          label: AppConstants.currencyLabel,
          value: country.currency,
        ),
        // Limba/limbile oficiale
        InfoRow(
          icon: Icons.language,
          label: AppConstants.languageLabel,
          value: country.language,
        ),
      ],
    );
  }
}
