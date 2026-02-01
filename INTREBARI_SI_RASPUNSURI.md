# 📝 Întrebări și Răspunsuri - Examen Proiect Flutter

## 🎯 Cum să te pregătești pentru întrebări

### Strategia de răspuns:
1. **Explică conceptul general** (ce face?)
2. **Arată unde se află în cod** (în ce fișier?)
3. **Exemplifică cu cod** (cum funcționează?)
4. **Menționează relațiile** (cu ce alte componente interacționează?)

---

## 📚 SECȚIUNEA 1: Întrebări despre Arhitectură

### Q1: "Explică-mi arhitectura aplicației. Ce pattern-uri ai folosit?"

**Răspuns complet**:
Am folosit o arhitectură **în straturi (Layered Architecture)** cu 3 niveluri:

1. **Presentation Layer** (UI):
   - Screens: `CountryListScreen`, `CountryDetailsScreen`
   - Widgets: `CountryCard`, `SearchBar`, etc.
   - Rol: Afișează datele și captează input-ul utilizatorului

2. **Business Logic Layer**:
   - Service: `CountryService` (gestionează API calls)
   - State Management: `setState()` în `CountryListScreen`
   - Rol: Procesează datele și implementează logica de filtrare

3. **Data Layer**:
   - Model: `Country` (structura datelor)
   - Data Source: REST Countries API + `HardcodedCountries` (fallback)
   - Rol: Furnizează și parsează datele

**Pattern-uri folosite**:
- **Factory Pattern**: `Country.fromJson()` pentru crearea obiectelor din JSON
- **Service Layer Pattern**: `CountryService` separă logica de business de UI
- **Widget Composition**: Componente mici, reutilizabile (Single Responsibility)
- **Callback Pattern**: `onTap`, `onSearchChanged` pentru comunicare parent-child

**Unde găsești în cod**:
- Models: `lib/models/country.dart`
- Services: `lib/services/country_service.dart`
- Screens: `lib/screens/`
- Widgets: `lib/widgets/`

---

### Q2: "De ce ai separat widget-urile în fișiere diferite?"

**Răspuns**:
Am aplicat principiul **Single Responsibility** și **Widget Composition** pentru:

1. **Reusability (Reutilizabilitate)**:
   - `InfoRow` este folosit de 7 ori în `CountryDetailsScreen`
   - Dacă vreau să schimb design-ul, schimb într-un singur loc

2. **Maintainability (Mentenanță)**:
   - Fiecare widget are un scop clar
   - Exemplu: `SearchBar` se ocupă DOAR de căutare
   - Dacă apare un bug în search, știu exact unde să caut

3. **Readability (Lizibilitate)**:
   - `country_list_screen.dart` ar fi avut 500+ linii
   - Acum are ~150 linii și e ușor de citit
   - `_buildCountryList()` folosește `CountryCard` - numele spune ce face

4. **Testability (Testare)**:
   - Pot testa `CountryCard` independent de `CountryListScreen`
   - Unit test-uri mai simple

**Exemplu concret**:
```dart
// ❌ GREȘIT - tot în CountryListScreen
Widget build() {
  return Scaffold(
    body: Column(
      children: [
        Container(...), // 50 linii pentru search bar
        Container(...), // 30 linii pentru region filter
        // ... 200+ linii
      ],
    ),
  );
}

// ✅ CORECT - componentizat
Widget build() {
  return Scaffold(
    body: Column(
      children: [
        SearchBar(onSearchChanged: ...),      // clar, concis
        RegionFilter(onRegionSelected: ...),  // auto-documentat
        _buildCountryList(),
      ],
    ),
  );
}
```

---

### Q3: "Ce este un StatefulWidget și când l-ai folosit?"

**Răspuns**:
**StatefulWidget** este un widget care își poate schimba starea în timp (se poate reconstrui cu date noi).

**Am folosit în**: `CountryListScreen`

**De ce?** Pentru că trebuie să gestionez:
- `allCountries` - se schimbă la încărcare
- `filteredCountries` - se schimbă la search/filtrare
- `isLoading` - true/false în funcție de încărcare
- `searchQuery` - se schimbă când user scrie
- `selectedRegion` - se schimbă când user selectează regiune

**Cum funcționează**:
```dart
class CountryListScreen extends StatefulWidget {
  @override
  State<CountryListScreen> createState() => _CountryListScreenState();
}

class _CountryListScreenState extends State<CountryListScreen> {
  List<Country> allCountries = [];  // STARE MUTABILĂ
  
  void loadCountries() async {
    allCountries = await CountryService.fetchCountries();
    setState(() {});  // REBUILD UI cu date noi
  }
}
```

**Când SETSTATE()**:
- După încărcare: `setState(() => isLoading = false)`
- După filtrare: `setState(() { filteredCountries = ... })`
- După search: `setState()` în callback-ul `filterCountries()`

**Alternativa** (StatelessWidget):
- `CountryDetailsScreen` nu are stare care se schimbă
- Primește un `Country` și îl afișează
- Nu trebuie `setState()` → StatelessWidget

---

## 📡 SECȚIUNEA 2: Întrebări despre API și Date

