// web/sw.js - Service Worker per Sistema Anti-Nervoso

// Gestione notifiche push dal server
self.addEventListener('push', (event) => {
  let data = {};
  try { data = event.data ? event.data.json() : {}; } catch (_) {}
  const title = data.title || 'Sistema Anti-Nervoso';
  const body = data.body || 'Promemoria ciclo';
  const icon = data.icon || 'icons/Icon-192.png';
  const badge = data.badge || 'icons/Icon-192.png';

  event.waitUntil(
    self.registration.showNotification(title, {
      body,
      icon,
      badge,
      data: data.clickUrl || './',
    })
  );
});

// Gestione click su notifiche
self.addEventListener('notificationclick', (event) => {
  event.notification.close();
  const url = event.notification.data || '/';
  event.waitUntil(clients.openWindow(url));
});

// Gestione messaggi dall'app per programmare notifiche
self.addEventListener('message', (event) => {
  if (event.data && event.data.type === 'SCHEDULE_NOTIFICATIONS') {
    const { startDate, cycleDays } = event.data;
    // Prima cancella le notifiche esistenti
    clearScheduledNotifications();
    // Poi programma le nuove
    scheduleNotifications(startDate, cycleDays);
  }
  
  if (event.data && event.data.type === 'CLEAR_NOTIFICATIONS') {
    clearScheduledNotifications();
  }
  
  if (event.data && event.data.type === 'SHOW_TEST_NOTIFICATION_NOW') {
    const title = event.data.title || '🧪 Test notifica';
    const body = event.data.body || 'Notifica di test dal Service Worker';
    const icon = event.data.icon || 'icons/Icon-192.png';
    
    self.registration.showNotification(title, {
      body: body,
      icon: icon,
      badge: 'icons/Icon-192.png',
      requireInteraction: false,
      vibrate: [200, 100, 200],
      data: './'
    });
  }
});

// Funzione per programmare le notifiche automatiche
function scheduleNotifications(startDateStr, cycleDays) {
  const startDate = new Date(startDateStr);
  const now = new Date();
  
  // Giorni gialli e rossi secondo la logica dell'app
  const yellowDays = [1, 2, 13, 14, 22, 23, 24, 25]; // giorni del ciclo
  const redDays = [26, 27, 28]; // giorni del ciclo
  
  // Programma notifiche per i prossimi 3 cicli
  for (let cycle = 0; cycle < 3; cycle++) {
    const cycleStart = new Date(startDate);
    cycleStart.setDate(startDate.getDate() + (cycle * cycleDays));
    
    // Notifiche gialle
    yellowDays.forEach(day => {
      const notificationDate = new Date(cycleStart);
      notificationDate.setDate(cycleStart.getDate() + (day - 1));
      
      if (notificationDate > now) {
        const delay = notificationDate.getTime() - now.getTime();
        scheduleNotification(delay, {
          title: '🟡 Sistema Anti-Nervoso',
          body: 'Attenzione! Oggi potrebbe essere infastidita 😕',
          icon: '/icons/Icon-192.png',
          badge: '/icons/badge.png',
          tag: `yellow-${cycle}-${day}`
        });
      }
    });
    
    // Notifiche rosse
    redDays.forEach(day => {
      const notificationDate = new Date(cycleStart);
      notificationDate.setDate(cycleStart.getDate() + (day - 1));
      
      if (notificationDate > now) {
        const delay = notificationDate.getTime() - now.getTime();
        scheduleNotification(delay, {
          title: '🔴 PERICOLO - Sistema Anti-Nervoso',
          body: 'MASSIMA CAUTELA! Oggi è incavolata nera ⚠️😡',
          icon: '/icons/Icon-192.png',
          badge: '/icons/badge.png',
          tag: `red-${cycle}-${day}`
        });
      }
    });
  }
}

// Funzione per programmare una singola notifica
function scheduleNotification(delay, options) {
  const timeoutId = setTimeout(() => {
    self.registration.showNotification(options.title, {
      body: options.body,
      icon: options.icon,
      badge: options.badge,
      tag: options.tag,
      requireInteraction: true, // Notifica persistente
      vibrate: [200, 100, 200], // Vibrazione
      data: './'
    });
    // Rimuovi il timeout completato dalla mappa
    scheduledTimeouts.delete(options.tag);
  }, delay);
  
  // Salva il timeout ID per poterlo cancellare se necessario
  scheduledTimeouts.set(options.tag, timeoutId);
}

// Storage per gestire i timeout delle notifiche
let scheduledTimeouts = new Map();

// Funzione per cancellare notifiche programmate
function clearScheduledNotifications() {
  // Cancella tutti i timeout programmati
  scheduledTimeouts.forEach((timeoutId, key) => {
    clearTimeout(timeoutId);
  });
  scheduledTimeouts.clear();
  console.log('Tutte le notifiche programmate sono state cancellate');
}

console.log('Service Worker Sistema Anti-Nervoso caricato con successo!');

// Gestione installazione SW
self.addEventListener('install', (event) => {
  console.log('Service Worker installato');
  self.skipWaiting();
});

// Gestione attivazione SW
self.addEventListener('activate', (event) => {
  console.log('Service Worker attivato');
  event.waitUntil(self.clients.claim());
});