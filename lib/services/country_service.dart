import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/country.dart';
import '../data/hardcoded_countries.dart';

/// Service pentru gestionarea datelor tarilor din API
///
/// Face request-uri HTTP la REST Countries API
/// In caz de eroare, revine la datele hardcodate ca fallback
class CountryService {
  /// URL-ul API-ului REST Countries (v3.1)
  static const String baseUrl = 'https://restcountries.com/v3.1';

  /// Descarc lista completa a tarilor din API
  ///
  /// Returns: Lista de tari sortata alfabetic dupa nume
  /// Throws: Returneaza datele hardcodate daca API-ul nu raspunde
  static Future<List<Country>> fetchCountries() async {
    try {
      // Fa request HTTP GET la endpoint-ul /all pentru toate tarile
      final response = await http.get(Uri.parse('$baseUrl/all'));

      if (response.statusCode == 200) {
        // Decodeaza JSON-ul din response body
        List<dynamic> data = json.decode(response.body);
        // Converteste fiecare item in obiect Country
        List<Country> countries = data
            .map((json) => Country.fromJson(json))
            .toList();

        // Sorteaza alfabetic dupa nume tarii
        countries.sort((a, b) => a.name.compareTo(b.name));
        return countries;
      }
      // Daca status code nu e 200, arunca exceptie
      throw Exception('Failed to load countries');
    } catch (e) {
      // Fallback: Returneaza datele locale hardcodate
      // Util cand nu exista conexiune internet
      return HardcodedCountries.getCountries();
    }
  }
}
