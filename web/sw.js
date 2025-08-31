// web/sw.js
self.addEventListener('push', (event) => {
  let data = {};
  try { data = event.data ? event.data.json() : {}; } catch (_) {}
  const title = data.title || 'Sistema Anti-Nervoso';
  const body = data.body || 'Promemoria ciclo';
  const icon = data.icon || '/icons/Icon-192.png';
  const badge = data.badge || '/icons/badge.png'; // opzionale se ce l'hai

  event.waitUntil(
    self.registration.showNotification(title, {
      body,
      icon,
      badge,
      data: data.clickUrl || '/',
    })
  );
});

self.addEventListener('notificationclick', (event) => {
  event.notification.close();
  const url = event.notification.data || '/';
  event.waitUntil(clients.openWindow(url));
});