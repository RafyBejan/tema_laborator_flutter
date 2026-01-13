class Country {
  final String name;
  final String capital;
  final String flag;
  final int population;
  final String region;
  final String currency;
  final String language;
  final double area;
  final String subregion;

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

  factory Country.fromJson(Map<String, dynamic> json) {
    // Extract currency
    String currency = 'N/A';
    if (json['currencies'] != null) {
      var currencies = json['currencies'] as Map<String, dynamic>;
      if (currencies.isNotEmpty) {
        var firstCurrency = currencies.values.first;
        currency =
            '${firstCurrency['name']} (${firstCurrency['symbol'] ?? ''})';
      }
    }

    // Extract language
    String language = 'N/A';
    if (json['languages'] != null) {
      var languages = json['languages'] as Map<String, dynamic>;
      if (languages.isNotEmpty) {
        language = languages.values.join(', ');
      }
    }

    return Country(
      name: json['name']['common'] ?? '',
      capital: json['capital'] != null && json['capital'].isNotEmpty
          ? json['capital'][0]
          : 'N/A',
      flag: json['flags']['png'] ?? '',
      population: json['population'] ?? 0,
      region: json['region'] ?? '',
      currency: currency,
      language: language,
      area: (json['area'] ?? 0).toDouble(),
      subregion: json['subregion'] ?? '',
    );
  }
}
