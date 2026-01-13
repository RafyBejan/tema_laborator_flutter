import 'package:flutter/material.dart';

class SearchBar extends StatelessWidget {
  final Function(String) onSearchChanged;

  const SearchBar({super.key, required this.onSearchChanged});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: TextField(
        onChanged: onSearchChanged,
        decoration: const InputDecoration(
          hintText: 'Caută țară sau capitală...',
          border: InputBorder.none,
          icon: Icon(Icons.search, color: Colors.blue),
        ),
      ),
    );
  }
}
