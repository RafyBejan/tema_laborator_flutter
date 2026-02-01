import 'package:flutter/material.dart';
import '../common/constants.dart';

class SearchBar extends StatelessWidget {
  final Function(String) onSearchChanged;

  const SearchBar({super.key, required this.onSearchChanged});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: AppConstants.marginNormal),
      padding: const EdgeInsets.symmetric(
        horizontal: AppConstants.paddingNormal,
      ),
      decoration: BoxDecoration(
        color: AppConstants.backgroundColor,
        borderRadius: BorderRadius.circular(AppConstants.borderRadiusLarge),
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
        decoration: InputDecoration(
          hintText: AppConstants.searchPlaceholder,
          border: InputBorder.none,
          icon: const Icon(Icons.search, color: AppConstants.primaryColor),
        ),
      ),
    );
  }
}
