import 'package:flutter/material.dart';
import '../common/constants.dart';

class CountryListHeader extends StatelessWidget {
  final int countryCount;

  const CountryListHeader({super.key, required this.countryCount});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppConstants.paddingLarge),
      child: Column(
        children: [
          Row(
            children: [
              const Icon(Icons.public, size: 40, color: Colors.white),
              const SizedBox(width: 12),
              Text(
                AppConstants.appTitle,
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text('$countryCount țări', style: TextStyle(fontSize: 16)),
        ],
      ),
    );
  }
}
