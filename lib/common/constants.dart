import 'package:flutter/material.dart';

/// Constante globale pentru aplicatie
///
/// Contine toate valorile constante folosite in aplicatie:
/// text, culori, stiluri, spacing, etc.
/// Avand constante intr-un fisier separat face codul mai usor de manetuit
class AppConstants {
  // ================== STRING CONSTANTS - TEXT UI ==================

  /// Titlul aplicatiei afisat in bara de titlu
  static const String appTitle = 'Enciclopedie Țări';

  /// Descrierea scurta a aplicatiei
  static const String appDescription =
      'Explorează informații despre țările lumii';

  /// Titlu in header-ul ecranului principal
  static const String headerTitle = 'Țări din lume';

  /// Placeholder text in bara de cautare
  static const String searchPlaceholder = 'Caută țară...';

  /// Mesaj afisat cand cautarea nu returneaza rezultate
  static const String noResultsFound = 'Nu s-au găsit țări';

  /// Mesaj afisat in timp ce se incarca datele
  static const String loadingText = 'Se încarcă țările...';

  /// Mesaj afisat in caz de eroare la incarcare
  static const String errorText = 'Eroare la încărcarea datelor';

  /// Lista de regiuni disponibile pentru filtrare
  static const List<String> regions = [
    'Toate',
    'Africa',
    'America',
    'Asia',
    'Europe',
    'Oceania',
  ];

  // ================== DETAILS SCREEN LABELS ==================

  /// Titlul sectiunii "Informatii Generale"
  static const String generalInfoTitle = 'Informații Generale';

  /// Titlul sectiunii "Informatii Culturale"
  static const String culturalInfoTitle = 'Informații Culturale';

  /// Label pentru capitala
  static const String capitalLabel = 'Capitală';

  /// Label pentru populatie
  static const String populationLabel = 'Populație';

  /// Label pentru suprafata
  static const String areaLabel = 'Suprafață';

  /// Label pentru regiune
  static const String regionLabel = 'Regiune';

  /// Label pentru subregiune
  static const String subregionLabel = 'Subregiune';

  /// Label pentru moneda
  static const String currencyLabel = 'Monedă';

  /// Label pentru limba
  static const String languageLabel = 'Limbă';

  // ================== COLOR CONSTANTS ==================

  /// Culoare primara - Albastru
  static const Color primaryColor = Colors.blue;

  /// Culoare de accent
  static const Color accentColor = Colors.blueAccent;

  /// Culoarea de fundal - Alb
  static const Color backgroundColor = Colors.white;

  /// Culoarea textului principal - Negru cu opacitate
  static const Color textPrimaryColor = Colors.black87;

  /// Culoarea textului secundar - Gri
  static const Color textSecondaryColor = Colors.grey;

  /// Gradient principal pentru fundal (Blue 700 -> Blue 900)
  static const List<Color> primaryGradient = [
    Color(0xFF2196F3),  // Blue 500
    Color(0xFF1976D2),  // Blue 700
  ];

  // ================== TEXT STYLES ==================

  /// Font folosit in toata aplicatia
  static const String fontFamily = 'Roboto';

  /// Stil pentru headings mari (H1)
  static const TextStyle headingStyle = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: textPrimaryColor,
  );

  /// Stil pentru subheadings (H2)
  static const TextStyle subheadingStyle = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.bold,
    color: textPrimaryColor,
  );

  /// Stil pentru text normal
  static const TextStyle bodyStyle = TextStyle(
    fontSize: 16,
    color: textPrimaryColor,
  );

  /// Stil pentru labels si text mic
  static const TextStyle labelStyle = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    color: textSecondaryColor,
  );

  /// Stil pentru text foarte mic (captions)
  static const TextStyle captionStyle = TextStyle(
    fontSize: 12,
    color: textSecondaryColor,
  );

  // ================== SPACING CONSTANTS ==================

  /// Padding mic (8 dp)
  static const double paddingSmall = 8.0;

  /// Padding normal standard (16 dp)
  static const double paddingNormal = 16.0;

  /// Padding mare (24 dp)
  static const double paddingLarge = 24.0;

  /// Margin mic
  static const double marginSmall = 8.0;

  /// Margin normal standard
  static const double marginNormal = 16.0;

  /// Margin mare
  static const double marginLarge = 24.0;

  // ================== BORDER RADIUS ==================

  /// Border radius mic (4 dp)
  static const double borderRadiusSmall = 4.0;

  /// Border radius normal (8 dp)
  static const double borderRadiusNormal = 8.0;

  /// Border radius mare (12 dp)
  static const double borderRadiusLarge = 12.0;

  // ================== API CONSTANTS ==================

  /// URL-ul API-ului REST Countries
  static const String apiBaseUrl = 'https://restcountries.com/v3.1';

  /// URL-ul CDN pentru steaguri (240x240px)
  static const String flagCdnBaseUrl = 'https://flagcdn.com/h240';

  // ================== ELEVATION CONSTANTS ==================

  /// Elevation standard pentru carduri (4 dp)
  static const double elevationCard = 4.0;

  /// Elevation standard pentru butoane (2 dp)
  static const double elevationButton = 2.0;
}