### Q4: "Explică-mi cum aduci datele de la API"

**Răspuns complet**:

**Locație**: `lib/services/country_service.dart`

**Pașii**:
```dart
static Future<List<Country>> fetchCountries() async {
  try {
    // PAS 1: Fac HTTP GET request
    final response = await http.get(
      Uri.parse('https://restcountries.com/v3.1/all')
    );
    
    // PAS 2: Verific dacă request-ul a reușit
    if (response.statusCode == 200) {
      // PAS 3: Parsez JSON în List<dynamic>
      List<dynamic> data = json.decode(response.body);
      
      // PAS 4: Convertesc fiecare JSON în obiect Country
      List<Country> countries = data
          .map((json) => Country.fromJson(json))
          .toList();
      
      // PAS 5: Sortez alfabetic
      countries.sort((a, b) => a.name.compareTo(b.name));
      
      return countries;
    }
    throw Exception('Failed to load countries');
  } catch (e) {
    // PAS 6: Dacă eșuează, returnez date hardcodate
    return HardcodedCountries.getCountries();
  }
}
```

**Când se apelează**: În `initState()` din `CountryListScreen`:
```dart
@override
void initState() {
  super.initState();
  loadCountries();  // ← aici
}

Future<void> loadCountries() async {
  setState(() => isLoading = true);
  allCountries = await CountryService.fetchCountries();  // ← apel API
  filteredCountries = allCountries;
  setState(() => isLoading = false);
}
```

**Package folosit**: `http: ^1.2.0` (declarat în `pubspec.yaml`)

**Error Handling**:
- Try-catch captează toate erorile (no internet, server down, timeout)
- Fallback la `HardcodedCountries` garantează funcționare offline

---

### Q5: "Cum transformi JSON-ul în obiect Country?"

**Răspuns**:

**Metoda**: `Country.fromJson()` în `lib/models/country.dart`

**Problema**: JSON-ul de la API are structură complexă:
```json
{
  "name": { "common": "Romania", "official": "..." },
  "currencies": { "RON": { "name": "Romanian leu", "symbol": "lei" } },
  "languages": { "ron": "Romanian" }
}
```

**Soluția - Factory Constructor**:
```dart
factory Country.fromJson(Map<String, dynamic> json) {
  // EXTRAGE MONEDA (poate fi mai multe, luăm prima)
  String currency = 'N/A';
  if (json['currencies'] != null) {
    var currencies = json['currencies'] as Map<String, dynamic>;
    if (currencies.isNotEmpty) {
      var firstCurrency = currencies.values.first;
      currency = '${firstCurrency['name']} (${firstCurrency['symbol'] ?? ''})';
    }
  }
  
  // EXTRAGE LIMBI (toate, separate prin virgulă)
  String language = 'N/A';
  if (json['languages'] != null) {
    var languages = json['languages'] as Map<String, dynamic>;
    if (languages.isNotEmpty) {
      language = languages.values.join(', ');
    }
  }
  
  return Country(
    name: json['name']['common'] ?? '',                    // nested object
    capital: json['capital']?[0] ?? 'N/A',                 // array
    flag: json['flags']['png'] ?? '',                      // nested
    population: json['population'] ?? 0,                   // direct
    region: json['region'] ?? '',
    currency: currency,                                    // procesat
    language: language,                                    // procesat
    area: (json['area'] ?? 0).toDouble(),                 // conversion
    subregion: json['subregion'] ?? '',
  );
}
```

**De ce Factory Constructor?**
- Permite logică complexă în constructor (nu e posibil în constructor normal)
- Poate returna `null` sau arunca excepții
- Convenție pentru parsare JSON în Dart/Flutter

**Gestionare null**:
- `??` operator: dacă e null, folosește valoare default
- `json['capital']?[0]`: safe navigation, nu crăpă dacă capital e null

---

### Q6: "Ce se întâmplă dacă API-ul pică?"

**Răspuns**:

**Mecanismul de Fallback**:
```dart
try {
  // încearcă API
  final response = await http.get(...);
  if (response.statusCode == 200) {
    return parseCountries(response.body);
  }
  throw Exception('Failed');
} catch (e) {
  // FALLBACK la date hardcodate
  return HardcodedCountries.getCountries();
}
```

**Avantaje**:
1. **Aplicația nu crăpă** - user-ul vede date oricum
2. **Testare offline** - pot dezvolta fără internet
3. **UX mai bun** - loading → date, nu loading → eroare

**Date Hardcodate** (`lib/data/hardcoded_countries.dart`):
- Lista cu ~10-20 țări predefinite
- Aceeași structură `Country` ca la API
- Exemplu: România, SUA, Japonia, etc.

**Când se activează**:
- No internet connection
- API down (status code != 200)
- Timeout
- Invalid JSON response
- Orice altă excepție

---

## 🔍 SECȚIUNEA 3: Întrebări despre Funcționalități

### Q7: "Cum funcționează căutarea?"

**Răspuns**:

**Locație**: `country_list_screen.dart` → `filterCountries()`

