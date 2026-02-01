import 'package:flutter/material.dart';

/// Constante globale pentru aplicație
class AppConstants {
  // ===================== Text UI =====================
  static const String appTitle = 'Enciclopedie Țări';
  static const String appDescription =
      'Explorează informații despre țările lumii';

  // Headers & Labels
  static const String headerTitle = 'Țări din lume';
  static const String searchPlaceholder = 'Caută țară...';
  static const String noResultsFound = 'Nu s-au găsit țări';
  static const String loadingText = 'Se încarcă țările...';
  static const String errorText = 'Eroare la încărcarea datelor';

  // Filter regions
  static const List<String> regions = [
    'Toate',
    'Africa',
    'America',
    'Asia',
    'Europe',
    'Oceania',
  ];

  // Details Screen
  static const String generalInfoTitle = 'Informații Generale';
  static const String culturalInfoTitle = 'Informații Culturale';
  static const String capitalLabel = 'Capitală';
  static const String populationLabel = 'Populație';
  static const String areaLabel = 'Suprafață';
  static const String regionLabel = 'Regiune';
  static const String subregionLabel = 'Subregiune';
  static const String currencyLabel = 'Monedă';
  static const String languageLabel = 'Limbă';

  // ===================== Colors =====================
  static const Color primaryColor = Colors.blue;
  static const Color accentColor = Colors.blueAccent;
  static const Color backgroundColor = Colors.white;
  static const Color textPrimaryColor = Colors.black87;
  static const Color textSecondaryColor = Colors.grey;

  // Gradient colors
  static const List<Color> primaryGradient = [
    Color(0xFF2196F3),
    Color(0xFF1976D2),
  ];

  // ===================== Styling =====================
  static const String fontFamily = 'Roboto';

  static const TextStyle headingStyle = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: textPrimaryColor,
  );

  static const TextStyle subheadingStyle = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.bold,
    color: textPrimaryColor,
  );

  static const TextStyle bodyStyle = TextStyle(
    fontSize: 16,
    color: textPrimaryColor,
  );

  static const TextStyle labelStyle = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    color: textSecondaryColor,
  );

  static const TextStyle captionStyle = TextStyle(
    fontSize: 12,
    color: textSecondaryColor,
  );

  // ===================== Spacing =====================
  static const double paddingSmall = 8.0;
  static const double paddingNormal = 16.0;
  static const double paddingLarge = 24.0;

  static const double marginSmall = 8.0;
  static const double marginNormal = 16.0;
  static const double marginLarge = 24.0;

  // ===================== Border Radius =====================
  static const double borderRadiusSmall = 4.0;
  static const double borderRadiusNormal = 8.0;
  static const double borderRadiusLarge = 12.0;

  // ===================== API =====================
  static const String apiBaseUrl = 'https://restcountries.com/v3.1';
  static const String flagCdnBaseUrl = 'https://flagcdn.com/h240';

  // ===================== Elevation =====================
  static const double elevationCard = 4.0;
  static const double elevationButton = 2.0;
}
