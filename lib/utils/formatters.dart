class CountryFormatter {
  static String formatPopulation(int population) {
    if (population >= 1000000000) {
      return '${(population / 1000000000).toStringAsFixed(2)} miliarde';
    } else if (population >= 1000000) {
      return '${(population / 1000000).toStringAsFixed(2)} milioane';
    } else if (population >= 1000) {
      return '${(population / 1000).toStringAsFixed(2)} mii';
    }
    return population.toString();
  }

  static String formatArea(double area) {
    if (area >= 1000000) {
      return '${(area / 1000000).toStringAsFixed(2)} mil km²';
    } else if (area >= 1000) {
      return '${(area / 1000).toStringAsFixed(0)} k km²';
    }
    return '${area.toStringAsFixed(0)} km²';
  }
}
