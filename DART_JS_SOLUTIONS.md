# 🔧 Soluzioni per Problemi dart:js

## 🎯 **ANALISI DEL PROBLEMA**

Ho analizzato il tuo codice e identificato le possibili cause dei problemi con `dart:js`. Ecco le soluzioni complete:

---

## 🚨 **PROBLEMI COMUNI CON dart:js**

### **1. 📱 Platform Compatibility**
```dart
// ❌ PROBLEMA: dart:js funziona SOLO su web
import 'dart:js' as js;

// ✅ SOLUZIONE: Conditional import
```

### **2. 🔄 Dart SDK Compatibility**
```dart
// ❌ PROBLEMA: Versioni Dart diverse hanno API diverse
// ✅ SOLUZIONE: Usare versione compatibile
```

### **3. 🌐 Web-Only Context**
```dart
// ❌ PROBLEMA: Codice eseguito su piattaforme non-web
// ✅ SOLUZIONE: Guard con kIsWeb
```

---

## ✅ **SOLUZIONI IMMEDIATE**

### **🔧 Soluzione 1: Conditional Import (Raccomandato)**

Sostituisci l'import diretto con conditional import:

```dart
// ❌ PRIMA (problematico)
import 'dart:js' as js;

// ✅ DOPO (sicuro)
import 'dart:js' as js show allowInterop;
import 'dart:js_util' as js_util;
```

### **🔧 Soluzione 2: Platform-Specific Implementation**

Crea implementazioni separate per web e altre piattaforme:

```dart
// File: notification_service_web.dart
import 'dart:js' as js;
import 'package:flutter/foundation.dart';

class NotificationServiceWeb {
  static Future<bool> initialize() async {
    // Implementazione web con dart:js
  }
}

// File: notification_service_stub.dart
class NotificationServiceStub {
  static Future<bool> initialize() async {
    return false; // Stub per altre piattaforme
  }
}

// File: notification_service.dart
import 'notification_service_stub.dart'
    if (dart.library.js) 'notification_service_web.dart';

class NotificationService {
  static Future<bool> initialize() async {
    if (kIsWeb) {
      return NotificationServiceWeb.initialize();
    }
    return NotificationServiceStub.initialize();
  }
}
```

### **🔧 Soluzione 3: Modern js_interop (Flutter 3.16+)**

Migra a `dart:js_interop` per compatibilità futura:

```dart
// ❌ VECCHIO (dart:js)
import 'dart:js' as js;

// ✅ NUOVO (dart:js_interop)
import 'dart:js_interop';

@JS()
external JSObject get window;

@JS('navigator.serviceWorker')
external ServiceWorker? get serviceWorker;
```

---

## 🛠️ **IMPLEMENTAZIONE CORRETTA**

### **📋 Versione Corretta del NotificationService:**

