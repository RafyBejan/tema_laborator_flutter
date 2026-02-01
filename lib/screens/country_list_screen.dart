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

class CountryListScreen extends StatefulWidget {
  const CountryListScreen({super.key});

  @override
  State<CountryListScreen> createState() => _CountryListScreenState();
}

class _CountryListScreenState extends State<CountryListScreen> {
  List<Country> allCountries = [];
  List<Country> filteredCountries = [];
  bool isLoading = true;
  String searchQuery = '';
  String selectedRegion = AppConstants.regions.first;

  late List<String> regions;

  @override
  void initState() {
    super.initState();
    regions = List.from(AppConstants.regions);
    loadCountries();
  }

  Future<void> loadCountries() async {
    setState(() => isLoading = true);
    allCountries = await CountryService.fetchCountries();
    filteredCountries = allCountries;
    setState(() => isLoading = false);
  }

  void filterCountries() {
    setState(() {
      filteredCountries = allCountries.where((country) {
        bool matchesSearch =
            searchQuery.isEmpty ||
            country.name.toLowerCase().contains(searchQuery.toLowerCase()) ||
            country.capital.toLowerCase().contains(searchQuery.toLowerCase());
        bool matchesRegion =
            selectedRegion == 'Toate' || country.region == selectedRegion;
        return matchesSearch && matchesRegion;
      }).toList();
    });
  }

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
              CountryListHeader(countryCount: filteredCountries.length),
              custom.SearchBar(
                onSearchChanged: (value) {
                  searchQuery = value;
                  filterCountries();
                },
              ),
              const SizedBox(height: 16),
              RegionFilter(
                regions: regions,
                selectedRegion: selectedRegion,
                onRegionSelected: (region) {
                  setState(() {
                    selectedRegion = region;
                    filterCountries();
                  });
                },
              ),
              const SizedBox(height: 8),
              _buildCountryList(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCountryList() {
    if (isLoading) {
      return Expanded(
        child: LoadingIndicator(message: AppConstants.loadingText),
      );
    }

    if (filteredCountries.isEmpty) {
      return const Expanded(
        child: EmptyState(
          icon: Icons.search_off,
          message: AppConstants.noResultsFound,
        ),
      );
    }

    return Expanded(
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: filteredCountries.length,
        itemBuilder: (context, index) {
          return CountryCard(
            country: filteredCountries[index],
            onTap: () {
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
