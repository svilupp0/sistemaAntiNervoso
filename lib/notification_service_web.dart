import 'dart:js' as js;
import 'package:flutter/foundation.dart';
import 'utils/app_logger.dart';

/// Implementazione web per le notifiche push
/// Usa dart:js per interagire con le API JavaScript del browser
class NotificationServiceImpl {
  /// Registra il service worker e richiede i permessi per le notifiche
  static Future<bool> initialize() async {
    try {
      // Verifica se le notifiche sono supportate
      if (!_isNotificationSupported()) {
        AppLogger.notificationError('Notifiche non supportate su questo browser');
        return false;
      }

      // Registra il service worker e richiede permessi
      await _callJSFunction('registerSWAndSubscribe', <dynamic>[]);
      AppLogger.notificationInfo('Service worker registrato e permessi richiesti');
      return true;
    } catch (e) {
      AppLogger.notificationError('Errore nell\'inizializzazione delle notifiche', e);
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
        AppLogger.notificationError('Notifiche non supportate');
        return;
      }

      // Chiama la funzione JavaScript per programmare le notifiche
      js.context.callMethod('scheduleNotifications', <dynamic>[
        _dateToJSDate(startDate),
        cycleDays,
      ]);

      AppLogger.notificationInfo(
        'Notifiche programmate per il ciclo iniziato il: ${startDate.toIso8601String()}',
      );
    } catch (e) {
      AppLogger.notificationError('Errore nella programmazione delle notifiche', e);
    }
  }

  /// Cancella tutte le notifiche programmate
  static Future<void> clearNotifications() async {
    try {
      if (!_isNotificationSupported()) {
        AppLogger.notificationError('Notifiche non supportate');
        return;
      }

      await _callJSFunction('clearNotifications', <dynamic>[]);
      AppLogger.notificationInfo('Notifiche cancellate');
    } catch (e) {
      AppLogger.notificationError('Errore nella cancellazione delle notifiche', e);
    }
  }

  /// Verifica se le notifiche sono supportate dal browser
  static bool _isNotificationSupported() {
    try {
      // Verifica supporto Notification API
      if (!js.context.hasProperty('Notification')) {
        return false;
      }
      // Verifica presenza navigator
      if (!js.context.hasProperty('navigator')) {
        return false;
      }
      final js.JsObject? navigator = js.context['navigator'] as js.JsObject?;
      if (navigator == null) {
        return false;
      }
      // Verifica supporto Service Worker
      return navigator.hasProperty('serviceWorker');
    } catch (e) {
      AppLogger.notificationError('Errore nella verifica supporto notifiche', e);
      return false;
    }
  }

  /// Chiama una funzione JavaScript in modo sicuro
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
      AppLogger.notificationError('Errore nella chiamata a $functionName', e);
      rethrow;
    }
  }

  /// Converte una DateTime Dart in un oggetto Date JavaScript
  static js.JsObject _dateToJSDate(DateTime date) {
    try {
      // Cast esplicito per garantire che Date sia una JsFunction
      final dynamic dateValue = js.context['Date'];
      if (dateValue == null) {
        throw Exception('Date constructor non disponibile');
      }
      final js.JsFunction dateConstructor = dateValue as js.JsFunction;
      return js.JsObject(dateConstructor, <int>[
        date.year,
        date.month - 1, // JavaScript usa mesi 0-based
        date.day,
        date.hour,
        date.minute,
        date.second,
        date.millisecond,
      ]);
    } catch (e) {
      throw Exception('Errore nella creazione Date JavaScript: $e');
    }
  }

  /// Verifica lo stato dei permessi per le notifiche
  static String getNotificationPermission() {
    try {
      if (_isNotificationSupported()) {
        final js.JsObject notification = js.context['Notification'] as js.JsObject;
        final dynamic permissionValue = notification['permission'];
        // Assicura che il valore sia convertito in String
        return permissionValue?.toString() ?? 'unknown';
      }
      return 'not-supported';
    } catch (e) {
      AppLogger.notificationError('Errore nel controllo dei permessi', e);
      return 'error';
    }
  }

  /// Mostra una notifica di test
  static Future<void> showTestNotification() async {
    try {
      if (!_isNotificationSupported()) {
        AppLogger.notificationError('Notifiche non supportate');
        return;
      }

      // Invia messaggio al Service Worker per mostrare notifica di test
      if (js.context.hasProperty('navigator')) {
        final js.JsObject? navigator = js.context['navigator'] as js.JsObject?;
        if (navigator != null && navigator.hasProperty('serviceWorker')) {
          final js.JsObject registration = await js.context
              .callMethod('eval', <String>['navigator.serviceWorker.ready']) as js.JsObject;

          // Invia messaggio al SW
          registration.callMethod('postMessage', <dynamic>[
            js.JsObject.jsify(<String, String>{
              'type': 'SHOW_TEST_NOTIFICATION_NOW',
              'title': '🧪 Test Sistema Anti-Nervoso',
              'body': 'Notifica di test funzionante! 🎉',
              'icon': 'icons/Icon-192.png'
            })
          ]);
        }
      }

      AppLogger.notificationInfo('Notifica di test inviata');
    } catch (e) {
      AppLogger.notificationError('Errore nell\'invio della notifica di test', e);
    }
  }
}