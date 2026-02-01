import 'package:flutter/material.dart';
import '../common/constants.dart';

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
        padding: const EdgeInsets.symmetric(
          horizontal: AppConstants.marginNormal,
        ),
        itemCount: regions.length,
        itemBuilder: (context, index) {
          String region = regions[index];
          bool isSelected = selectedRegion == region;
          return Container(
            margin: const EdgeInsets.only(right: AppConstants.marginSmall),
            child: FilterChip(
              label: Text(region),
              selected: isSelected,
              onSelected: (selected) => onRegionSelected(region),
              labelStyle: const TextStyle(fontWeight: FontWeight.w600),
            ),
          );
        },
      ),
    );
  }
}
