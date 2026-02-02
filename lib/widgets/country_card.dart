import 'package:flutter/material.dart';
import '../models/country.dart';
import '../common/constants.dart';

/// Card reutilizabil pentru a afisa o tara in lista
///
/// Arata steagul, numele si capitala tarii
/// Tap-ul pe card declanseaza callback-ul onTap
class CountryCard extends StatelessWidget {
  /// Obiectul tarii de afisat
  final Country country;

  /// Callback declansat cand se apasa pe card
  final VoidCallback onTap;

  const CountryCard({super.key, required this.country, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      // Elevation pentru efect de "raise" al cardului
      elevation: AppConstants.elevationCard,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppConstants.borderRadiusLarge),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppConstants.borderRadiusLarge),
        child: Padding(
          padding: const EdgeInsets.all(AppConstants.paddingNormal),
          child: Row(
            children: [
              // Steagul tarii (80x60 px)
              _CountryFlag(country: country),
              const SizedBox(width: 16),
              // Informatii: Nume si capitala
              _CountryInfo(country: country),
              // Arrow pentru a indica ca e clickable
              const Icon(Icons.arrow_forward_ios, color: Colors.grey, size: 20),
            ],
          ),
        ),
      ),
    );
  }
}

/// Widget-ul privat pentru afisarea steagului tarii
///
/// Arata o imagine PNG a steagului cu border radius
/// In caz de eroare la incarcare, arata un placeholder gri
class _CountryFlag extends StatelessWidget {
  /// Obiectul tarii de care ii extragem flag URL-ul
  final Country country;

  const _CountryFlag({required this.country});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 80,
      height: 60,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppConstants.borderRadiusNormal),
        // Shadow pentru efect de "inaltare"
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.2),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppConstants.borderRadiusNormal),
        // Incarca imaginea steagului din URL (de la flagcdn.com)
        child: Image.network(
          country.flag,
          fit: BoxFit.cover,
          // Daca imaginea nu se incarca, arata un placeholder
          errorBuilder: (context, error, stackTrace) {
            return Container(
              color: Colors.grey.shade300,
              child: const Icon(Icons.flag, color: Colors.grey),
            );
          },
        ),
      ),
    );
  }
}

/// Widget-ul privat pentru afisarea informatiilor tarii
///
/// Arata numele si capitala tarii in format vertical
class _CountryInfo extends StatelessWidget {
  /// Obiectul tarii pentru info
  final Country country;

  const _CountryInfo({required this.country});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(country.name, style: AppConstants.subheadingStyle),
          const SizedBox(height: 4),
          Row(
            children: [
              const Icon(Icons.location_city, size: 14, color: Colors.grey),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  country.capital,
                  style: TextStyle(fontSize: 14, color: Colors.grey.shade700),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppConstants.paddingSmall,
              vertical: 2,
            ),
            decoration: BoxDecoration(
              color: Colors.blue.shade100,
              borderRadius: BorderRadius.circular(
                AppConstants.borderRadiusSmall,
              ),
            ),
            child: Text(
              country.region,
              style: TextStyle(
                fontSize: 12,
                color: Colors.blue.shade800,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
