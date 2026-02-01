import 'package:flutter/material.dart';
import '../models/country.dart';
import '../utils/formatters.dart';
import '../widgets/flag_card.dart';
import '../widgets/info_section.dart';
import '../widgets/info_row.dart';
import '../widgets/api_footer.dart';
import '../common/constants.dart';

class CountryDetailsScreen extends StatelessWidget {
  final Country country;

  const CountryDetailsScreen({super.key, required this.country});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
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
              _buildAppBar(context),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      FlagCard(flagUrl: country.flag),
                      _buildGeneralInfo(),
                      _buildCulturalInfo(),
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

  Widget _buildAppBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppConstants.marginNormal),
      child: Row(
        children: [
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.arrow_back, color: Colors.white),
          ),
          const SizedBox(width: 8),
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

  Widget _buildGeneralInfo() {
    return InfoSection(
      title: AppConstants.generalInfoTitle,
      children: [
        InfoRow(
          icon: Icons.location_city,
          label: AppConstants.capitalLabel,
          value: country.capital,
        ),
        InfoRow(
          icon: Icons.people,
          label: AppConstants.populationLabel,
          value: CountryFormatter.formatPopulation(country.population),
        ),
        InfoRow(
          icon: Icons.terrain,
          label: AppConstants.areaLabel,
          value: CountryFormatter.formatArea(country.area),
        ),
        InfoRow(
          icon: Icons.public,
          label: AppConstants.regionLabel,
          value: country.region,
        ),
        if (country.subregion.isNotEmpty)
          InfoRow(
            icon: Icons.map,
            label: AppConstants.subregionLabel,
            value: country.subregion,
          ),
      ],
    );
  }

  Widget _buildCulturalInfo() {
    return InfoSection(
      title: AppConstants.culturalInfoTitle,
      children: [
        InfoRow(
          icon: Icons.monetization_on,
          label: AppConstants.currencyLabel,
          value: country.currency,
        ),
        InfoRow(
          icon: Icons.language,
          label: AppConstants.languageLabel,
          value: country.language,
        ),
      ],
    );
  }
}
