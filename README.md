# Sistema Anti-Nervoso 😎

Un'app Flutter divertente e colorata per il tracciamento del ciclo mestruale con un tocco di umorismo!

## ✨ Caratteristiche

- 🌈 **Interfaccia Arcobaleno**: Design colorato e allegro
- 📅 **Calendario Umore**: Visualizzazione dei giorni con codici colore
- 💾 **Persistenza Dati**: Salvataggio automatico delle informazioni
- 🎭 **Animazioni**: Emoji fluttuanti per un'esperienza divertente
- ⚡ **Performance Ottimizzate**: Codice efficiente e responsive

## 🚀 Come Iniziare

### Prerequisiti
- Flutter SDK (versione 3.9.0 o superiore)
- Dart SDK
- Android Studio / VS Code

### Installazione

1. Clona il repository:
```bash
git clone <repository-url>
cd nome_app
```

2. Installa le dipendenze:
```bash
flutter pub get
```

3. Esegui l'app:
```bash
flutter run
```

## 🏗️ Architettura

```
lib/
├── constants.dart          # Costanti dell'applicazione
├── main.dart              # Entry point
├── home_page.dart         # Pagina principale
├── cycle_calendar.dart    # Widget calendario
├── floating_emojis.dart   # Animazioni emoji
├── prefs_helper.dart      # Gestione persistenza
├── styles.dart            # Stili e temi
└── utils/
    └── cycle_calculator.dart # Logica calcoli ciclo
```

## 🎨 Funzionalità

### Tracciamento Ciclo
- Selezione data inizio ciclo
- Calcolo automatico prossimo ciclo
- Avviso anticipato per il partner

### Calendario Umore
- 🟢 **Verde**: Giorni tranquilli
- 🟡 **Giallo**: Dolori/stranita
- 🔴 **Rosso**: Giorni critici ⚠️

## 🧪 Test

Esegui i test:
```bash
flutter test
```

## 📱 Piattaforme Supportate

- ✅ Android
- ✅ iOS
- ✅ Web
- ✅ Windows
- ✅ macOS
- ✅ Linux

## 🤝 Contribuire

1. Fork del progetto
2. Crea un branch per la feature (`git checkout -b feature/AmazingFeature`)
3. Commit delle modifiche (`git commit -m 'Add some AmazingFeature'`)
4. Push al branch (`git push origin feature/AmazingFeature`)
5. Apri una Pull Request

## 📄 Licenza

Questo progetto è distribuito sotto licenza MIT. Vedi `LICENSE` per maggiori informazioni.

## 🙏 Ringraziamenti

- Flutter team per il fantastico framework
- Comunità open source per le ispirazioni
- Tutte le persone che rendono il mondo più colorato! 🌈