**Mecanismul**:
```dart
// STAREA
String searchQuery = '';
List<Country> allCountries = [];      // TOATE țările (neschimbate)
List<Country> filteredCountries = [];  // Afișate în UI

// FUNCȚIA DE FILTRARE
void filterCountries() {
  setState(() {
    filteredCountries = allCountries.where((country) {
      // CONDIȚIE 1: Match search query
      bool matchesSearch = 
          searchQuery.isEmpty ||  // dacă nu caută nimic, accept
          country.name.toLowerCase().contains(searchQuery.toLowerCase()) ||
          country.capital.toLowerCase().contains(searchQuery.toLowerCase());
      
      // CONDIȚIE 2: Match region
      bool matchesRegion = 
          selectedRegion == 'Toate' || 
          country.region == selectedRegion;
      
      // AMBELE condiții trebuie îndeplinite (AND)
      return matchesSearch && matchesRegion;
    }).toList();
  });
}
```

**Fluxul complet**:
```
1. User scrie "rom" în SearchBar
   ↓
2. SearchBar.onSearchChanged("rom")
   ↓
3. searchQuery = "rom"
   ↓
4. filterCountries()
   ↓
5. allCountries.where() filtrează:
   - România ✅ (name contains "rom")
   - Italy ❌
   - Roman Empire (historical) ✅
   ↓
6. setState() → rebuild ListView
   ↓
7. User vede doar 2 rezultate
```

**Case-insensitive**: `.toLowerCase()` pe ambele părți

**Căutare în 2 câmpuri**: `name` OR `capital`
- "buc" → găsește România (București)
- "paris" → găsește Franța

**Păstrare date originale**:
- `allCountries` NICIODATĂ modificat
- Mereu putem reveni la lista completă (clear search)

---

### Q8: "Cum funcționează filtrarea pe regiuni?"

**Răspuns**:

**Regiunile disponibile**:
```dart
final List<String> regions = [
  'Toate',    // default - afișează tot
  'Africa',
  'America',
  'Asia',
  'Europe',
  'Oceania',
];
```

**Widget**: `RegionFilter` (`lib/widgets/region_filter.dart`)
```dart
Row(
  children: regions.map((region) {
    bool isSelected = region == selectedRegion;
    return ElevatedButton(
      style: ButtonStyle(
        backgroundColor: isSelected 
            ? Colors.blue        // selectat
            : Colors.white,      // neselectat
      ),
      onPressed: () => onRegionSelected(region),
      child: Text(region),
    );
  }).toList(),
)
```

**Logica de filtrare**:
```dart
void filterCountries() {
  setState(() {
    filteredCountries = allCountries.where((country) {
      // ...
      bool matchesRegion = 
          selectedRegion == 'Toate' ||           // ← "Toate" = skip filter
          country.region == selectedRegion;      // ← exact match
      return matchesSearch && matchesRegion;
    }).toList();
  });
}
```

**Fluxul**:
```
1. User tap "Europe"
   ↓
2. RegionFilter.onRegionSelected("Europe")
   ↓
3. CountryListScreen.setState(() {
     selectedRegion = "Europe";
     filterCountries();
   })
   ↓
4. Filter: păstrează doar country.region == "Europe"
   ↓
5. Rebuild → afișează ~50 țări europene
```

**Combinare cu Search**:
- Search "fra" + Region "Europe" → Franța ✅
- Search "fra" + Region "Africa" → 0 rezultate
- Ambele filtre aplicate simultan (AND logic)

---

### Q9: "Cum navighezi între ecrane?"

**Răspuns**:

**Navigator.push()** - Stack-based navigation

**Cod în CountryListScreen**:
```dart
CountryCard(
  country: filteredCountries[index],
  onTap: () {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CountryDetailsScreen(
          country: filteredCountries[index],  // ← pasez obiectul Country
        ),
      ),
    );
  },
)
```

**Cod în CountryDetailsScreen**:
```dart
IconButton(
  onPressed: () => Navigator.pop(context),  // ← înapoi
  icon: Icon(Icons.arrow_back),
)
```

**Cum funcționează Navigator**:
- **Stack**: ListScreen → (push) → DetailsScreen
- **Push**: Adaugă ecran nou pe stack
- **Pop**: Scoate ecranul curent, revine la anterior

**Pasarea datelor**:
```dart
// TRIMITERE
CountryDetailsScreen(country: selectedCountry)

// PRIMIRE (în DetailsScreen)
class CountryDetailsScreen extends StatelessWidget {
  final Country country;  // ← primit prin constructor
  
  const CountryDetailsScreen({required this.country});
}
```

**Animații**: MaterialPageRoute → slide animation (platform-specific)

**Alternative** (nu le-am folosit):
- Named routes: `Navigator.pushNamed('/details')`
- go_router package
- Navigator 2.0 (Declarative)

---

## 🎨 SECȚIUNEA 4: Întrebări despre UI

### Q10: "Explică-mi cum afișezi lista de țări"

**Răspuns**:

**Widget**: `ListView.builder` în `CountryListScreen`

