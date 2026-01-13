import 'package:flutter/material.dart';

class ApiFooter extends StatelessWidget {
  const ApiFooter({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(0.3), width: 2),
      ),
      child: Row(
        children: [
          const Icon(Icons.info_outline, color: Colors.white, size: 28),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              'Date furnizate de REST Countries API',
              style: TextStyle(
                color: Colors.white.withOpacity(0.9),
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
