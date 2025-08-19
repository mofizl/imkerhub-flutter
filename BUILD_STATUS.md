# ImkerHub Flutter iOS Deployment Status

## Aktueller Stand (19.08.2025)

### ✅ Erfolge
- **Build 25**: Erfolgreich zu TestFlight hochgeladen (mit Privacy-Warnungen)
- **Bundle ID korrekt**: `com.imkerhub.mofiz`
- **Manual Signing konfiguriert**: CODE_SIGN_STYLE = Manual
- **Provisioning Profile**: Dynamische Extraktion funktioniert ("ImkerHub App Store")
- **Development Team**: QX8XC3CNTR korrekt gesetzt
- **iOS Deployment Target**: 13.0 (kompatibel mit Dependencies)

### ❌ Aktuelle Probleme

#### 1. Certificate Import Fehler
```
security: SecKeychainItemImport: MAC verification failed during PKCS12 import (wrong password?)
```
- **Ursache**: P12 Certificate oder Passwort in GitHub Secrets beschädigt/falsch
- **Seit**: Build 26+ (Build 25 war erfolgreich)

#### 2. iOS Platform Inkonsistenz auf GitHub Actions
- macOS Runner haben iOS SDK verfügbar, aber "iOS 18.0 is not installed" Fehler
- **Workaround**: macos-14 Runner verwenden (aktuell aktiv)

### 📧 Apple Feedback zu Build 25
**E-Mail von Apple Developer Relations erhalten:**
- App wurde erfolgreich hochgeladen aber mit Warnungen
- **Fehlende Privacy Descriptions** (bereits behoben in neueren Builds):
  - `NSMicrophoneUsageDescription` ✅ behoben
  - `NSSpeechRecognitionUsageDescription` ✅ behoben
  - `NSLocationAlwaysAndWhenInUseUsageDescription` ✅ behoben  
  - `NSLocationWhenInUseUsageDescription` ✅ behoben

### 🔧 Technische Konfiguration

#### GitHub Secrets (benötigt)
1. `IOS_CERTIFICATE_BASE64` - **❌ Problem hier**
2. `IOS_CERTIFICATE_PASSWORD` - **❌ Möglicherweise falsch**
3. `IOS_PROVISIONING_PROFILE_BASE64` - ✅ funktioniert
4. `KEYCHAIN_PASSWORD` - ✅ funktioniert
5. `APP_STORE_CONNECT_API_KEY_ID` - ✅ funktioniert
6. `APP_STORE_CONNECT_API_ISSUER_ID` - ✅ funktioniert  
7. `APP_STORE_CONNECT_API_KEY_BASE64` - ✅ funktioniert

#### App Store Connect Details
- **App Name**: ImkerHub
- **Bundle ID**: com.imkerhub.mofiz
- **Team ID**: QX8XC3CNTR
- **Apple ID**: 6751213422

#### Workflow Konfiguration
- **Runner**: macos-14 (für stabile iOS Platform)
- **Flutter Version**: 3.24.3
- **Build Method**: `flutter build ipa --release --export-options-plist=ci/ExportOptions.plist`

### 🚨 Nächste Schritte

#### Priorität 1: Certificate Problem lösen
**Option A - Certificate neu erstellen:**
1. Suchen Sie das P12 Certificate auf Ihrem Desktop (`.p12` Datei)
2. Falls nicht gefunden: Aus Keychain Access exportieren
   - Öffnen Sie "Keychain Access" (Schlüsselbundverwaltung)
   - Suchen Sie "iPhone Distribution"
   - Rechtsklick → "Exportieren" → Format: ".p12"
3. Base64 kodieren und GitHub Secret aktualisieren

**Option B - Passwort prüfen:**
- Das Certificate Passwort in `IOS_CERTIFICATE_PASSWORD` könnte falsch sein

#### Priorität 2: Build testen
Nach Certificate-Fix sollte der Build:
1. ✅ Certificate korrekt importieren
2. ✅ iOS Platform Problem umgehen (macos-14)
3. ✅ Mit Privacy Descriptions zu TestFlight uploaden
4. ✅ Ohne Apple-Warnungen erscheinen

### 📊 Build Historie
- **Build 1-24**: Verschiedene Deployment-Probleme
- **Build 25**: ✅ Erfolgreich hochgeladen (mit Privacy-Warnungen)
- **Build 26+**: ❌ Certificate Import Fehler

### 🔍 Debug-Informationen
```yaml
# Aktueller Workflow Path
.github/workflows/ios_build.yml

# Wichtige Dateien
ios/Runner/Info.plist - Privacy Descriptions ✅
ios/Runner.xcodeproj/project.pbxproj - Manual Signing ✅  
ci/ExportOptions.plist - Export Konfiguration ✅
```

### 💡 Lessons Learned
1. **GitHub Actions macOS Runner sind inkonsistent** - macos-14 ist stabiler
2. **Certificate Import ist fragil** - kleine Änderungen an Base64 brechen es
3. **Privacy Descriptions sind Pflicht** - Apple lehnt Builds ohne sie ab
4. **Bundle ID muss exakt mit Provisioning Profile übereinstimmen**
5. **Manual Signing ist für CI/CD erforderlich**

---
*Status erstellt am: 19.08.2025 18:30*
*Letzter erfolgreicher Build: Build 25*
*Aktuelles Problem: Certificate Import*