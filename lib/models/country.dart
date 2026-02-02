/// Model de date pentru o tara
///
/// Contine informatii complete despre o tara preluate de la API
/// Toate campurile sunt required si final (immutable)
class Country {
  /// Numele tarii (ex: 'Romania')
  final String name;
  /// Capitala tarii (ex: 'Bucharest')
  final String capital;
  /// URL la steagul tarii in format PNG
  final String flag;
  /// Numarul total de locuitori
  final int population;
  /// Regiunea continentala (Africa, Asia, Europe, etc.)
  final String region;
  /// Moneda folosita si simbol (ex: 'Euro (€)')
  final String currency;
  /// Limba/Limbile oficiale (ex: 'Romanian')
  final String language;
  /// Suprafata tarii in km²
  final double area;
  /// Subregiunea specifica din continent (ex: 'Eastern Europe')
  final String subregion;

  /// Constructor - Initializeaza o tara cu datele complete
  Country({
    required this.name,
    required this.capital,
    required this.flag,
    required this.population,
    required this.region,
    required this.currency,
    required this.language,
    required this.area,
    required this.subregion,
  });

  /// Factory constructor - Converteste JSON din API in obiect Country
  ///
  /// REST Countries API returneaza structuri complexe cu liste si map-uri
  /// Aceasta metoda extrage si formateaza datele necesare
  factory Country.fromJson(Map<String, dynamic> json) {
    // Extrage moneda din structura complexa a API-ului
    // API returneaza: {'RON': {'name': 'Romanian leu', 'symbol': 'lei'}}
    String currency = 'N/A';
    if (json['currencies'] != null) {
      var currencies = json['currencies'] as Map<String, dynamic>;
      if (currencies.isNotEmpty) {
        // Ia prima moneda din map si formateaza cu simbol
        var firstCurrency = currencies.values.first;
        currency =
            '${firstCurrency['name']} (${firstCurrency['symbol'] ?? ''})';
      }
    }

    // Extrage limba/limbile si le combina cu virgula
    // API returneaza: {'ron': 'Romanian', 'en': 'English'}
    String language = 'N/A';
    if (json['languages'] != null) {
      var languages = json['languages'] as Map<String, dynamic>;
      if (languages.isNotEmpty) {
        // Join toate limbile: 'Romanian, English'
        language = languages.values.join(', ');
      }
    }

    return Country(
      name: json['name']['common'] ?? '',
      // Capital este array in JSON, luam prima intrare
      capital: json['capital'] != null && json['capital'].isNotEmpty
          ? json['capital'][0]
          : 'N/A',
      // URL steag din nested 'flags' object
      flag: json['flags']['png'] ?? '',
      population: json['population'] ?? 0,
      region: json['region'] ?? '',
      currency: currency,
      language: language,
      // Converteste area in double
      area: (json['area'] ?? 0).toDouble(),
      subregion: json['subregion'] ?? '',
    );
  }
}
