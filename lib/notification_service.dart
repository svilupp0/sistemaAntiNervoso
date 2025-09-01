import 'dart:js' as js;

/// Service per gestire le notifiche push del Sistema Anti-Nervoso
class NotificationService {
  /// Registra il service worker e richiede i permessi per le notifiche
  static Future<bool> initialize() async {
    try {
      // Verifica se le notifiche sono supportate
      if (!_isNotificationSupported()) {
        print('Notifiche non supportate su questo browser');
        return false;
      }

      // Registra il service worker e richiede permessi
      await _callJSFunction('registerSWAndSubscribe');
      print('Service worker registrato e permessi richiesti');
      return true;
    } catch (e) {
      print('Errore nell\'inizializzazione delle notifiche: $e');
      return false;
    }
  }

  /// Programma le notifiche automatiche per i giorni gialli e rossi
  static Future<void> scheduleNotifications(
    DateTime startDate, {
    int cycleDays = 28,
  }) async {
    try {
      if (!_isNotificationSupported()) {
        print('Notifiche non supportate');
        return;
      }

      // Chiama la funzione JavaScript per programmare le notifiche
      js.context.callMethod('scheduleNotifications', [
        _dateToJSDate(startDate),
        cycleDays,
      ]);

      print(
        'Notifiche programmate per il ciclo iniziato il: ${startDate.toIso8601String()}',
      );
    } catch (e) {
      print('Errore nella programmazione delle notifiche: $e');
    }
  }

  /// Cancella tutte le notifiche programmate
  static Future<void> clearNotifications() async {
    try {
      if (!_isNotificationSupported()) {
        print('Notifiche non supportate');
        return;
      }

      await _callJSFunction('clearNotifications');
      print('Notifiche cancellate');
    } catch (e) {
      print('Errore nella cancellazione delle notifiche: $e');
    }
  }

  /// Verifica se le notifiche sono supportate dal browser
  static bool _isNotificationSupported() {
    return js.context.hasProperty('Notification') &&
        js.context.hasProperty('navigator') &&
        js.context['navigator'].hasProperty('serviceWorker');
  }

  /// Chiama una funzione JavaScript
  static Future<dynamic> _callJSFunction(
    String functionName, [
    List<dynamic>? args,
  ]) async {
    try {
      if (js.context.hasProperty(functionName)) {
        return js.context.callMethod(functionName, args);
      } else {
        throw Exception('Funzione JavaScript $functionName non trovata');
      }
    } catch (e) {
      print('Errore nella chiamata a $functionName: $e');
      rethrow;
    }
  }

  /// Converte una DateTime Dart in un oggetto Date JavaScript
  static js.JsObject _dateToJSDate(DateTime date) {
    return js.JsObject(js.context['Date'], [
      date.year,
      date.month - 1, // JavaScript usa mesi 0-based
      date.day,
      date.hour,
      date.minute,
      date.second,
      date.millisecond,
    ]);
  }

  /// Verifica lo stato dei permessi per le notifiche
  static String getNotificationPermission() {
    try {
      if (_isNotificationSupported()) {
        return js.context['Notification']['permission'];
      }
      return 'not-supported';
    } catch (e) {
      print('Errore nel controllo dei permessi: $e');
      return 'error';
    }
  }

  /// Mostra una notifica di test
  static Future<void> showTestNotification() async {
    try {
      if (!_isNotificationSupported()) {
        print('Notifiche non supportate');
        return;
      }

      // Invia messaggio al Service Worker per mostrare notifica di test
      if (js.context.hasProperty('navigator') &&
          js.context['navigator'].hasProperty('serviceWorker')) {
        final registration = await js.context
            .callMethod('eval', ['navigator.serviceWorker.ready']);

        // Invia messaggio al SW
        registration.callMethod('postMessage', [
          js.JsObject.jsify({
            'type': 'SHOW_TEST_NOTIFICATION_NOW',
            'title': '🧪 Test Sistema Anti-Nervoso',
            'body': 'Notifica di test funzionante! 🎉',
            'icon': 'icons/Icon-192.png'
          })
        ]);
      }

      print('Notifica di test inviata');
    } catch (e) {
      print('Errore nell\'invio della notifica di test: $e');
    }
  }
}
