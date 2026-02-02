/// Clasa pentru formatarea datelor numerice
///
/// Contine metode statice pentru a formata populatia si suprafata
/// intr-un format uman-citibil (ex: "19.24 milioane")
class CountryFormatter {
  /// Formateaza populatia intr-un format uman-citibil
  ///
  /// Exemplu:
  /// - 19050000 -> "19.05 milioane"
  /// - 1350000000 -> "1.35 miliarde"
  /// - 50000 -> "50 mii"
  static String formatPopulation(int population) {
    if (population >= 1000000000) {
      // Miliarde: impart la 1 miliard si formatez cu 2 zecimale
      return '${(population / 1000000000).toStringAsFixed(2)} miliarde';
    } else if (population >= 1000000) {
      // Milioane: impart la 1 milion si formatez cu 2 zecimale
      return '${(population / 1000000).toStringAsFixed(2)} milioane';
    } else if (population >= 1000) {
      // Mii: impart la 1000 si formatez cu 2 zecimale
      return '${(population / 1000).toStringAsFixed(2)} mii';
    }
    // Mai putin de 1000: returnez numarul direct
    return population.toString();
  }

  /// Formateaza suprafata in format uman-citibil cu unitati potrivite
  ///
  /// Exemplu:
  /// - 238391 -> "238.39 k km²"
  /// - 17098242 -> "17.10 mil km²"
  /// - 100 -> "100 km²"
  static String formatArea(double area) {
    if (area >= 1000000) {
      // Milioane km²: impart la 1 milion cu 2 zecimale
      return '${(area / 1000000).toStringAsFixed(2)} mil km²';
    } else if (area >= 1000) {
      // Mii km²: impart la 1000 fara zecimale
      return '${(area / 1000).toStringAsFixed(0)} k km²';
    }
    // Km² normali: fara zecimale
    return '${area.toStringAsFixed(0)} km²';
  }
}
