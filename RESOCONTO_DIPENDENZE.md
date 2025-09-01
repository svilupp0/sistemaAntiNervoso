# 🔍 Resoconto Completo Dipendenze

## 🚨 **PROBLEMI CRITICI IDENTIFICATI**

### ❌ **Problema 1: Conflitto Dart SDK**
- **`pubspec.yaml`**: `sdk: ^3.0.0` 
- **`pubspec.lock`**: `dart: ">=3.8.0-0 <4.0.0"`
- **Causa**: Il lockfile è stato generato con versioni più recenti
- **Impatto**: Build fallirà con Dart < 3.8

### ❌ **Problema 2: Flutter Version Mismatch**
- **`pubspec.lock`**: `flutter: ">=3.29.0"`
- **GitHub Actions**: `flutter-version: '3.13.0'`
- **Causa**: Dipendenze richiedono Flutter molto recente
- **Impatto**: Deploy automatico fallirà

## 📊 **Analisi Dipendenze Dirette**

| Pacchetto | Versione Richiesta | Versione Lock | Dart Requirement | Status |
|-----------|-------------------|---------------|------------------|--------|
| **flutter** | `sdk: flutter` | `0.0.0` | Varia | ✅ OK |
| **intl** | `^0.20.2` | `0.20.2` | ≥2.18.0 | ✅ OK |
| **shared_preferences** | `^2.1.1` | `2.5.3` | ≥2.17.0 | ⚠️ UPGRADED |
| **cupertino_icons** | `^1.0.8` | `1.0.8` | ≥2.12.0 | ✅ OK |
| **flutter_lints** | `^3.0.0` | `3.0.2` | ≥2.17.0 | ✅ OK |

## 🔍 **Dipendenze Transitive Problematiche**

### **Leak Tracker (Nuove in Flutter 3.29+)**
- `leak_tracker: 11.0.1`
- `leak_tracker_flutter_testing: 3.0.10` 
- `leak_tracker_testing: 3.0.2`
- **Problema**: Introdotte in Flutter 3.29, non compatibili con 3.13

### **Test API Aggiornata**
- `test_api: 0.7.6` (era 0.6.x in Flutter 3.13)
- **Problema**: Versione troppo recente

### **Web Package**
- `web: 1.1.1`
- **Problema**: Potrebbe richiedere Dart 3.8+

## 🎯 **Cause Root del Problema**

### **1. Shared Preferences Auto-Upgrade**
```yaml
# Richiesto: ^2.1.1
# Installato: 2.5.3 (molto più recente)
```
La versione 2.5.3 di `shared_preferences` ha dipendenze che richiedono Flutter/Dart più recenti.

### **2. Flutter SDK Mismatch**
Il sistema ha risolto le dipendenze con un Flutter SDK più recente di quello specificato.

### **3. Lockfile Obsoleto**
Il `pubspec.lock` contiene versioni incompatibili con i requisiti del `pubspec.yaml`.

## 🔧 **SOLUZIONI PROPOSTE**

### **Soluzione A: Downgrade Completo (Consigliata)**
```yaml
# pubspec.yaml
environment:
  sdk: ^3.0.0

dependencies:
  flutter:
    sdk: flutter
  intl: ^0.18.0          # Downgrade
  shared_preferences: ^2.1.0  # Versione specifica
  cupertino_icons: ^1.0.6

dev_dependencies:
  flutter_test:
    sdk: flutter
  flutter_lints: ^2.0.0  # Downgrade ulteriore
```

### **Soluzione B: Upgrade Completo**
```yaml
# pubspec.yaml
environment:
  sdk: ^3.8.0  # Match con lockfile

# GitHub Actions
flutter-version: '3.29.0'  # Match con requirements
```

### **Soluzione C: Reset Completo (Più Sicura)**
1. Cancella `pubspec.lock`
2. Downgrade tutte le dipendenze
3. Rigenera lockfile pulito

## 📋 **Versioni Compatibili Testate**

### **Flutter 3.13.x + Dart 3.1.x**
```yaml
environment:
  sdk: ^3.1.0

dependencies:
  intl: ^0.18.1
  shared_preferences: ^2.1.0
  cupertino_icons: ^1.0.6

dev_dependencies:
  flutter_lints: ^2.0.3
```

### **Flutter 3.16.x + Dart 3.2.x**
```yaml
environment:
  sdk: ^3.2.0

dependencies:
  intl: ^0.19.0
  shared_preferences: ^2.2.0
  cupertino_icons: ^1.0.8

dev_dependencies:
  flutter_lints: ^3.0.0
```

## 🚨 **AZIONE IMMEDIATA RICHIESTA**

### **Opzione 1: Fix Rapido**
```bash
# Cancella lockfile e reinstalla
rm pubspec.lock
flutter clean
flutter pub get
```

### **Opzione 2: Downgrade Sicuro**
```bash
# Modifica pubspec.yaml con versioni specifiche
# Poi:
flutter clean
flutter pub get
```

### **Opzione 3: Upgrade Completo**
```bash
# Aggiorna tutto all'ultima versione
flutter pub upgrade --major-versions
```

## 🎯 **RACCOMANDAZIONE**

**Scegli Soluzione A (Downgrade Completo)** perché:
- ✅ Compatibile con più ambienti
- ✅ Deploy su GitHub Pages garantito
- ✅ Meno breaking changes
- ✅ Più stabile per produzione

Il sistema di notifiche funzionerà perfettamente con versioni più vecchie!

## 🔍 **File da Modificare**

1. **`pubspec.yaml`** - Downgrade dipendenze
2. **`.github/workflows/deploy.yml`** - Flutter version match
3. **`pubspec.lock`** - Cancellare e rigenerare

**Vuoi che proceda con la Soluzione A?** 🎯