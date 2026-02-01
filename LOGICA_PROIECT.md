# Logica și Arhitectura Proiectului - Enciclopedie Țări

## 📋 Descriere Generală
Aplicație Flutter pentru afișarea informațiilor despre țări din întreaga lume folosind REST Countries API.

## 🏗️ Arhitectura Proiectului

### Structura pe Straturi (Layered Architecture)

```
┌─────────────────────────────────────┐
│         PRESENTATION LAYER          │
│  (UI - Screens & Widgets)          │
│  ▶ CountryListScreen               │
│  ▶ CountryDetailsScreen            │
│  ▶ Widgets (Cards, Headers, etc)   │
└─────────────────────────────────────┘
              ↓ ↑
┌─────────────────────────────────────┐
│         BUSINESS LOGIC LAYER        │
│  (Services & State Management)      │
│  ▶ CountryService                  │
│  ▶ Filtering Logic                 │
│  ▶ Search Logic                    │
└─────────────────────────────────────┘
              ↓ ↑
┌─────────────────────────────────────┐
│           DATA LAYER                │
│  (Models & Data Sources)            │
│  ▶ Country Model                   │
│  ▶ REST API (restcountries.com)    │
│  ▶ Hardcoded Fallback Data         │
└─────────────────────────────────────┘
```

## 📂 Structura Detaliată a Fișierelor

### 1️⃣ **main.dart** (Entry Point)
- **Scop**: Punctul de intrare în aplicație
- **Responsabilități**:
  - Inițializează aplicația Flutter (`runApp()`)
  - Definește tema aplicației (Material 3, culori, font)
  - Setează ecranul inițial (`CountryListScreen`)

### 2️⃣ **models/country.dart** (Model de Date)
- **Scop**: Reprezintă structura unei țări
- **Proprietăți**:
  ```dart
  - name: String          // Numele țării
  - capital: String       // Capitala
  - flag: String          // URL steag PNG
  - population: int       // Populație
  - region: String        // Regiune (Africa, Asia, etc)
  - currency: String      // Moneda
  - language: String      // Limba/limbile
  - area: double          // Suprafața în km²
  - subregion: String     // Subregiune
  ```
- **Metoda Cheie**:
  - `fromJson()`: Convertește datele JSON de la API în obiect Country
  - Extrage currencies (prima monedă disponibilă)
  - Extrage languages (toate limbile, separate prin virgulă)

### 3️⃣ **services/country_service.dart** (Business Logic)
- **Scop**: Gestionează comunicarea cu API-ul
- **Metodă Principală**:
  ```dart
  fetchCountries(): Future<List<Country>>
  ```
- **Logica**:
  1. Încearcă să facă request HTTP la `restcountries.com/v3.1/all`
  2. Dacă reușește → parsează JSON și returnează lista
  3. Sortează țările alfabetic după nume
  4. Dacă eșuează → returnează date hardcodate (fallback)
- **Dependențe**: package `http`

### 4️⃣ **data/hardcoded_countries.dart** (Fallback Data)
- **Scop**: Date de rezervă când API-ul nu funcționează
- **Utilizare**: Garantează funcționarea aplicației offline

### 5️⃣ **screens/country_list_screen.dart** (Ecran Principal)
- **Tip**: StatefulWidget
- **State Variables**:
  ```dart
  - allCountries: List<Country>       // Toate țările de la API
  - filteredCountries: List<Country>  // Țări după filtrare
  - isLoading: bool                   // Stare încărcare
  - searchQuery: String               // Text din search bar
  - selectedRegion: String            // Regiune selectată
  ```
- **Logica de Filtrare**:
  ```dart
  filterCountries() {
    1. Filtrează după searchQuery (nume sau capitală)
    2. Filtrează după selectedRegion
    3. Actualizează filteredCountries
  }
  ```
- **Lifecycle**:
  - `initState()`: Încarcă țările la pornire
  - `loadCountries()`: Apelează CountryService
- **Widgets Folosite**:
  - CountryListHeader (afișează numărul de țări)
  - SearchBar (input pentru căutare)
  - RegionFilter (butoane filtrare regiuni)
  - CountryCard (card pentru fiecare țară)
  - LoadingIndicator / EmptyState

### 6️⃣ **screens/country_details_screen.dart** (Ecran Detalii)
- **Tip**: StatelessWidget
- **Primește**: Obiect `Country` prin constructor
- **Afișează**:
  - AppBar cu buton înapoi
  - FlagCard (steagul țării)
  - InfoSection "Informații Generale" (capitală, populație, suprafață, regiune)
  - InfoSection "Informații Financiare și Culturale" (monedă, limbă)
  - ApiFooter (credit pentru API)