**De ce ListView.builder (nu ListView cu children)**:
```dart
// ❌ GREȘIT pentru liste mari
ListView(
  children: filteredCountries.map((country) => 
    CountryCard(country: country)
  ).toList(),  // Creează 250 widget-uri SIMULTAN
)

// ✅ CORECT - Lazy loading
ListView.builder(
  itemCount: filteredCountries.length,
  itemBuilder: (context, index) {
    return CountryCard(
      country: filteredCountries[index],
      onTap: () => navigateToDetails(index),
    );
  },
)
```

**Avantaje ListView.builder**:
1. **Performance**: Creează doar widget-urile vizibile pe ecran
2. **Memory**: Nu încarcă 250 țări simultan
3. **Scroll smooth**: Build-ul e on-demand

**Structura completă**:
```dart
Widget _buildCountryList() {
  if (isLoading) {
    return LoadingIndicator(message: 'Se încarcă...');
  }
  
  if (filteredCountries.isEmpty) {
    return EmptyState(message: 'Nicio țară găsită');
  }
  
  return Expanded(  // ← ia spațiul rămas (după header, search, filter)
    child: ListView.builder(
      padding: EdgeInsets.all(16),
      itemCount: filteredCountries.length,
      itemBuilder: (context, index) {
        return CountryCard(
          country: filteredCountries[index],
          onTap: () => navigateToDetails(filteredCountries[index]),
        );
      },
    ),
  );
}
```

**CountryCard widget** (`lib/widgets/country_card.dart`):
- Steag (80x60, ClipRRect pentru border radius)
- Nume (font 18, bold)
- Capitală (font 14, grey)
- Populație (formatată, font 14)
- Arrow icon (sugestie navigare)

**Expanded**: Ocupă restul spațiului vertical disponibil

---

### Q11: "Cum formatezi populația și suprafața?"

**Răspuns**:

**Locație**: `lib/utils/formatters.dart`

**Clasa utilitară**:
```dart
class CountryFormatter {
  // Formatare populație: 19237691 → "19.237.691"
  static String formatPopulation(int population) {
    return population
        .toString()
        .replaceAllMapped(
          RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
          (Match m) => '${m[1]}.',
        );
  }
  
  // Formatare suprafață: 238391.0 → "238.391 km²"
  static String formatArea(double area) {
    return '${formatPopulation(area.toInt())} km²';
  }
}
```

**Regex explained**: `r'(\d{1,3})(?=(\d{3})+(?!\d))'`
- `\d{1,3}`: 1-3 cifre
- `(?=(\d{3})+(?!\d))`: urmate de grupuri de 3 cifre (lookahead)
- Adaugă `.` între grupuri

**Utilizare în UI**:
```dart
InfoRow(
  icon: Icons.people,
  label: 'Populație',
  value: CountryFormatter.formatPopulation(country.population),
)
```

**Rezultat**:
- Input: `19237691`
- Output: `"19.237.691"` ← lizibil!

**Alternativă** (nu am folosit):
```dart
import 'package:intl/intl.dart';
NumberFormat('#,###').format(population);  // 19,237,691
```

---

### Q12: "De ce folosești const în unele widget-uri?"

**Răspuns**:

**Const** = widget creat la compile-time, nu la runtime

**Exemplu**:
```dart
// ✅ CONST - eficient
const SizedBox(height: 16)

// ❌ NON-CONST - recreat la fiecare rebuild
SizedBox(height: 16)
```

**Când folosesc const**:
```dart
return Column(
  children: [
    const SizedBox(height: 16),          // ← const (hardcoded value)
    const ApiFooter(),                   // ← const (no parameters)
    const Icon(Icons.arrow_back),        // ← const
    Text('${country.name}'),             // ❌ NU CONST (dynamic value)
    CountryCard(country: data[index]),   // ❌ NU CONST (diferit per item)
  ],
);
```

**Beneficii**:
1. **Performance**: Nu se reconstruiește la setState()
2. **Memory**: O singură instanță în memorie
3. **Flutter optimizează**: Skip rebuild pentru const widgets

**Constructor const**:
```dart
class ApiFooter extends StatelessWidget {
  const ApiFooter({super.key});  // ← const constructor
  
  @override
  Widget build(BuildContext context) {
    return const Text('Data by REST Countries API');
  }
}
```

**Regula**: Dacă widget-ul NU depinde de date dinamice → folosește `const`

---

## 🔧 SECȚIUNEA 5: Întrebări despre Modificări

### Q13: "Cum ai adăuga o funcționalitate de favorite?"

**Răspuns (cu cod exact)**:

**PAS 1: Modifică modelul**
```dart
// lib/models/country.dart
class Country {
  final String name;
  // ... alte proprietăți
  bool isFavorite;  // ← ADAUGĂ ACEST CÂMP

  Country({
    required this.name,
    // ...
    this.isFavorite = false,  // ← default false
  });
}
```

