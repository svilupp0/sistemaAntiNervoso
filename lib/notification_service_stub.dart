import 'utils/app_logger.dart';

/// Stub implementation per piattaforme non-web
/// Fornisce fallback sicuri per tutte le operazioni di notifica
class NotificationServiceImpl {
  /// Registra il service worker e richiede i permessi per le notifiche
  static Future<bool> initialize() async {
    AppLogger.notificationInfo(
        'Notifiche non supportate su questa piattaforma');
    return false;
  }

  /// Programma le notifiche automatiche per i giorni gialli e rossi
  static Future<void> scheduleNotifications(
    DateTime startDate, {
    int cycleDays = 28,
  }) async {
    AppLogger.notificationInfo(
        'Programmazione notifiche non supportata su questa piattaforma');
    // Nessuna operazione su piattaforme non-web
  }

  /// Cancella tutte le notifiche programmate
  static Future<void> clearNotifications() async {
    AppLogger.notificationInfo(
        'Cancellazione notifiche non supportata su questa piattaforma');
    // Nessuna operazione su piattaforme non-web
  }

  /// Verifica lo stato dei permessi per le notifiche
  static String getNotificationPermission() {
    return 'not-supported';
  }

  /// Mostra una notifica di test
  static Future<void> showTestNotification() async {
    AppLogger.notificationInfo(
        'Notifiche di test non supportate su questa piattaforma');
    // Nessuna operazione su piattaforme non-web
  }
}