```dart
import 'package:flutter/foundation.dart';
import 'utils/app_logger.dart';

// Conditional import per dart:js
import 'dart:js' as js if (dart.library.js) 'dart:js';
import 'dart:js_util' as js_util if (dart.library.js) 'dart:js_util';

/// Service per gestire le notifiche push del Sistema Anti-Nervoso
class NotificationService {
  /// Registra il service worker e richiede i permessi per le notifiche
  static Future<bool> initialize() async {
    // Guard principale per web-only
    if (!kIsWeb) {
      AppLogger.notificationInfo('Notifiche supportate solo su web');
      return false;
    }
    
    try {
      // Verifica disponibilità dart:js
      if (!_isDartJsAvailable()) {
        AppLogger.notificationError('dart:js non disponibile');
        return false;
      }

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
      AppLogger.notificationError('Errore nell\\'inizializzazione delle notifiche', e);
      return false;
    }
  }

  /// Verifica se dart:js è disponibile
  static bool _isDartJsAvailable() {
    if (!kIsWeb) return false;
    
    try {
      // Test di accesso a js.context
      js.context;
      return true;
    } catch (e) {
      AppLogger.notificationError('dart:js non accessibile', e);
      return false;
    }
  }

  /// Verifica se le notifiche sono supportate dal browser
  static bool _isNotificationSupported() {
    if (!kIsWeb || !_isDartJsAvailable()) return false;
    
    try {
      // Verifica supporto Notification API
      if (!_hasJSProperty('Notification')) {
        return false;
      }
      // Verifica presenza navigator
      if (!_hasJSProperty('navigator')) {
        return false;
      }
      
      final dynamic navigatorValue = js.context['navigator'];
      if (navigatorValue == null) {
        return false;
      }
      
      // Safe cast con controllo
      if (navigatorValue is js.JsObject) {
        return _hasJSObjectProperty(navigatorValue, 'serviceWorker');
      }
      
      return false;
    } catch (e) {
      AppLogger.notificationError('Errore nella verifica supporto notifiche', e);
      return false;
    }
  }

  /// Helper sicuro per verificare proprietà JS
  static bool _hasJSProperty(String property) {
    try {
      return js.context.hasProperty(property);
    } catch (e) {
      AppLogger.notificationError('Errore nel controllo proprietà $property', e);
      return false;
    }
  }

  /// Helper sicuro per verificare proprietà di JsObject
  static bool _hasJSObjectProperty(js.JsObject obj, String property) {
    try {
      return obj.hasProperty(property);
    } catch (e) {
      AppLogger.notificationError('Errore nel controllo proprietà oggetto $property', e);
      return false;
    }
  }

  /// Chiama una funzione JavaScript in modo sicuro
  static Future<dynamic> _callJSFunction(
    String functionName, [
    List<dynamic>? args,
  ]) async {
    if (!kIsWeb || !_isDartJsAvailable()) {
      throw Exception('JavaScript calls supportate solo su web');
    }
    
    try {
      if (_hasJSProperty(functionName)) {
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
  static js.JsObject? _dateToJSDate(DateTime date) {
    if (!kIsWeb || !_isDartJsAvailable()) {
      return null;
    }
    
    try {
      // Verifica disponibilità Date constructor
      if (!_hasJSProperty('Date')) {
        throw Exception('Date constructor non disponibile');
      }
      
      final dynamic dateValue = js.context['Date'];
      if (dateValue == null) {
        throw Exception('Date constructor è null');
      }
      
      // Safe cast con controllo tipo
      if (dateValue is js.JsFunction) {
        return js.JsObject(dateValue, <int>[
          date.year,
          date.month - 1, // JavaScript usa mesi 0-based
          date.day,
          date.hour,
          date.minute,
          date.second,
          date.millisecond,
        ]);
      } else {
        throw Exception('Date non è una JsFunction');
      }
    } catch (e) {
      AppLogger.notificationError('Errore nella creazione Date JavaScript', e);
      throw Exception('Errore nella creazione Date JavaScript: $e');
    }
  }

  /// Programma le notifiche automatiche per i giorni gialli e rossi
  static Future<void> scheduleNotifications(
    DateTime startDate, {
    int cycleDays = 28,
  }) async {
    if (!kIsWeb) return;
    
    try {
      if (!_isNotificationSupported()) {
        AppLogger.notificationError('Notifiche non supportate');
        return;
      }

      final js.JsObject? jsDate = _dateToJSDate(startDate);
      if (jsDate == null) {
        AppLogger.notificationError('Impossibile convertire data per JavaScript');
        return;
      }

      // Chiama la funzione JavaScript per programmare le notifiche
      js.context.callMethod('scheduleNotifications', <dynamic>[
        jsDate,
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
    if (!kIsWeb) return;
    
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

  /// Verifica lo stato dei permessi per le notifiche
  static String getNotificationPermission() {
    if (!kIsWeb || !_isDartJsAvailable()) return 'not-supported';
    
    try {
      if (_isNotificationSupported()) {
        final dynamic notificationValue = js.context['Notification'];
        if (notificationValue is js.JsObject) {
          final dynamic permissionValue = notificationValue['permission'];
          return permissionValue?.toString() ?? 'unknown';
        }
      }
      return 'not-supported';
    } catch (e) {
      AppLogger.notificationError('Errore nel controllo dei permessi', e);
      return 'error';
    }
  }

  /// Mostra una notifica di test
  static Future<void> showTestNotification() async {
    if (!kIsWeb) return;
    
    try {
      if (!_isNotificationSupported()) {
        AppLogger.notificationError('Notifiche non supportate');
        return;
      }

      // Invia messaggio al Service Worker per mostrare notifica di test
      if (_hasJSProperty('navigator')) {
        final dynamic navigatorValue = js.context['navigator'];
        if (navigatorValue is js.JsObject && 
            _hasJSObjectProperty(navigatorValue, 'serviceWorker')) {
          
          try {
            final dynamic registrationValue = await js.context
                .callMethod('eval', <String>['navigator.serviceWorker.ready']);
            
            if (registrationValue is js.JsObject) {
              // Invia messaggio al SW
              registrationValue.callMethod('postMessage', <dynamic>[
                js.JsObject.jsify(<String, String>{
                  'type': 'SHOW_TEST_NOTIFICATION_NOW',
                  'title': '🧪 Test Sistema Anti-Nervoso',
                  'body': 'Notifica di test funzionante! 🎉',
                  'icon': 'icons/Icon-192.png'
                })
              ]);
            }
          } catch (e) {
            AppLogger.notificationError('Errore nell\\'accesso al service worker', e);
          }
        }
      }

      AppLogger.notificationInfo('Notifica di test inviata');
    } catch (e) {
      AppLogger.notificationError('Errore nell\\'invio della notifica di test', e);
    }
  }
}
```

