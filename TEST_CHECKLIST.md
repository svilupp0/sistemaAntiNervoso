# ✅ Checklist Test Sistema Anti-Nervoso

## 🚀 **Comandi di Test da Eseguire**

### **1. Pulizia e Reinstallazione**
```bash
# Pulisci tutto
flutter clean

# Reinstalla dipendenze
flutter pub get

# Verifica dipendenze
flutter pub deps
```

### **2. Analisi Codice**
```bash
# Analizza il codice per errori
flutter analyze

# Se ci sono warning, sono normali per il downgrade
```

### **3. Test Build Web**
```bash
# Test build web
flutter build web --release

# Verifica che la build sia completata senza errori
```

### **4. Test Locale**
```bash
# Avvia l'app in Chrome
flutter run -d chrome

# Oppure se hai altri browser configurati:
flutter run -d web-server --web-port 8080
```

## 🧪 **Test Funzionalità da Verificare**

### **✅ Caricamento App**
- [ ] L'app si carica senza errori
- [ ] Interfaccia arcobaleno visibile
- [ ] Emoji fluttuanti animate
- [ ] Titolo "Sistema Anti-Nervoso 😎" presente

### **✅ Funzionalità Base**
- [ ] Pulsante "Scegli data del ciclo" funziona
- [ ] Date picker si apre correttamente
- [ ] Selezione data salva correttamente
- [ ] Calendario umore si genera

### **✅ Sistema Notifiche**
- [ ] Sezione notifiche visibile
- [ ] Pulsante "Attiva" presente se disattivate
- [ ] Click su "Attiva" richiede permessi browser
- [ ] Dopo attivazione, stato cambia in "Notifiche attive 🔔"
- [ ] Pulsante "Test" appare dopo attivazione
- [ ] Click su "Test" mostra notifica di prova

### **✅ Persistenza Dati**
- [ ] Ricaricando la pagina, data ciclo rimane salvata
- [ ] Stato notifiche persiste dopo ricaricamento
- [ ] Calendario mantiene i colori corretti

### **✅ Console Browser**
- [ ] Apri DevTools (F12)
- [ ] Vai su Console
- [ ] Verifica messaggi:
  - "Service Worker registrato con successo"
  - "Servizio notifiche inizializzato con successo"
  - "Notifiche programmate per il ciclo: [data]"

## 🔍 **Test Specifici Notifiche**

### **Test 1: Attivazione Notifiche**
1. Apri l'app
2. Click su "Attiva" nella sezione notifiche
3. **Aspettato**: Browser chiede permesso notifiche
4. Accetta il permesso
5. **Aspettato**: Messaggio "✅ Notifiche attivate con successo!"
6. **Aspettato**: Icona cambia in verde con "Notifiche attive 🔔"

### **Test 2: Notifica di Test**
1. Con notifiche attive, click su "Test"
2. **Aspettato**: Notifica appare con:
   - Titolo: "🧪 Test Sistema Anti-Nervoso"
   - Messaggio: "Notifica di test funzionante! 🎉"
3. **Aspettato**: Messaggio "🧪 Notifica di test inviata!"

### **Test 3: Programmazione Automatica**
1. Imposta una data del ciclo
2. **Aspettato**: Messaggio "🔔 Notifiche programmate per giorni gialli e rossi!"
3. Controlla console per: "Notifiche programmate per il ciclo: [data]"

## 🐛 **Risoluzione Problemi Comuni**

### **Errore: "Notifiche non supportate"**
- **Causa**: Browser non supporta notifiche
- **Soluzione**: Usa Chrome, Firefox, o Edge

### **Errore: Permessi negati**
- **Causa**: Hai negato i permessi
- **Soluzione**: 
  1. Click sull'icona 🔒 nella barra indirizzi
  2. Abilita notifiche
  3. Ricarica la pagina

### **Errore: Service Worker non carica**
- **Causa**: Problema HTTPS o cache
- **Soluzione**:
  1. Apri DevTools → Application → Service Workers
  2. Click "Unregister" se presente
  3. Ricarica pagina

### **Build fallisce**
- **Causa**: Dipendenze non aggiornate
- **Soluzione**:
  ```bash
  flutter clean
  flutter pub get
  flutter pub upgrade
  ```

## 📊 **Report Test**

Dopo aver completato i test, segna qui:

### **Ambiente di Test:**
- [ ] Windows Chrome
- [ ] Windows Edge  
- [ ] Windows Firefox
- [ ] Mobile Android Chrome
- [ ] Mobile iOS Safari

### **Funzionalità Testate:**
- [ ] ✅ Caricamento app
- [ ] ✅ Selezione data ciclo
- [ ] ✅ Attivazione notifiche
- [ ] ✅ Test notifiche
- [ ] ✅ Persistenza dati
- [ ] ✅ Build web

### **Problemi Riscontrati:**
```
[Scrivi qui eventuali problemi]
```

## 🎉 **Se Tutto Funziona:**

Il tuo **Sistema Anti-Nervoso** è pronto per:
- ✅ **Deploy su GitHub Pages**
- ✅ **Uso in produzione**
- ✅ **Condivisione con altri**

### **Prossimo Step: Deploy**
```bash
# Crea cartella docs per GitHub Pages
mkdir docs

# Copia build in docs
cp -r build/web/* docs/

# Commit e push
git add .
git commit -m "Deploy ready"
git push origin main
```

**Buon testing! 🚀**