- **Navigare**: Se ajunge prin tap pe CountryCard

### 7️⃣ **widgets/** (Componente Reutilizabile)

#### **country_card.dart**
- Card pentru lista de țări
- Afișează: steag, nume, capitală, populație
- OnTap → navighează la CountryDetailsScreen

#### **search_bar.dart**
- TextField cu icon de căutare
- Callback `onSearchChanged` trimite textul la parent
- Design: fundal alb, bordat rotunjit

#### **region_filter.dart**
- Butoane orizontale pentru filtrare după regiune
- Regiuni: Toate, Africa, America, Asia, Europe, Oceania
- Butonul selectat are culoare albastră

#### **country_list_header.dart**
- Header cu titlu și număr de țări
- Afișează: "Enciclopedie Țări" + "X țări disponibile"

#### **flag_card.dart**
- Afișează steagul țării în detalii
- Design: container cu shadow și border radius

#### **info_row.dart**
- Rând de informație cu icon, label și valoare
- Folosit în InfoSection

#### **info_section.dart**
- Container cu titlu și lista de InfoRow
- Grupează informații (General, Cultural)

#### **loading_indicator.dart**
- CircularProgressIndicator cu mesaj
- Folosit la încărcarea țărilor

#### **empty_state.dart**
- Afișat când nu există rezultate
- Icon + mesaj

#### **api_footer.dart**
- Credit pentru REST Countries API

### 8️⃣ **utils/formatters.dart** (Utilitare)
- **Scop**: Formatare date pentru afișare
- **Metode**:
  ```dart
  formatPopulation(int): String  // "123.456.789"
  formatArea(double): String     // "9.984.670 km²"
  ```

## 🔄 Fluxul de Date (Data Flow)

### La Pornirea Aplicației:
```
1. main.dart
   ↓
2. MyApp widget → MaterialApp
   ↓
3. CountryListScreen.initState()
   ↓
4. loadCountries()
   ↓
5. CountryService.fetchCountries()
   ↓
6. HTTP GET → restcountries.com/v3.1/all
   ↓
7. JSON Response → List<Country> (via Country.fromJson)
   ↓
8. setState() → rebuild UI
   ↓
9. ListView.builder cu CountryCard widgets
```

### La Căutare:
```
1. User scrie în SearchBar
   ↓
2. onSearchChanged callback
   ↓
3. Update searchQuery
   ↓
4. filterCountries()
   ↓
5. Filter allCountries where name/capital contains query
   ↓
6. setState(filteredCountries)
   ↓
7. ListView rebuild cu rezultate filtrate
```

### La Selectare Regiune:
```
1. User tap pe RegionFilter button
   ↓
2. onRegionSelected callback
   ↓
3. Update selectedRegion
   ↓
4. filterCountries()
   ↓
5. Filter allCountries where region == selected
   ↓
6. setState(filteredCountries)
   ↓
7. ListView rebuild
```

### La Tap pe Țară:
```
1. User tap pe CountryCard
   ↓
2. onTap callback
   ↓
3. Navigator.push()
   ↓
4. CountryDetailsScreen(country: selectedCountry)
   ↓
5. Afișare detalii țară
```

## 🔗 Relațiile dintre Componente

### Relații de Dependență:
```
CountryListScreen
├─── depends on → CountryService
├─── depends on → Country model
├─── uses → SearchBar widget
├─── uses → RegionFilter widget
├─── uses → CountryCard widget
└─── navigates to → CountryDetailsScreen

CountryDetailsScreen
├─── depends on → Country model
├─── uses → FlagCard widget
├─── uses → InfoSection widget
├─── uses → InfoRow widget
└─── uses → ApiFooter widget

CountryService
├─── depends on → Country model
├─── uses → http package
└─── fallback to → HardcodedCountries

Country model
└─── no dependencies (plain data class)
```

### Relații Parent-Child (Widget Tree):
```
MaterialApp
└─── CountryListScreen
     ├─── Container (gradient background)
     │    └─── SafeArea
     │         └─── Column
     │              ├─── CountryListHeader
     │              ├─── SearchBar
     │              ├─── RegionFilter
     │              └─── ListView.builder
     │                   └─── CountryCard (multiple)
     └─── [Navigator] → CountryDetailsScreen
                         ├─── AppBar (custom)
                         ├─── FlagCard
                         ├─── InfoSection (General)
                         │    └─── InfoRow (multiple)
                         ├─── InfoSection (Cultural)
                         │    └─── InfoRow (multiple)
                         └─── ApiFooter
```

