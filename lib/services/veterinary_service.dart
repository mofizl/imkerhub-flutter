import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:geolocator/geolocator.dart';

class VeterinaryService {
  static const Map<String, String> veterinaryOffices = {
    'Baden-Württemberg': 'Landratsamt Stuttgart - Veterinäramt',
    'Bayern': 'Landratsamt München - Veterinäramt',
    'Berlin': 'Landesamt für Gesundheit und Soziales Berlin',
    'Brandenburg': 'Landesamt für Arbeitsschutz, Verbraucherschutz und Gesundheit',
    'Bremen': 'Freie Hansestadt Bremen - Veterinäramt',
    'Hamburg': 'Freie und Hansestadt Hamburg - Veterinäramt',
    'Hessen': 'Regierungspräsidium Darmstadt - Veterinäramt',
    'Mecklenburg-Vorpommern': 'Landesamt für Landwirtschaft, Lebensmittelsicherheit und Fischerei',
    'Niedersachsen': 'Niedersächsisches Landesamt für Verbraucherschutz und Lebensmittelsicherheit',
    'Nordrhein-Westfalen': 'Landesamt für Natur, Umwelt und Verbraucherschutz',
    'Rheinland-Pfalz': 'Landesuntersuchungsamt Rheinland-Pfalz',
    'Saarland': 'Landesamt für Verbraucherschutz',
    'Sachsen': 'Sächsisches Staatsministerium für Soziales und Gesellschaftlichen Zusammenhalt',
    'Sachsen-Anhalt': 'Landesamt für Verbraucherschutz Sachsen-Anhalt',
    'Schleswig-Holstein': 'Landesamt für soziale Dienste',
    'Thüringen': 'Thüringer Landesamt für Verbraucherschutz',
  };

  static Future<String?> findNearestVeterinaryOffice(double latitude, double longitude) async {
    try {
      final locationResult = await getGermanStateFromGPS(latitude, longitude);
      return veterinaryOffices[locationResult];
    } catch (e) {
      // print('Error finding veterinary office: $e');
      return null;
    }
  }

  static Future<String> getGermanStateFromGPS(double latitude, double longitude) async {
    try {
      final url = Uri.parse(
        'https://nominatim.openstreetmap.org/reverse?format=json&lat=$latitude&lon=$longitude&zoom=10&addressdetails=1'
      );
      
      final response = await http.get(url, headers: {
        'User-Agent': 'ImkerHub/1.0.0 (Beekeeping App)',
      });

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final address = data['address'];
        
        if (address != null) {
          final state = address['state'] ?? address['province'];
          if (state != null) {
            // Map common state variations to standardized names
            switch (state.toLowerCase()) {
              case 'baden-württemberg':
              case 'baden-wurttemberg':
                return 'Baden-Württemberg';
              case 'bayern':
              case 'bavaria':
                return 'Bayern';
              case 'nordrhein-westfalen':
              case 'north rhine-westphalia':
                return 'Nordrhein-Westfalen';
              case 'rheinland-pfalz':
              case 'rhineland-palatinate':
                return 'Rheinland-Pfalz';
              default:
                return state;
            }
          }
        }
      }
      
      // Fallback based on coordinates
      return _getStateByCoordinates(latitude, longitude);
    } catch (e) {
      // print('Error in reverse geocoding: $e');
      return _getStateByCoordinates(latitude, longitude);
    }
  }

  static String _getStateByCoordinates(double latitude, double longitude) {
    // Simplified coordinate-based state detection for Germany
    if (latitude >= 53.5 && longitude <= 10.0) return 'Schleswig-Holstein';
    if (latitude >= 53.0 && longitude <= 11.5) return 'Niedersachsen';
    if (latitude >= 52.0 && latitude < 53.5 && longitude >= 11.5) return 'Mecklenburg-Vorpommern';
    if (latitude >= 51.5 && latitude < 53.0 && longitude >= 11.5) return 'Brandenburg';
    if (latitude >= 52.3 && latitude <= 52.7 && longitude >= 13.0 && longitude <= 13.8) return 'Berlin';
    if (latitude >= 50.0 && latitude < 52.0 && longitude >= 6.0 && longitude < 12.0) return 'Nordrhein-Westfalen';
    if (latitude >= 49.0 && latitude < 51.5 && longitude >= 8.0 && longitude < 10.5) return 'Hessen';
    if (latitude >= 48.0 && latitude < 50.5 && longitude >= 6.0 && longitude < 8.5) return 'Rheinland-Pfalz';
    if (latitude >= 49.0 && latitude < 50.0 && longitude >= 6.0 && longitude < 7.5) return 'Saarland';
    if (latitude >= 47.0 && latitude < 50.0 && longitude >= 8.0 && longitude < 13.5) return 'Baden-Württemberg';
    if (latitude >= 47.0 && latitude < 51.0 && longitude >= 8.5) return 'Bayern';
    if (latitude >= 50.0 && latitude < 52.0 && longitude >= 11.5) return 'Sachsen';
    if (latitude >= 50.5 && latitude < 52.5 && longitude >= 10.0 && longitude < 12.5) return 'Sachsen-Anhalt';
    if (latitude >= 50.0 && latitude < 51.5 && longitude >= 9.5 && longitude < 12.5) return 'Thüringen';
    
    return 'Baden-Württemberg'; // Default fallback
  }

  static Future<Position?> getCurrentPosition() async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        return null;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          return null;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        return null;
      }

      return await Geolocator.getCurrentPosition();
    } catch (e) {
      // print('Error getting location: $e');
      return null;
    }
  }
}