# 🚀 Deploy su GitHub Pages

## 📋 **Guida Completa per Deploy**

Il tuo **Sistema Anti-Nervoso** è ora pronto per essere deployato su GitHub Pages **senza backend**!

### 🎯 **Preparazione Pre-Deploy**

#### 1. **Build Flutter Web**
```bash
flutter clean
flutter pub get
flutter build web --release
```

#### 2. **Verifica File Generati**
Controlla che nella cartella `build/web/` ci siano:
- ✅ `index.html`
- ✅ `sw.js` (il tuo Service Worker)
- ✅ `manifest.json`
- ✅ Cartella `assets/`
- ✅ File Flutter generati

### 🔧 **Opzioni di Deploy**

#### **Opzione A: Deploy dalla Cartella `web/` (Consigliata)**

1. **Configura GitHub Pages**:
   - Vai su **Settings** → **Pages**
   - **Source**: Deploy from a branch
   - **Branch**: `main`
   - **Folder**: `/ (root)` o `/docs`

2. **Struttura Repository**:
   ```
   nome_app/
   ├── lib/           # Codice Flutter
   ├── web/           # File web (index.html, sw.js)
   ├── build/web/     # Build generato
   └── docs/          # Copia di build/web per GitHub Pages
   ```

3. **Copia Build in docs/**:
   ```bash
   # Crea cartella docs se non esiste
   mkdir docs
   
   # Copia tutto da build/web a docs
   cp -r build/web/* docs/
   
   # Su Windows:
   # xcopy build\\web\\* docs\\ /E /I
   ```

#### **Opzione B: Deploy con GitHub Actions (Automatico)**

Crea `.github/workflows/deploy.yml`:

```yaml
name: Deploy Flutter Web

on:
  push:
    branches: [ main ]

jobs:
  build-and-deploy:
    runs-on: ubuntu-latest
    
    steps:
    - uses: actions/checkout@v3
    
    - uses: subosito/flutter-action@v2
      with:
        flutter-version: '3.16.0'
    
    - name: Install dependencies
      run: flutter pub get
    
    - name: Build web
      run: flutter build web --release
    
    - name: Deploy to GitHub Pages
      uses: peaceiris/actions-gh-pages@v3
      with:
        github_token: ${{ secrets.GITHUB_TOKEN }}
        publish_dir: ./build/web
```

### 🌐 **Configurazione Domini**

#### **URL GitHub Pages**
Il tuo sito sarà disponibile su:
```
https://[username].github.io/nome_app/
```

#### **Dominio Personalizzato (Opzionale)**
1. Crea file `CNAME` in `docs/`:
   ```
   tuodominio.com
   ```

2. Configura DNS del dominio:
   ```
   CNAME record: www → [username].github.io
   A record: @ → 185.199.108.153
   ```

### ✅ **Checklist Pre-Deploy**

- [ ] **Flutter build** completato senza errori
- [ ] **Service Worker** (`sw.js`) presente
- [ ] **Manifest** (`manifest.json`) configurato
- [ ] **Icone** presenti in `icons/`
- [ ] **Notifiche** testate localmente
- [ ] **Repository** pushato su GitHub

### 🧪 **Test Post-Deploy**

Dopo il deploy, testa:

1. **Caricamento App**: L'app si carica correttamente
2. **Service Worker**: Console mostra "Service Worker registrato"
3. **Permessi Notifiche**: Richiesta permessi funziona
4. **Notifica Test**: Pulsante test mostra notifica
5. **Programmazione**: Impostare data ciclo programma notifiche
6. **Persistenza**: Ricaricando la pagina, le notifiche restano attive

### 🔍 **Debug Problemi Comuni**

#### **Service Worker Non Carica**
```javascript
// Aggiungi in index.html per debug
navigator.serviceWorker.register('sw.js')
  .then(reg => console.log('SW registrato:', reg))
  .catch(err => console.error('Errore SW:', err));
```

#### **Notifiche Non Funzionano**
1. Verifica permessi browser
2. Controlla console per errori
3. Testa su HTTPS (GitHub Pages è HTTPS)

#### **Icone Mancanti**
Verifica che le icone siano in:
```
docs/
├── icons/
│   ├── Icon-192.png
│   ├── Icon-512.png
│   └── favicon.png
```

### 📱 **Test Multi-Piattaforma**

#### **Desktop**
- ✅ Chrome/Edge: Supporto completo
- ✅ Firefox: Supporto completo
- ⚠️ Safari: Limitazioni notifiche

#### **Mobile**
- ✅ Android Chrome: Supporto completo
- ⚠️ iOS Safari: Limitazioni notifiche web
- ✅ Android Firefox: Supporto completo

### 🎉 **Il Tuo Sito è Live!**

Una volta deployato, il tuo **Sistema Anti-Nervoso** sarà:
- 🌐 **Accessibile** da qualsiasi dispositivo
- 🔔 **Notifiche** funzionanti su desktop e Android
- 💾 **Dati persistenti** tramite localStorage
- ⚡ **Veloce** e responsive
- 🆓 **Gratuito** su GitHub Pages

### 🔗 **Link Utili**

- [GitHub Pages Docs](https://docs.github.com/en/pages)
- [Flutter Web Deployment](https://docs.flutter.dev/deployment/web)
- [Service Worker Guide](https://developer.mozilla.org/en-US/docs/Web/API/Service_Worker_API)

**Il tuo sistema è production-ready! 🚀**