## 🎯 State Management

### Tip: **setState() - Local State**
- **Unde**: CountryListScreen
- **Ce se gestionează**:
  - Lista de țări (allCountries, filteredCountries)
  - Starea încărcării (isLoading)
  - Query căutare (searchQuery)
  - Regiune selectată (selectedRegion)
- **Trigger-uri**:
  - loadCountries() → isLoading
  - filterCountries() → filteredCountries
  - onSearchChanged → searchQuery
  - onRegionSelected → selectedRegion

## 🌐 API Integration

### Endpoint: `https://restcountries.com/v3.1/all`
- **Metoda**: GET
- **Response**: JSON array cu ~250 țări
- **Structura JSON**:
  ```json
  {
    "name": { "common": "Romania" },
    "capital": ["Bucharest"],
    "flags": { "png": "https://..." },
    "population": 19237691,
    "region": "Europe",
    "subregion": "Eastern Europe",
    "area": 238391.0,
    "currencies": { "RON": { "name": "Romanian leu", "symbol": "lei" } },
    "languages": { "ron": "Romanian" }
  }
  ```

## 📦 Packages Folosite

1. **http**: ^1.2.0
   - Scop: Request-uri HTTP către API
   - Folosit în: CountryService

2. **cupertino_icons**: ^1.0.8
   - Scop: Iconițe iOS style
   - Folosit în: Diverse widgets

3. **shared_preferences**: ^2.2.2
   - Scop: Stocare locală (posibil pentru favorites)
   - Status: Instalat dar nefolosit în codul actual

## 🎨 Design Pattern-uri Folosite

1. **Factory Pattern**: `Country.fromJson()`
2. **Service Layer Pattern**: `CountryService`
3. **Widget Composition**: Componente mici, reutilizabile
4. **Separation of Concerns**: Models, Services, Screens, Widgets separate
5. **Callback Pattern**: onTap, onSearchChanged, onRegionSelected

## 🚀 Cum să Adaugi Funcționalități Noi

### Exemplu: Adaugă sortare după populație
1. **Adaugă variabilă** în `CountryListScreen`: `String sortBy = 'name'`
2. **Adaugă logică** în `filterCountries()`:
   ```dart
   if (sortBy == 'population') {
     filteredCountries.sort((a, b) => b.population.compareTo(a.population));
   }
   ```
3. **Adaugă widget** pentru selectare: `SortDropdown`
4. **Update state** la schimbare: `setState(() => sortBy = value)`

### Exemplu: Adaugă favorites
1. **Model**: Adaugă `isFavorite: bool` în `Country`
2. **Service**: Creează `FavoritesService` cu `shared_preferences`
3. **UI**: Adaugă IconButton (⭐) în `CountryCard`
4. **State**: Gestionează lista de favorites în `CountryListScreen`
5. **Filter**: Adaugă tab "Favorite" în `RegionFilter`

## 🔍 Debugging și Identificare Probleme

### Unde să cauți când:

**Problema**: Țările nu se încarcă
→ Verifică: `country_service.dart` → funcția `fetchCountries()`
→ Debug: Print response.statusCode, adaugă try-catch

**Problema**: Căutarea nu funcționează
→ Verifică: `country_list_screen.dart` → funcția `filterCountries()`
→ Debug: Print searchQuery, allCountries.length

**Problema**: Design-ul arată greșit
→ Verifică: widget-ul specific în `widgets/`
→ Debug: Flutter Inspector (DevTools)

**Problema**: Navigarea nu funcționează
→ Verifică: `country_list_screen.dart` → `CountryCard.onTap`
→ Debug: Print în callback-ul onTap

**Problema**: Datele lipsesc în detalii
→ Verifică: `country.dart` → metoda `fromJson()`
→ Debug: Print json în fromJson, verifică null values

## 📊 Metrici și Performanță

- **Număr total fișiere Dart**: ~20
- **Număr clase**: ~15
- **API calls**: 1 (la pornire)
- **Rebuild optimization**: Folosește `const` pentru widget-uri statice
- **Lazy loading**: ListView.builder (încarcă doar item-urile vizibile)

---

**Autor**: Tema Laborator Flutter
**Data**: Ianuarie 2026
**Framework**: Flutter 3.9.2
**API**: REST Countries v3.1
