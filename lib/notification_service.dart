import 'package:flutter/foundation.dart' show kIsWeb;
import 'utils/app_logger.dart';

// Conditional import: usa stub per default, web implementation se dart:js è disponibile
import 'notification_service_stub.dart'
    if (dart.library.js) 'notification_service_web.dart';

/// Service per gestire le notifiche push del Sistema Anti-Nervoso
/// 
/// Questa classe fornisce un'interfaccia unificata per le notifiche
/// che funziona su tutte le piattaforme:
/// - Su Web: usa dart:js per interagire con le API browser
/// - Su altre piattaforme: fornisce fallback sicuri
/// 
/// L'implementazione effettiva viene scelta automaticamente tramite
/// conditional import basato sulla disponibilità di dart:js
class NotificationService {
  /// Registra il service worker e richiede i permessi per le notifiche
  /// 
  /// Returns:
  /// - `true` se l'inizializzazione è riuscita (solo su web)
  /// - `false` su altre piattaforme o in caso di errore
  static Future<bool> initialize() async {
    if (kIsWeb) {
      AppLogger.notificationInfo('Inizializzazione notifiche web...');
    } else {
      AppLogger.notificationInfo('Piattaforma non-web rilevata');
    }
    
    return NotificationServiceImpl.initialize();
  }

  /// Programma le notifiche automatiche per i giorni gialli e rossi
  /// 
  /// Parameters:
  /// - `startDate`: Data di inizio del ciclo
  /// - `cycleDays`: Durata del ciclo in giorni (default: 28)
  /// 
  /// Su web: programma notifiche tramite Service Worker
  /// Su altre piattaforme: operazione no-op
  static Future<void> scheduleNotifications(
    DateTime startDate, {
    int cycleDays = 28,
  }) async {
    AppLogger.notificationInfo(
      'Richiesta programmazione notifiche per ${startDate.toIso8601String()}'
    );
    
    return NotificationServiceImpl.scheduleNotifications(
      startDate,
      cycleDays: cycleDays,
    );
  }

  /// Cancella tutte le notifiche programmate
  /// 
  /// Su web: cancella notifiche tramite Service Worker
  /// Su altre piattaforme: operazione no-op
  static Future<void> clearNotifications() async {
    AppLogger.notificationInfo('Richiesta cancellazione notifiche');
    
    return NotificationServiceImpl.clearNotifications();
  }

  /// Verifica lo stato dei permessi per le notifiche
  /// 
  /// Returns:
  /// - `'granted'`: Permessi concessi
  /// - `'denied'`: Permessi negati
  /// - `'default'`: Permessi non ancora richiesti
  /// - `'not-supported'`: Piattaforma non supportata
  /// - `'error'`: Errore nella verifica
  static String getNotificationPermission() {
    final String permission = NotificationServiceImpl.getNotificationPermission();
    
    AppLogger.notificationInfo('Stato permessi notifiche: $permission');
    
    return permission;
  }

  /// Mostra una notifica di test
  /// 
  /// Su web: invia notifica tramite Service Worker
  /// Su altre piattaforme: operazione no-op
  static Future<void> showTestNotification() async {
    AppLogger.notificationInfo('Richiesta notifica di test');
    
    return NotificationServiceImpl.showTestNotification();
  }

  /// Verifica se le notifiche sono supportate sulla piattaforma corrente
  /// 
  /// Returns:
  /// - `true` se siamo su web e le notifiche sono supportate
  /// - `false` su altre piattaforme
  static bool isSupported() {
    if (!kIsWeb) {
      return false;
    }
    
    // Su web, verifichiamo tramite getNotificationPermission
    final String permission = getNotificationPermission();
    return permission != 'not-supported' && permission != 'error';
  }

  /// Ottiene informazioni sulla piattaforma e supporto notifiche
  /// 
  /// Returns un Map con informazioni di debug
  static Map<String, dynamic> getPlatformInfo() {
    return <String, dynamic>{
      'isWeb': kIsWeb,
      'isSupported': isSupported(),
      'permission': getNotificationPermission(),
      'platform': kIsWeb ? 'web' : 'native',
      'implementation': kIsWeb ? 'notification_service_web' : 'notification_service_stub',
    };
  }
}