**PAS 2: Creează service pentru persistență**
```dart
// lib/services/favorites_service.dart (NOU FIȘIER)
import 'package:shared_preferences/shared_preferences.dart';

class FavoritesService {
  static const String _key = 'favorite_countries';
  
  static Future<void> toggleFavorite(String countryName) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> favorites = prefs.getStringList(_key) ?? [];
    
    if (favorites.contains(countryName)) {
      favorites.remove(countryName);
    } else {
      favorites.add(countryName);
    }
    
    await prefs.setStringList(_key, favorites);
  }
  
  static Future<List<String>> getFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(_key) ?? [];
  }
}
```

**PAS 3: Adaugă buton în CountryCard**
```dart
// lib/widgets/country_card.dart
Widget _buildInfo() {
  return Expanded(
    child: Column(
      children: [
        // ... nume, capitală, populație
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            IconButton(
              icon: Icon(
                country.isFavorite ? Icons.favorite : Icons.favorite_border,
                color: country.isFavorite ? Colors.red : Colors.grey,
              ),
              onPressed: onFavoriteToggle,  // ← callback nou
            ),
          ],
        ),
      ],
    ),
  );
}
```

**PAS 4: Gestionează starea în CountryListScreen**
```dart
// lib/screens/country_list_screen.dart
Future<void> toggleFavorite(int index) async {
  String countryName = filteredCountries[index].name;
  await FavoritesService.toggleFavorite(countryName);
  
  setState(() {
    filteredCountries[index].isFavorite = 
        !filteredCountries[index].isFavorite;
  });
}

// În ListView.builder:
CountryCard(
  country: filteredCountries[index],
  onTap: () => navigateToDetails(index),
  onFavoriteToggle: () => toggleFavorite(index),  // ← adaugă
)
```

**PAS 5: Adaugă filtru "Favorite"**
```dart
final List<String> regions = [
  'Toate',
  'Favorite',  // ← NOU
  'Africa',
  // ...
];

void filterCountries() {
  setState(() {
    filteredCountries = allCountries.where((country) {
      // ...
      bool matchesRegion = 
          selectedRegion == 'Toate' ||
          (selectedRegion == 'Favorite' && country.isFavorite) ||  // ← NOU
          country.region == selectedRegion;
      return matchesSearch && matchesRegion;
    }).toList();
  });
}
```

**Unde modifici**:
1. ✏️ `models/country.dart` - adaugă câmp `isFavorite`
2. ➕ `services/favorites_service.dart` - fișier nou
3. ✏️ `widgets/country_card.dart` - adaugă IconButton favorite
4. ✏️ `screens/country_list_screen.dart` - adaugă `toggleFavorite()`
5. ✏️ `pubspec.yaml` - deja ai `shared_preferences` instalat!

---

### Q14: "Cum ai schimba sortarea în descrescător după populație?"

**Răspuns**:

**Locație**: `country_list_screen.dart` → funcția `filterCountries()`

**MODIFICARE**:
```dart
void filterCountries() {
  setState(() {
    filteredCountries = allCountries.where((country) {
      // ... logica de filtrare
    }).toList();
    
    // ← ADAUGĂ SORTARE
    filteredCountries.sort((a, b) => 
      b.population.compareTo(a.population)  // descrescător
    );
  });
}
```

**Explicație**:
- `a.compareTo(b)` → crescător (mic → mare)
- `b.compareTo(a)` → descrescător (mare → mic)
- Se aplică DUPĂ filtrare

**Îmbunătățire - Sortare selectabilă**:
```dart
// Adaugă variabilă de stare
String sortBy = 'name';  // 'name', 'population', 'area'

void filterCountries() {
  setState(() {
    // ... filtrare
    
    // Sortare dinamică
    switch (sortBy) {
      case 'name':
        filteredCountries.sort((a, b) => a.name.compareTo(b.name));
        break;
      case 'population':
        filteredCountries.sort((a, b) => b.population.compareTo(a.population));
        break;
      case 'area':
        filteredCountries.sort((a, b) => b.area.compareTo(a.area));
        break;
    }
  });
}

// Adaugă DropdownButton în UI
DropdownButton<String>(
  value: sortBy,
  items: [
    DropdownMenuItem(value: 'name', child: Text('Nume')),
    DropdownMenuItem(value: 'population', child: Text('Populație')),
    DropdownMenuItem(value: 'area', child: Text('Suprafață')),
  ],
  onChanged: (value) {
    setState(() {
      sortBy = value!;
      filterCountries();
    });
  },
)
```

**Unde modifici**: `lib/screens/country_list_screen.dart`

---

### Q15: "Cum ai afișa o hartă pentru fiecare țară?"

**Răspuns**:

**PAS 1: Adaugă package în pubspec.yaml**
```yaml
dependencies:
  google_maps_flutter: ^2.5.0
  url_launcher: ^6.2.1  # pentru link extern
```

**PAS 2: Extrage coordonate în Country model**
```dart
// lib/models/country.dart
class Country {
  // ...
  final double latitude;
  final double longitude;
  
  factory Country.fromJson(Map<String, dynamic> json) {
    return Country(
      // ...
      latitude: json['latlng']?[0] ?? 0.0,
      longitude: json['latlng']?[1] ?? 0.0,
    );
  }
}
```

