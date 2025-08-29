import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/foundation.dart';

/// Helper per la gestione della persistenza dei dati del ciclo
class PrefsHelper {
  static const _keyInizioCiclo = 'inizio_ciclo';

  /// Salva la data del ciclo con gestione errori
  static Future<bool> salvaCiclo(DateTime date) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return await prefs.setString(_keyInizioCiclo, date.toIso8601String());
    } catch (e) {
      if (kDebugMode) {
        print('Errore nel salvare la data del ciclo: $e');
      }
      return false;
    }
  }

  /// Carica la data salvata con gestione errori e validazione
  static Future<DateTime?> caricaCiclo() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final str = prefs.getString(_keyInizioCiclo);
      
      if (str != null) {
        final date = DateTime.parse(str);
        
        // Validazione: la data non può essere nel futuro
        if (date.isAfter(DateTime.now())) {
          if (kDebugMode) {
            print('Data del ciclo nel futuro, ignorata: $date');
          }
          return null;
        }
        
        // Validazione: la data non può essere troppo vecchia (2 anni)
        final duaAnniFA = DateTime.now().subtract(const Duration(days: 730));
        if (date.isBefore(duaAnniFA)) {
          if (kDebugMode) {
            print('Data del ciclo troppo vecchia, ignorata: $date');
          }
          return null;
        }
        
        return date;
      }
      return null;
    } catch (e) {
      if (kDebugMode) {
        print('Errore nel caricare la data del ciclo: $e');
      }
      return null;
    }
  }

  /// Cancella i dati salvati
  static Future<bool> cancellaDataCiclo() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return await prefs.remove(_keyInizioCiclo);
    } catch (e) {
      if (kDebugMode) {
        print('Errore nel cancellare la data del ciclo: $e');
      }
      return false;
    }
  }
}
