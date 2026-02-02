import 'package:flutter/material.dart';
import '../models/country.dart';
import '../services/country_service.dart';
import '../widgets/country_card.dart';
import '../widgets/country_list_header.dart';
import '../widgets/search_bar.dart' as custom;
import '../widgets/region_filter.dart';
import '../widgets/loading_indicator.dart';
import '../widgets/empty_state.dart';
import '../common/constants.dart';
import 'country_details_screen.dart';

/// Ecranul principal - Afiseaza lista cu toate tarile
///
/// Permite utilizatorului sa:
/// - Vada lista completa de tari
/// - Caute tari dupa nume sau capitala
/// - Filtreze tarile dupa regiune
/// - Tap pe o tara pentru a vedea detalii complete
class CountryListScreen extends StatefulWidget {
  const CountryListScreen({super.key});

  @override
  State<CountryListScreen> createState() => _CountryListScreenState();
}

class _CountryListScreenState extends State<CountryListScreen> {
  /// Lista completa a tuturor tarilor (descarcata din API)
  List<Country> allCountries = [];

  /// Lista filtrata conform cautarii si selectiunii de regiune
  List<Country> filteredCountries = [];

  /// Flag pentru a sti daca se incarca datele din API
  bool isLoading = true;

  /// Query-ul de cautare introdus de utilizator
  String searchQuery = '';

  /// Regiunea selectata pentru filtrare (default: 'Toate')
  String selectedRegion = AppConstants.regions.first;

  /// Lista de regiuni disponibile
  late List<String> regions;

  @override
  void initState() {
    super.initState();
    regions = List.from(AppConstants.regions);
    // Incarca tarile cand ecranul este afisat prima oara
    loadCountries();
  }

  /// Descarc lista de tari din API via CountryService
  ///
  /// Seteaza isLoading = true pana cand completul request se termina
  Future<void> loadCountries() async {
    setState(() => isLoading = true);
    // Fetch tarile din API (sau fallback la datele hardcodate)
    allCountries = await CountryService.fetchCountries();
    // Initial, lista filtrata = lista completa
    filteredCountries = allCountries;
    setState(() => isLoading = false);
  }

  /// Filtreaza lista de tari in functie de searchQuery si selectedRegion
  ///
  /// Logica:
  /// - matchesSearch: Compara query cu numele sau capitala tarii
  /// - matchesRegion: Verifica daca regiunea selectata se potriveste
  /// Rezultatul trebuie sa satisfaca AMBELE conditii (AND logic)
  void filterCountries() {
    setState(() {
      filteredCountries = allCountries.where((country) {
        // Verifica daca cautarea se potriveste cu numele sau capitala
        bool matchesSearch =
            searchQuery.isEmpty ||
            country.name.toLowerCase().contains(searchQuery.toLowerCase()) ||
            country.capital.toLowerCase().contains(searchQuery.toLowerCase());

        // Verifica daca regiunea se potriveste (sau "Toate" e selectata)
        bool matchesRegion =
            selectedRegion == 'Toate' || country.region == selectedRegion;

        // Returneaza true numai daca AMBELE conditii sunt indeplinite
        return matchesSearch && matchesRegion;
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        // Gradient albastru (Blue 700 -> Blue 900) ca fundal
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
              // Header cu titlu si contor de tari
              CountryListHeader(countryCount: filteredCountries.length),
              // Bara de cautare
              custom.SearchBar(
                onSearchChanged: (value) {
                  searchQuery = value;
                  // Refiltraza tarile cand utilizatorul scrie in bara de cautare
                  filterCountries();
                },
              ),
              const SizedBox(height: 16),
              // Chip-uri pentru filtrare pe regiuni
              RegionFilter(
                regions: regions,
                selectedRegion: selectedRegion,
                onRegionSelected: (region) {
                  setState(() {
                    selectedRegion = region;
                    // Refiltraza tarile cand se selecteaza o regiune
                    filterCountries();
                  });
                },
              ),
              const SizedBox(height: 8),
              // Lista de tari (sau loading indicator, sau empty state)
              _buildCountryList(),
            ],
          ),
        ),
      ),
    );
  }

  /// Construieste widget-ul pentru lista de tari
  ///
  /// Actioneaza in 3 moduri:
  /// 1. Arata loading indicator cand se incarca datele
  /// 2. Arata empty state cand nu sunt rezultate
  /// 3. Arata lista de tari cu ListView.builder
  Widget _buildCountryList() {
    if (isLoading) {
      // Arata spinner in timp ce se descarca datele
      return Expanded(
        child: LoadingIndicator(message: AppConstants.loadingText),
      );
    }

    if (filteredCountries.isEmpty) {
      // Arata mesaj cand cautarea nu returneaza rezultate
      return const Expanded(
        child: EmptyState(
          icon: Icons.search_off,
          message: AppConstants.noResultsFound,
        ),
      );
    }

    // Arata lista de tari intr-un ListView scrollabil
    return Expanded(
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: filteredCountries.length,
        itemBuilder: (context, index) {
          return CountryCard(
            country: filteredCountries[index],
            onTap: () {
              // Navigheaza la ecranul de detalii cand se apasa pe o tara
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      CountryDetailsScreen(country: filteredCountries[index]),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
