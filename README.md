# ImkerHub Flutter

Digitale Stockkartenverwaltung für Imker - Flutter Version

## Features

- 🐝 Völkerverwaltung mit detaillierter Stockkarten-Ansicht
- 📍 Standorteverwaltung mit GPS-Integration
- 🎤 Spracherkennung für Völkerkontrollen  
- 📊 Analytics & Charts mit Volksstärke-Trends
- 👑 Königinnen-Detailkarten mit Zuchtinformationen
- 🏥 Automatisches Veterinäramt-Lookup

## GitHub Actions iOS Build

### Voraussetzungen

1. **Apple Developer Account** (99€/Jahr)
2. **App Store Connect API Key**
3. **iOS Distribution Certificate**
4. **Provisioning Profile**

### Setup Schritte

1. **Repository Secrets einrichten:**
   ```
   IOS_CERTIFICATE_BASE64          # P12 Certificate (base64 encoded)
   IOS_CERTIFICATE_PASSWORD        # P12 Password
   IOS_PROVISIONING_PROFILE_BASE64 # Provisioning Profile (base64 encoded)
   KEYCHAIN_PASSWORD               # Any secure password
   APP_STORE_CONNECT_API_KEY_ID    # API Key ID
   APP_STORE_CONNECT_API_ISSUER_ID # Issuer ID
   APP_STORE_CONNECT_API_KEY_BASE64 # P8 Key file (base64 encoded)
   ```

2. **Team ID aktualisieren:**
   - `ci/ExportOptions.plist` bearbeiten
   - `YOUR_TEAM_ID` durch echte Team ID ersetzen

3. **Bundle Identifier setzen:**
   - In `ios/Runner/Info.plist`
   - Eindeutige ID wie `com.yourname.imkerhub`

### Build auslösen

- Push zu `main` branch = automatischer Build
- Oder manuell über GitHub Actions Tab

## Lokale Entwicklung

```bash
flutter pub get
flutter run -d chrome  # Web
flutter run -d windows # Windows (Developer Mode nötig)
```

## Build Status

![iOS Build](https://github.com/USERNAME/REPO/workflows/iOS%20Build%20and%20Deploy/badge.svg)