**PAS 3: Creează widget pentru hartă**
```dart
// lib/widgets/country_map.dart (NOU FIȘIER)
import 'package:google_maps_flutter/google_maps_flutter.dart';

class CountryMap extends StatelessWidget {
  final double latitude;
  final double longitude;
  
  const CountryMap({
    required this.latitude,
    required this.longitude,
  });
  
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      margin: EdgeInsets.all(16),
      child: GoogleMap(
        initialCameraPosition: CameraPosition(
          target: LatLng(latitude, longitude),
          zoom: 5,
        ),
        markers: {
          Marker(
            markerId: MarkerId('country'),
            position: LatLng(latitude, longitude),
          ),
        },
      ),
    );
  }
}
```

**PAS 4: Adaugă în CountryDetailsScreen**
```dart
// lib/screens/country_details_screen.dart
Column(
  children: [
    FlagCard(flagUrl: country.flag),
    CountryMap(  // ← ADAUGĂ
      latitude: country.latitude,
      longitude: country.longitude,
    ),
    _buildGeneralInfo(),
    // ...
  ],
)
```

**Alternativă simplă (fără Google Maps)**:
```dart
// Deschide Google Maps în browser
import 'package:url_launcher/url_launcher.dart';

ElevatedButton(
  onPressed: () {
    final url = 'https://www.google.com/maps/@${country.latitude},${country.longitude},7z';
    launchUrl(Uri.parse(url));
  },
  child: Text('Vezi pe Hartă'),
)
```

**Unde modifici**:
1. ✏️ `pubspec.yaml` - adaugă packages
2. ✏️ `models/country.dart` - adaugă lat/lng
3. ➕ `widgets/country_map.dart` - fișier nou
4. ✏️ `screens/country_details_screen.dart` - include widget-ul

---

## 🐛 SECȚIUNEA 6: Întrebări despre Debugging

### Q16: "Cum ai debuga dacă căutarea nu funcționează?"

**Răspuns - Proces Sistematic**:

**PAS 1: Verifică dacă funcția e apelată**
```dart
// lib/widgets/search_bar.dart
TextField(
  onChanged: (value) {
    print('🔍 SearchBar changed: "$value"');  // ← DEBUG 1
    widget.onSearchChanged(value);
  },
)
```

**PAS 2: Verifică dacă query-ul ajunge în parent**
```dart
// lib/screens/country_list_screen.dart
SearchBar(
  onSearchChanged: (value) {
    print('📱 CountryListScreen received: "$value"');  // ← DEBUG 2
    searchQuery = value;
    filterCountries();
  },
)
```

**PAS 3: Verifică logica de filtrare**
```dart
void filterCountries() {
  print('🔎 Filtering with query: "$searchQuery"');  // ← DEBUG 3
  print('📊 All countries: ${allCountries.length}');  // ← DEBUG 4
  
  setState(() {
    filteredCountries = allCountries.where((country) {
      bool matchesSearch = 
          searchQuery.isEmpty ||
          country.name.toLowerCase().contains(searchQuery.toLowerCase());
      
      // DEBUG per country
      if (searchQuery.isNotEmpty) {
        print('  ${country.name}: $matchesSearch');  // ← DEBUG 5
      }
      
      return matchesSearch && matchesRegion;
    }).toList();
  });
  
  print('✅ Filtered: ${filteredCountries.length}');  // ← DEBUG 6
}
```

**PAS 4: Folosește Flutter DevTools**
```
flutter run
→ în terminal apare link: http://127.0.0.1:9100/...
→ deschide în browser
→ Tab "Widget Inspector" → vezi widget tree
→ Tab "Debugger" → breakpoints
```

**PAS 5: Verifică rebuild-ul**
```dart
@override
Widget build(BuildContext context) {
  print('🏗️ CountryListScreen rebuild - filtered: ${filteredCountries.length}');
  // ... rest of build
}
```

**Erori comune**:
1. ❌ Uiți `setState()` → UI nu se actualizează
2. ❌ Callback nu e trimis corect → `onSearchChanged: null`
3. ❌ Case sensitivity → "ROMANIA" != "romania"
4. ❌ Filtrezi `allCountries` în loc de `filteredCountries`

**Debugging checklist**:
- ✅ Callback-ul e apelat?
- ✅ `searchQuery` se actualizează?
- ✅ `filterCountries()` rulează?
- ✅ `setState()` e apelat?
- ✅ `filteredCountries` are date noi?
- ✅ ListView se reconstruiește?

---

### Q17: "Cum ai testa dacă API-ul funcționează?"

**Răspuns**:

**METODA 1: Print în CountryService**
```dart
static Future<List<Country>> fetchCountries() async {
  print('🌐 Starting API call...');
  
  try {
    final response = await http.get(Uri.parse('$baseUrl/all'));
    print('📡 Response code: ${response.statusCode}');
    print('📦 Response length: ${response.body.length} bytes');
    
    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      print('✅ Parsed ${data.length} countries');
      // ...
    }
  } catch (e) {
    print('❌ API Error: $e');
    // ...
  }
}
```

**METODA 2: Test cu Postman/Browser**
- Deschide: `https://restcountries.com/v3.1/all`
- Verifică: Primești JSON array?
- Status: 200 OK?

