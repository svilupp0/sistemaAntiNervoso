import 'package:flutter/foundation.dart';

/// Logger centralizzato per l'applicazione Sistema Anti-Nervoso
///
/// Gestisce i log in modo intelligente:
/// - In debug mode: stampa tutti i log
/// - In release mode: non stampa nulla (performance ottimale)
/// - Supporta diversi livelli di log
/// - Formattazione consistente dei messaggi
class AppLogger {
  /// Tag predefiniti per diverse aree dell'app
  static const String _tagNotifications = 'NOTIFICATIONS';
  static const String _tagPrefs = 'PREFERENCES';
  static const String _tagUI = 'UI';
  static const String _tagCycle = 'CYCLE';
  static const String _tagGeneral = 'APP';

  /// Log generico
  static void log(String message, [String? tag]) {
    if (kDebugMode) {
      final String finalTag = tag ?? _tagGeneral;
      final String timestamp = DateTime.now().toString().substring(11, 19);
      print('[$timestamp] [$finalTag] $message');
    }
  }

  /// Log per errori
  static void error(String message, [Object? error, String? tag]) {
    if (kDebugMode) {
      final String finalTag = tag ?? _tagGeneral;
      final String timestamp = DateTime.now().toString().substring(11, 19);
      print('[$timestamp] [ERROR] [$finalTag] $message');
      if (error != null) {
        print('[$timestamp] [ERROR] [$finalTag] Details: $error');
      }
    }
  }

  /// Log per warning
  static void warning(String message, [String? tag]) {
    if (kDebugMode) {
      final String finalTag = tag ?? _tagGeneral;
      final String timestamp = DateTime.now().toString().substring(11, 19);
      print('[$timestamp] [WARN] [$finalTag] $message');
    }
  }

  /// Log per informazioni
  static void info(String message, [String? tag]) {
    if (kDebugMode) {
      final String finalTag = tag ?? _tagGeneral;
      final String timestamp = DateTime.now().toString().substring(11, 19);
      print('[$timestamp] [INFO] [$finalTag] $message');
    }
  }

  /// Log per debug dettagliato
  static void debug(String message, [String? tag]) {
    if (kDebugMode) {
      final String finalTag = tag ?? _tagGeneral;
      final String timestamp = DateTime.now().toString().substring(11, 19);
      print('[$timestamp] [DEBUG] [$finalTag] $message');
    }
  }

  // === METODI SPECIFICI PER AREE DELL'APP ===

  /// Log specifici per le notifiche
  static void notification(String message) => log(message, _tagNotifications);
  static void notificationError(String message, [Object? error]) => error!;
  static void notificationInfo(String message) =>
      info(message, _tagNotifications);

  /// Log specifici per le preferenze
  static void prefs(String message) => log(message, _tagPrefs);
  static void prefsError(String message, [Object? error]) => error!;

  /// Log specifici per l'UI
  static void ui(String message) => log(message, _tagUI);
  static void uiError(String message, [Object? error]) => error!;

  /// Log specifici per il ciclo
  static void cycle(String message) => log(message, _tagCycle);
  static void cycleError(String message, [Object? error]) => error!;

  /// Metodo per log di inizializzazione
  static void init(String component) {
    info('Inizializzazione $component completata');
  }

  /// Metodo per log di successo operazioni
  static void success(String operation, [String? tag]) {
    info('✅ $operation completata con successo', tag);
  }

  /// Metodo per log di fallimento operazioni
  static void failure(String operation, [Object? error, String? tag]) {
    error!;
  }

  /// Metodo per log di operazioni in corso
  static void progress(String operation, [String? tag]) {
    debug('🔄 $operation in corso...', tag);
  }

  /// Metodo per disabilitare completamente i log (se necessario)
  static bool _enabled = true;
  static void disable() => _enabled = false;
  static void enable() => _enabled = true;
  static bool get isEnabled => _enabled && kDebugMode;
}
