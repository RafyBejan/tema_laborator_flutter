import 'package:flutter/material.dart';

class CountryListHeader extends StatelessWidget {
  final int countryCount;

  const CountryListHeader({super.key, required this.countryCount});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          Row(
            children: [
              const Icon(Icons.public, size: 40, color: Colors.white),
              const SizedBox(width: 12),
              const Text(
                'Enciclopedie Țări',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            '$countryCount țări',
            style: TextStyle(
              fontSize: 16,
              color: Colors.white.withOpacity(0.9),
            ),
          ),
        ],
      ),
    );
  }
}