**METODA 3: Flutter DevTools Network Tab**
```
flutter run
→ DevTools → Tab "Network"
→ Vezi toate request-urile HTTP
→ Status, duration, response size
```

**METODA 4: Unit Test**
```dart
// test/services/country_service_test.dart (NOU FIȘIER)
import 'package:flutter_test/flutter_test.dart';
import 'package:tema_laborator/services/country_service.dart';

void main() {
  test('fetchCountries returns data', () async {
    final countries = await CountryService.fetchCountries();
    
    expect(countries, isNotEmpty);
    expect(countries.first.name, isNotEmpty);
    expect(countries.length, greaterThan(100));
  });
}
```

**Run test**: `flutter test`

**METODA 5: Mock HTTP pentru testing**
```dart
// test/services/country_service_test.dart
import 'package:mockito/mockito.dart';
import 'package:http/http.dart' as http;

void main() {
  test('handles API failure gracefully', () async {
    // Simulează API failure
    when(mockHttp.get(any)).thenThrow(Exception('Network error'));
    
    final countries = await CountryService.fetchCountries();
    
    // Verifică că returnează hardcoded data
    expect(countries, isNotEmpty);
  });
}
```

**Verificare vizuală în UI**:
```dart
// Adaugă indicator în CountryListHeader
CountryListHeader(
  countryCount: filteredCountries.length,
  isFromAPI: allCountries.length > 50,  // ← indicator
)

// În widget:
Text(
  isFromAPI ? '🌐 Date de la API' : '💾 Date locale',
  style: TextStyle(fontSize: 12, color: Colors.grey),
)
```

---

## 💡 SECȚIUNEA 7: Întrebări Conceptuale

### Q18: "Care e diferența între StatefulWidget și StatelessWidget?"

**Răspuns complet**:

| Aspect | StatelessWidget | StatefulWidget |
|--------|----------------|----------------|
| **Stare** | Imutabilă (nu se schimbă) | Mutabilă (se poate schimba) |
| **Rebuild** | Doar când parent-ul se reconstruiește | Prin `setState()` |
| **Ciclu de viață** | Doar `build()` | `initState()`, `dispose()`, `didUpdateWidget()` |
| **Performanță** | Mai rapid (mai simplu) | Puțin mai lent (gestionează stare) |
| **Când folosești** | Date statice, UI fix | Date dinamice, interacțiuni |

**Exemplu StatelessWidget** (din proiect):
```dart
class CountryDetailsScreen extends StatelessWidget {
  final Country country;  // ← IMUTABIL (final)
  
  const CountryDetailsScreen({required this.country});
  
  @override
  Widget build(BuildContext context) {
    // Afișează country, nu se schimbă
    return Scaffold(...);
  }
}
```
**De ce Stateless?** Primește un `Country` și îl afișează. Nu are nevoie să modifice date.

**Exemplu StatefulWidget** (din proiect):
```dart
class CountryListScreen extends StatefulWidget {
  @override
  State<CountryListScreen> createState() => _CountryListScreenState();
}

class _CountryListScreenState extends State<CountryListScreen> {
  List<Country> filteredCountries = [];  // ← MUTABIL (var/non-final)
  bool isLoading = true;
  
  void filterCountries() {
    setState(() {  // ← REBUILD cu date noi
      filteredCountries = ...;
    });
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(...);
  }
}
```
**De ce Stateful?** Datele se schimbă (loading → loaded, search query, etc.)

**Lifecycle Stateful**:
```
1. constructor() → creează widget
2. createState() → creează State object
3. initState() → inițializare (API call aici)
4. build() → construiește UI
5. setState() → marchează că trebuie rebuild
6. build() → rebuild cu date noi
7. dispose() → cleanup (controllers, listeners)
```

---

### Q19: "Ce e un Future în Dart și cum îl folosești?"

**Răspuns**:

**Definiție**: `Future<T>` = o valoare care va fi disponibilă în viitor (operație asincronă)

**Analogie**: Comanzi pizza
- Future<Pizza> = promisiunea că vei primi pizza
- await = aștepți să sosească pizza
- then() = ce faci când pizza sosește

**În proiect**:
```dart
// Funcție care returnează Future
Future<List<Country>> fetchCountries() async {
  final response = await http.get(...);  // ← așteaptă răspuns HTTP
  return parseCountries(response);
}

// Folosire cu await
void loadCountries() async {  // ← async permite await
  setState(() => isLoading = true);
  
  allCountries = await CountryService.fetchCountries();  // ← așteaptă
  
  setState(() => isLoading = false);
}
```

**3 moduri de a folosi Future**:

**1. await (recomandat)**:
```dart
void loadData() async {
  List<Country> countries = await fetchCountries();
  print(countries.length);
}
```

**2. then() (stil vechi)**:
```dart
void loadData() {
  fetchCountries().then((countries) {
    print(countries.length);
  });
}
```

**3. FutureBuilder (în UI)**:
```dart
FutureBuilder<List<Country>>(
  future: CountryService.fetchCountries(),
  builder: (context, snapshot) {
    if (snapshot.connectionState == ConnectionState.waiting) {
      return LoadingIndicator();
    }
    if (snapshot.hasData) {
      return ListView(children: ...);
    }
    return ErrorWidget();
  },
)
```

