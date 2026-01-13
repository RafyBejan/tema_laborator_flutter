import 'package:flutter/material.dart';

class RegionFilter extends StatelessWidget {
  final List<String> regions;
  final String selectedRegion;
  final Function(String) onRegionSelected;

  const RegionFilter({
    super.key,
    required this.regions,
    required this.selectedRegion,
    required this.onRegionSelected,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: regions.length,
        itemBuilder: (context, index) {
          String region = regions[index];
          bool isSelected = selectedRegion == region;
          return Container(
            margin: const EdgeInsets.only(right: 8),
            child: FilterChip(
              label: Text(region),
              selected: isSelected,
              onSelected: (selected) => onRegionSelected(region),
              labelStyle: TextStyle(fontWeight: FontWeight.w600),
            ),
          );
        },
      ),
    );
  }
}
