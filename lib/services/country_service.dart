import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/country.dart';
import '../data/hardcoded_countries.dart';

class CountryService {
  static const String baseUrl = 'https://restcountries.com/v3.1';

  static Future<List<Country>> fetchCountries() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/all'));

      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        List<Country> countries = data
            .map((json) => Country.fromJson(json))
            .toList();

        countries.sort((a, b) => a.name.compareTo(b.name));
        return countries;
      }
      throw Exception('Failed to load countries');
    } catch (e) {
      return HardcodedCountries.getCountries();
    }
  }
}