**Error Handling**:
```dart
try {
  List<Country> countries = await fetchCountries();
} catch (e) {
  print('Error: $e');
}
```

**De ce async/await**:
- API calls (http.get)
- File I/O
- Database queries
- Orice operație care durează (I/O bound)

**Reguli**:
- Funcție cu `await` → trebuie `async`
- `async` funcție → returnează automat `Future`
- `await` DOAR în funcție `async`

---

### Q20: "Cum funcționează setState() și de ce e important?"

**Răspuns**:

**Ce face setState()**:
1. Execută codul din interior
2. Marchează widget-ul ca "dirty" (trebuie reconstruit)
3. Programează un rebuild în următorul frame
4. Flutter apelează `build()` din nou

**Exemplu din proiect**:
```dart
void filterCountries() {
  // ❌ GREȘIT - UI nu se actualizează
  filteredCountries = allCountries.where(...).toList();
  
  // ✅ CORECT - UI se actualizează
  setState(() {
    filteredCountries = allCountries.where(...).toList();
  });
}
```

**Ce se întâmplă intern**:
```
User scrie în SearchBar
   ↓
filterCountries() apelat
   ↓
setState(() { filteredCountries = ... })
   ↓
Flutter: "Widget-ul e dirty, trebuie rebuild"
   ↓
Flutter apelează build()
   ↓
ListView se reconstruiește cu filteredCountries noi
   ↓
UI afișează rezultate noi
```

**Când NU trebuie setState()**:
```dart
// StatelessWidget - nu există setState
class MyWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Rebuild-ul vine de la parent
  }
}
```

**Performance - ce să pui în setState()**:
```dart
// ❌ GREȘIT - calcul greu în setState
setState(() {
  for (var i = 0; i < 1000000; i++) {
    // calcul complex
  }
  filteredCountries = result;
});

// ✅ CORECT - calcul în afară, doar assignment în setState
var result = [];
for (var i = 0; i < 1000000; i++) {
  // calcul complex
}
setState(() {
  filteredCountries = result;  // doar assignment
});
```

**Rebuild optimization**:
```dart
@override
Widget build(BuildContext context) {
  return Column(
    children: [
      const Text('Titlu'),  // ← const = nu se rebuild
      Text('Contor: $counter'),  // ← se rebuild la setState
    ],
  );
}
```

**Debugging setState()**:
```dart
setState(() {
  print('🔄 setState called');
  print('  Before: ${filteredCountries.length}');
  filteredCountries = ...;
  print('  After: ${filteredCountries.length}');
});
```

---

## 🎓 Cum să răspunzi la examen

### Structura răspunsului ideal:

1. **Definiție** (1 propoziție): "X este un Y care face Z"
2. **Unde în cod** (locație): "Se găsește în lib/services/country_service.dart"
3. **Cum funcționează** (pași): "Întâi...apoi...în final..."
4. **Exemplu de cod** (4-10 linii): Snippet relevant
5. **De ce e important** (beneficii): "Asta permite/garantează..."

### Exemple:

**❌ Răspuns slab**:
> "Folosesc API-ul pentru a lua date."

**✅ Răspuns excelent**:
> "Am implementat un service layer în `country_service.dart` care face request HTTP către REST Countries API. Funcția `fetchCountries()` returnează un `Future<List<Country>>` și include error handling cu fallback la date hardcodate. Asta garantează că aplicația funcționează și offline."

---

## 📌 Întrebări Rapide (Răspunsuri Scurte)

**Q: Câte ecrane are aplicația?**  
A: 2 - `CountryListScreen` (listă) și `CountryDetailsScreen` (detalii)

**Q: Ce package folosești pentru API?**  
A: `http: ^1.2.0`

**Q: Unde se află datele de fallback?**  
A: `lib/data/hardcoded_countries.dart`

**Q: Cum sortezi țările?**  
A: `countries.sort((a, b) => a.name.compareTo(b.name))`

**Q: Câte widget-uri custom ai creat?**  
A: 10 - CountryCard, SearchBar, RegionFilter, FlagCard, InfoRow, InfoSection, CountryListHeader, LoadingIndicator, EmptyState, ApiFooter

**Q: Ce tip de navigare folosești?**  
A: Stack-based navigation cu `Navigator.push()` și `Navigator.pop()`

**Q: Ce înseamnă Material 3?**  
A: Ultima versiune a Material Design (Google), cu culori și componente modernizate

**Q: Câte proprietăți are modelul Country?**  
A: 9 - name, capital, flag, population, region, currency, language, area, subregion

**Q: Unde setezi tema aplicației?**  
A: În `main.dart`, în `MaterialApp.theme`

**Q: Cum verifici dacă aplicația e offline?**  
A: Try-catch în `fetchCountries()` - dacă crăpă API-ul, returnează date hardcodate

---

**📖 Sfat final**: Citește `LOGICA_PROIECT.md` pentru diagrame și relații între componente!