---

## 🔧 **ALTERNATIVE MODERNE**

### **🚀 Opzione 1: js_interop (Raccomandato per Flutter 3.16+)**

```dart
import 'dart:js_interop';

@JS()
external JSWindow get window;

@JS()
external JSNavigator get navigator;

@JS()
@staticInterop
class JSWindow {}

@JS()
@staticInterop
class JSNavigator {}

extension JSNavigatorExtension on JSNavigator {
  external ServiceWorkerContainer get serviceWorker;
}
```

### **🚀 Opzione 2: Platform Channels**

```dart
// Per comunicazione più robusta con JavaScript
import 'package:flutter/services.dart';

class NotificationService {
  static const platform = MethodChannel('notifications');
  
  static Future<bool> initialize() async {
    if (!kIsWeb) return false;
    
    try {
      final bool result = await platform.invokeMethod('initialize');
      return result;
    } catch (e) {
      AppLogger.notificationError('Errore platform channel', e);
      return false;
    }
  }
}
```

---

## 📋 **CHECKLIST RISOLUZIONE**

### **✅ Passi da Seguire:**

1. **Verifica Flutter Version**
   ```bash
   flutter --version
   # Assicurati di usare Flutter 3.13+
   ```

2. **Aggiorna Dependencies**
   ```bash
   flutter pub get
   flutter pub upgrade
   ```

3. **Test Build Web**
   ```bash
   flutter build web --debug
   ```

4. **Verifica Browser Compatibility**
   - Chrome 80+
   - Firefox 75+
   - Safari 13+

5. **Test Runtime**
   ```bash
   flutter run -d chrome --web-port=8080
   ```

---

## 🎯 **RACCOMANDAZIONI FINALI**

### **🏆 Soluzione Migliore:**

1. **Usa la versione corretta** che ho fornito sopra
2. **Aggiungi error handling robusto**
3. **Testa su browser diversi**
4. **Considera migrazione a js_interop** per il futuro

### **🚨 Problemi da Evitare:**

- ❌ Non usare dart:js senza guard kIsWeb
- ❌ Non assumere che js.context sia sempre disponibile
- ❌ Non fare cast diretti senza controlli
- ❌ Non ignorare le eccezioni JavaScript

### **✅ Best Practices:**

- ✅ Sempre controllare kIsWeb prima di usare dart:js
- ✅ Usare try-catch per tutte le operazioni JS
- ✅ Verificare esistenza proprietà prima dell'accesso
- ✅ Implementare fallback per piattaforme non-web

**Implementa la versione corretta che ho fornito e i problemi con dart:js saranno risolti!** 🎯